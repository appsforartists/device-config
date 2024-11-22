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

    services.displayManager.autoLogin = {
      enable = true;
      user = config.mainUser.userName;
    };

    # remove all the GNOME default apps, and explicitly pick the ones that might be useful
    services.gnome.core-utilities.enable = false;
    environment.systemPackages = with pkgs; [
      baobab # disk space analyzer
      gnome-console # terminal
      gnome-font-viewer
      gnome-system-monitor
      gnomeExtensions.force-phone-mode
      nautilus # file manager
    ];
  };
}
