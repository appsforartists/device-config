{
  lib,
  pkgs,
  ...
}: {
  my = {
    byPlatform = import ./byPlatform.nix {inherit lib;};
  };
}
