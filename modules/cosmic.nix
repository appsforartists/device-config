{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  config = {
    # TODO: find a way to check if config.jovian exists first
    jovian.steam.desktopSession = "cosmic";
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = lib.mkForce (!config.jovian.steam.autoStart);

    services.displayManager.autoLogin = {
      enable = true;
      user = config.mainUser.userName;
    };
  };
}
