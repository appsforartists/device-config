{
  config,
  lib,
  pkgs,
  ...
}: let
  steamos-headers = pkgs.stdenv.mkDerivation {
    pname = "steamos-headers";
    version = "6.11.11.valve27-1";

    src = pkgs.fetchurl {
      url = "https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter-3.7/os/x86_64/linux-neptune-611-headers-6.11.11.valve27-1-x86_64.pkg.tar.zst";
      hash = "sha256-xju8ZGBt29inMk0MfaNrUnQD3GpkakwwUr2UMBth3H8=";
    };

    nativeBuildInputs = with pkgs; [
      zstd
      autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      zlib
      stdenv.cc.cc.lib
      elfutils
      openssl
    ];

    unpackPhase = "tar --use-compress-program=zstd -xf $src";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r usr/lib/modules/*/build/* $out/
    '';
  };

  hid-sony = pkgs.stdenv.mkDerivation {
    pname = "hid-sony";
    version = "rb2-instruments";

    nativeBuildInputs = [pkgs.pahole];

    src = pkgs.fetchFromGitHub {
      "owner" = "Rosalie241";
      "repo" = "hid-sony";
      "rev" = "c2ee908bfd98439c52b0f6a53b771ae4d0ef3455";
      "hash" = "sha256-6iZmbA3fmcaNo6FwAHqpVE1O3oAMxeRSN/eAGs65wjE=";
    };

    # fixup the hid-sony module to work on Linux 6.11
    postPatch = ''
      substituteInPlace hid-sony.c \
        --replace-fail "<linux/unaligned.h>" "<asm/unaligned.h>" \
        --replace-fail "timer_container_of" "from_timer" \
        --replace-fail "static const u8 *motion_fixup" "static u8 *motion_fixup" \
        --replace-fail "static const u8 *ps3remote_fixup" "static u8 *ps3remote_fixup" \
        --replace-fail "static const u8 *sony_report_fixup" "static u8 *sony_report_fixup"
    '';

    buildPhase = "make -C ${steamos-headers} M=$(pwd) modules";

    installPhase = ''
      mkdir -p $out
      cp hid-sony.ko $out/
    '';
  };
in {
  systemd.user.services.rock-band-instruments = {
    # # Setup:
    # echo "blacklist hid_sony" | sudo tee /etc/modprobe.d/blacklist-hid-sony.conf
    # echo "deck ALL=(root) NOPASSWD: /usr/bin/insmod, /usr/bin/rmmod" | sudo tee /etc/sudoers.d/zz-kmod
    # sudo chmod 0440 /etc/sudoers.d/zz-kmod

    Service = {
      ExecStart = "/usr/bin/sudo /usr/bin/insmod ${hid-sony}/hid-sony.ko";
      ExecStop = "-/usr/bin/sudo /usr/bin/rmmod hid_sony";
      Type = "oneshot";
      RemainAfterExit = true;
    };

    Unit = {
      After = ["default.target"];
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
