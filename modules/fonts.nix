{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = {
    fonts.fontconfig.enable = true;
    home = {
      packages = with pkgs; [
        inconsolata
        noto-fonts-color-emoji
      ];
    };
  };
}
