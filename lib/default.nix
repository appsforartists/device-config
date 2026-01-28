{
  lib,
  pkgs,
  ...
}: {
  my = {
    byPlatform = import ./byPlatform.nix {inherit lib;};
    keybindings = import ./keybindings.nix;
    makeSteamSafe = import ./makeSteamSafe.nix {inherit lib pkgs;};
  };
}
