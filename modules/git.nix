{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Brenton Simpson";
        email = "appsforartists@google.com";
      };
    };

    home = {
      packages = with pkgs; [
        alejandra
      ];
    };
  };
}
