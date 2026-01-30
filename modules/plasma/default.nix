{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./keybindings.nix
    ./panel.nix
  ];
}
