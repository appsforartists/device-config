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
              systemctl reboot --boot-loader-entry=auto-windows
            '';
          })
        ];
        nativeBuildInputs = [copyDesktopItems];
      })
    ];

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.set-reboot-to-boot-loader-entry") {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
