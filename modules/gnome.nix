{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.gnome-mobile-experimental.nixosModules.gnome-mobile
  ];

  config = {
    # TODO: find a way to check if config.jovian exists first
    jovian.steam.desktopSession = "gnome";
    services.xserver.displayManager.gdm.enable = lib.mkForce (!config.jovian.steam.autoStart);

    services.xserver.displayManager.autoLogin = {
      enable = true;
      user = config.mainUser.userName;
    };

    # reenable stuff that the gnome-mobile flake hides
    environment.systemPackages = with pkgs.gnome; [
      baobab # disk space analyzer
    ];

    environment.gnome.excludePackages = with pkgs; with pkgs.gnome; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gnome-characters # emoji picker
      gnome-connections # vnc/remote desktop
      gnome-music
      gnome-photos
      gnome-terminal
      hitori # sudoku game
      iagno # go game
      simple-scan # document scanner
      tali # poker game
      totem # video player
      yelp # help
    ];
  };
}
