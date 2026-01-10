{
  imports = [
    ../modules/options.nix
    ../modules/nix.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
  news.display = "silent";
}
