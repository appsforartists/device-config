# To use this as a "non-Steam game," set the Launch Options to:
#
# env -u LD_PRELOAD -u LD_LIBRARY_PATH %command%
{
  pkgs,
  lib,
  ...
}: let
  nixgl = import (builtins.fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") {inherit pkgs;};

  brotato = pkgs.stdenv.mkDerivation {
    name = "brotato";
    src = /nix/store/grynblqk7023xsv6sgfr7hc8vy76fqjh-Brotato.pck;

    unpackPhase = ":";

    nativeBuildInputs = [
      pkgs.makeWrapper
      nixgl.auto.nixGLDefault
      pkgs.godot3
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin

      makeWrapper ${lib.getExe nixgl.auto.nixGLDefault} $out/bin/brotato \
        --add-flags "${lib.getExe pkgs.godot3} --main-pack $src"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Brotato is a top-down arena shooter roguelite where you play a potato wielding up to 6 weapons at a time to fight off hordes of aliens. Choose from a variety of traits and items to create unique builds and survive until help arrives.";
      homepage = "https://www.blobfish.com/brotato";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
in {
  home.packages = [
    brotato
  ];

  xdg.desktopEntries = {
    brotato = {
      name = "Brotato";
      exec = "brotato";
      icon = "brotato";
      comment = brotato.meta.description;
      categories = ["Game" "ActionGame" "Shooter"];
      terminal = false;
    };
  };
}
