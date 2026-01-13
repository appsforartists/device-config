{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./direnv.nix
    ./ghostty.nix
    ./starship.nix
    ./zsh.nix
  ];
}
