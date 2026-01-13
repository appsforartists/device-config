{
  imports = [
    ../modules/fonts.nix
    ../modules/nix.nix
    ../modules/options.nix
    ../modules/terminal
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
  news.display = "silent";
}
