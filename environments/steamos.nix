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
    ../modules/chrome.nix
    ../modules/games.nix
    ../modules/git.nix
    ../modules/sshd.nix
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
  };
}
