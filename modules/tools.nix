{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    home = {
      packages = with pkgs; [
        gemini-cli
        rmate
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
