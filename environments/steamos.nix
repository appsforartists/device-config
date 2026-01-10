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
    ../modules/games.nix
    ../modules/git.nix
    ../modules/shell.nix
    ../modules/sshd.nix
    ../modules/sublime
    ../modules/tools.nix
  ];
}
