{
  imports = [
    ../modules/fonts.nix
    ../modules/nix.nix
    ../modules/npm.nix
    ../modules/options.nix
    ../modules/sublime
    ../modules/terminal
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
