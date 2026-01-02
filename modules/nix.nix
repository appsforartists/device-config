{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    nix.settings = {
      # The Determinate Nix installer wants you to unlock SteamOS's immutable
      # filesystem.  I don't want to do that, so I'm using Nix single-user mode,
      # managed by home-manager.  These are the Nix defaults you'd get from DN,
      # adjusted to work on a single-user install.
      "experimental-features" = "nix-command flakes";
      "max-jobs" = "auto";
      "auto-optimise-store" = true;
      "always-allow-substitutes" = true;
      "builders-use-substitutes" = true;
      "bash-prompt-prefix" = ''(nix:%n) '';
      "extra-nix-path" = "nixpkgs=flake:nixpkgs";
      "substituters" = "https://cache.nixos.org";
      "trusted-public-keys" = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    };
    nix.package = pkgs.nix;
  };
}
