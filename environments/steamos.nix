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
    ../modules/sshd.nix
  ];
}
