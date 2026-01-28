{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  my.system = {
    environment = "steamos";
    hasDeterminate = false;
  };

  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./common.nix
    ../modules/chrome.nix
    ../modules/games.nix
    ../modules/git.nix
    ../modules/plasma
    ../modules/sshd.nix
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
  };
}
