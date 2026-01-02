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
  };
}
