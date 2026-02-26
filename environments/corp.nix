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
    };
  };
}
