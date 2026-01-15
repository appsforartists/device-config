{
  lib,
  pkgs,
  ...
}: {
  my = {
    byPlatform = import ./byPlatform.nix {inherit lib;};
    makeSteamSafe = import ./makeSteamSafe.nix {inherit lib pkgs;};
  };
}
