{
  config,
  lib,
  pkgs,
  ...
}: {
  my.system = {
    environment = "steamos";
    hasDeterminate = false;
  };

  imports = [
    ./common.nix
    ../modules/fonts.nix
    ../modules/games.nix
    ../modules/git.nix
    ../modules/sshd.nix
    ../modules/sublime
    ../modules/terminal.nix
    ../modules/tools.nix
  ];
}
