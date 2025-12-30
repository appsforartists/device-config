{
  pkgs,
  lib,
  config,
  ...
}: let
  makeSteamSafe = import ./makeSteamSafe.nix {inherit pkgs lib;};

  brotato = import ./brotato.nix {inherit pkgs lib;};
  balatro = import ./balatro/default.nix {inherit pkgs lib;};
in {
  home.packages = [
    (makeSteamSafe {pkg = brotato;})
    (makeSteamSafe {pkg = balatro;})
  ];
}
