{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = lib.mkMerge [
    {
      initrd.kernelModules = ["amdgpu"];
      loader = {
        systemd-boot = {
          enable = true;
          # "1" fixes the orientation, but the text is unfortunately small.
          # "max" also fixes the orientation, but stretches the text to fill the
          # screen.
          # The text is clipped no matter which option you choose.
          consoleMode = "max";
          # the docs say to turn this off on modern systems for a more secure
          # setup.
          editor = false;
        };
        efi.canTouchEfiVariables = true;
      };
      # doesn't seem to be useful yet
      # extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];
    }

    # modern devices require modern kernels
    # (the screen will go into epilepsy mode if you use the standard kernel)
    (lib.mkIf (lib.versionOlder pkgs.linux.version "6.6") {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_6_6;
      kernelPatches = [
        rec {
          name = "legion-go-display-quirk";
          patch = pkgs.fetchpatch {
            name = name + ".patch";
            url = "https://github.com/appsforartists/linux/compare/master...legion-go-display-quirk.patch";
            sha256 = "sha256-BfqrFUQutcTMlzQdsKvOLhRUIo+63S1imWab4QjBO6c=";
          };
        }
        rec {
          name = "legion-go-controllers";
          patch = pkgs.fetchpatch {
            name = name + ".patch";
            url = "https://github.com/appsforartists/linux/compare/master...legion-go-controllers.patch";
            sha256 = "sha256-2OX8hlsjbqANV1cwZjT4+e5pvLGSNQ/Eh92HK9yT6z4=";

            # with logging
            # sha256 = "sha256-BfqrFUQutcTMlzQdsKvOLhRUIo+63S1imWab4QjBO6c=";
          };
        }
      ];
    })
  ];

  services.handheldDaemon.enable = true;

  # This is for sublime4 and should be migrated to home-manager as
  # `permittedInsecurePackages = [`
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  environment.systemPackages = with pkgs; [
    git
    toybox

    protontricks
    # maliit-keyboard
    libsForQt5.mauiPackages.station
    libsForQt5.mauiPackages.index

    libsForQt5.plasma-settings
    # libsForQt5.plasma-remotecontrollers

    google-chrome

    ## TODO: investigate insecure openssl dependency
    sublime4

    p7zip
    lenovo-legion
    hwinfo
    bluez
    usbutils
    hidrd
    linuxConsoleTools
    joystickwake
    jstest-gtk
    sdl-jstest
  ];

  hardware.opengl.driSupport = true;

  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  powerManagement.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false; #forcing to make plasma-mobile deal with it
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
