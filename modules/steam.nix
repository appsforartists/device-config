{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.jovian.nixosModules.default
  ];

  config = {
    jovian.steam = {
      user = config.mainUser.userName;
      enable = true;
      autoStart = true;
    };

    jovian.decky-loader = {
      user = config.mainUser.userName;
      enable = true;
    };

    programs.steam = {
      enable = true;
      extest.enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    # if this gets more complex we can put it in its own module; but for now,
    # it's easier to just reuse the one that has all the other gaming stuff.
    environment.systemPackages = with pkgs; [
      clonehero
    ];
  };
}
