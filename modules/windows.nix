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
      (stdenv.mkDerivation {
        name = name;
        unpackPhase = ''
          # source is inline, so skip downloading
        '';
        desktopItems = [
          (makeDesktopItem {
            name = name;
            desktopName = "Windows XP";
            exec = ''
              bootctl set-oneshot auto-windows\; systemctl reboot\;
            '';
          })
        ];
        nativeBuildInputs = [copyDesktopItems];
      })
    ];
  };
}
