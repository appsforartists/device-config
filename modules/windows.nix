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
            desktopName = "Windows";
            exec = ''
              efibootmgr -n \$\(efibootmgr \| grep -Pom 1 \"\(\?\<=Boot\)[[:xdigit:]]{4}\(\?=. Windows\)\"\)\; systemctl restart\;
            '';
          })
        ];
        nativeBuildInputs = [copyDesktopItems];
      })
    ];
  };
}
