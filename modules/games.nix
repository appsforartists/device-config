{
  config,
  lib,
  pkgs,
  ...
}: let
  balatro = import ./balatro/default.nix {inherit pkgs lib;};
in {
  home.packages = [
    (lib.my.makeSteamSafe {pkg = pkgs.brotato;})
    (lib.my.makeSteamSafe {pkg = balatro;})
  ];
}
