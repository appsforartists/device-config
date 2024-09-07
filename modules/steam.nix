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
  };
}
