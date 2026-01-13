{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./ghostty.nix
    ./zsh.nix
    ./starship.nix
  ];
}
