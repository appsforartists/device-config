{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = {
    home = {
      packages = with pkgs; [
        gemini-cli
      ];
    };

    xdg.configFile."gemini/settings.json".text = builtins.toJSON {
      contextFileName = "AGENTS.md";
      security = {
        auth = {
          selectedType = "oauth-personal";
        };
      };
    };
  };
}
