{
  config,
  lib,
  pkgs,
  ...
}: let
  makeSteamSafe = import ./makeSteamSafe.nix {inherit pkgs lib;};

  balatro = import ./balatro/default.nix {inherit pkgs lib;};
in {
  home.packages = [
    (makeSteamSafe {pkg = pkgs.brotato;})
    (makeSteamSafe {pkg = balatro;})
  ];
}
