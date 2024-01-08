{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      google-chrome
    ];

    # restart for changes here to take effect
    environment.sessionVariables = {
      # force Wayland, which ensures Chrome renders at the correct resolution/
      # devicePixelRatio
      NIXOS_OZONE_WL = "1";
    };
  };
}
