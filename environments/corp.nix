{
  config,
  inputs,
  lib,
  pkgs,
  secrets,
  ...
}: {
  imports = [
    ./common.nix
  ];

  config = lib.my.byPlatform {
    common = {
      my.system = {
        environment = "corp";
        hasDeterminate = true;
      };

      home.sessionVariables = with secrets; {
        GOOGLE_CLOUD_PROJECT_ID = googleCloudProjectID;
        GEMINI_API_KEY = geminiAPIKey;
      };
    };

    linux = {
      my.system.terminalBackgroundColor = "#5D007F";

      # # Setup:
      # sudo apt install flatpak
      # flatpak permission-set kde-authorized remote-desktop "" yes
      # echo "vgem" | sudo tee /etc/modules-load.d/crd-vgem.conf
      # sudo usermod -aG video,render $USER
      # systemctl reboot
      home.sessionVariables = {
        CHROME_REMOTE_DESKTOP_USE_WAYLAND = "KDE";
      };

      home.packages = with pkgs; [
        (writeShellScriptBin "kwin_wayland" ''
          # Chrome Remote Desktop requires KWin Wayland to run with the headless
          # (--virtual) backend. Execute the real kwin_wayland with --virtual
          # and other passed arguments.
          exec /usr/bin/kwin_wayland --virtual "$@"
        '')
      ];
    };
  };
}
