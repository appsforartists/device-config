{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  name = "restart-into-windows";
in {
  config = {
    environment.systemPackages = with pkgs; [
      efibootmgr
      (
        writeShellApplication {
          name = name;
          text = ''
            bootctl set-oneshot auto-windows;
            systemctl reboot;
          '';
        }
      )
      (stdenv.mkDerivation {
        name = "${name}-alias";
        unpackPhase = ''
          # source is inline, so skip downloading
        '';
        desktopItems = [
          (makeDesktopItem {
            name = name;
            desktopName = "Windows XP";
            exec = name;
          })
        ];
        nativeBuildInputs = [copyDesktopItems];
      })
    ];
  };
}
