{
  config,
  inputs,
  pkgs,
  secrets,
  ...
}: {
  my.system = {
    environment = "corp";
    hasDeterminate = true;
  };

  imports = [
    ./common.nix
    ../modules/fonts.nix
    ../modules/terminal
  ];

  home.sessionVariables = with secrets; {
    GOOGLE_CLOUD_PROJECT_ID = googleCloudProjectID;
    GEMINI_API_KEY = geminiAPIKey;
  };
}
