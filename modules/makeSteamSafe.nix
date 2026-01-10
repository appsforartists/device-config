# Nix programs are hardwired to look for graphics drivers in NixOS's
# `/run/opengl-driver/lib`.  (They're not built into the derivation because
# AMD and nVIDIA use different ones - the derivation only contains a tool to
# lookup the drivers: vulkan-loader or libglvnd.)   `/run` is immutable on stock
# SteamOS.
#
# The driver path can be overridden by the environment with `LD_LIBRARY_PATH`;
# in fact, that's how SteamOS usually provides its drivers.  However, Nix
# programs are built against the versions of Mesa and glibc in nixpkgs.  If
# that's newer than what SteamOS offers, the game won't open.  (This is why the
# "Play" button turns immediately back to its idle green state when you tap it.)
#
# This wrapper merges both approaches: it populates an `LD_LIBRARY_PATH` with
# the driver versions that Nix expects and overrides the one provided by Steam.
{
  lib,
  pkgs,
}: {pkg}: let
  binaryName = pkg.meta.mainProgram or pkg.pname;
  driverPath = lib.makeLibraryPath [
    pkgs.mesa
    pkgs.libglvnd
  ];
  driPath = "${pkgs.mesa}/lib/dri";
in
  pkgs.runCommand "${pkg.name}-steam-safe" {
    nativeBuildInputs = [
      pkgs.gcc
      pkgs.glibc.static
      pkgs.xorg.lndir
    ];
    meta = pkg.meta;
  } ''
    # To override Vulkan drivers from environ, you need to explicitly enumerate
    # the Vulkan files.
    VULKAN_JSONS=$(find ${pkgs.mesa}/share/vulkan/icd.d -name "*.json" | tr '\n' ':')

    mkdir -p $out/bin

    # Nix's copy of bash is fragile to the same version mismatches as its
    # graphics drivers.  Patching environ in static C yields a result that is
    # impervious to whatever glibc version exists in the host system.
    cat > wrapper.c <<EOF
    #include <stdlib.h>
    #include <unistd.h>
    #include <stdio.h>

    int main(int argc, char **argv) {
        // Steam uses this to monkeypatch binaries; however, it's fragile to the
        // same glibc version mismatch crash as LD_LIBRARY_PATH, so it must be
        // unset.
        unsetenv("LD_PRELOAD");

        setenv("LD_LIBRARY_PATH",  "${driverPath}", 1);
        setenv("LIBGL_DRIVERS_PATH",  "${driPath}", 1);
        setenv("VK_DRIVER_FILES",  "$VULKAN_JSONS", 1);
        setenv("VK_ICD_FILENAMES", "$VULKAN_JSONS", 1);

        char *target = "${pkg}/bin/${binaryName}";

        argv[0] = target;
        execv(target, argv);

        perror("Failed to launch game");
        return 1;
    }
    EOF
    gcc -static wrapper.c -o $out/bin/${binaryName}

    # passthrough {pkg}'s desktopItems
    if [ -d "${pkg}/share" ]; then
      mkdir -p $out/share

      # populate $out/share with recursive symlinks to upstream {pkg}
      lndir -silent "${pkg}/share" "$out/share"

      if [ -d "$out/share/applications" ]; then
        for file in "$out/share/applications/"*.desktop; do
          # replace the symlink with a copy of the original desktopItem
          filename=$(basename "$file")
          rm "$file"
          cp "${pkg}/share/applications/$filename" "$file"
          chmod +w "$file"

          # update the paths to point at the Steam-safe version
          sed -i "s|${pkg}|$out|g" "$file"
        done
      fi
    fi
  ''
