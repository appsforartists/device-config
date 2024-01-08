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

    # remove all the GNOME default apps, and explicitly pick the ones that might be useful
    services.gnome.core-utilities.enable = false;
    environment.systemPackages = with pkgs; with pkgs.gnome; [
      baobab # disk space analyzer
      gnome-console # terminal
      gnome-font-viewer
      gnome-system-monitor
      nautilus # file manager
    ];
  };
}
