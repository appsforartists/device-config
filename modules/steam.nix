{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.steamCompat
    inputs.jovian.nixosModules.default
  ];

  config = {
    nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };

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
