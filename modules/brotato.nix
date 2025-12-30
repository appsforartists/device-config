{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "brotato";
  src = /nix/store/grynblqk7023xsv6sgfr7hc8vy76fqjh-Brotato.pck;

  unpackPhase = ":";

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.godot3
    pkgs.copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    makeWrapper ${lib.getExe' pkgs.godot3 "godot3"} $out/bin/brotato \
      --add-flags "--main-pack $src"

    runHook postInstall
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "brotato";
      desktopName = "Brotato";
      exec = "brotato";
      icon = "brotato";
      comment = finalAttrs.meta.description;
      categories = ["Game" "ActionGame" "Shooter"];
      terminal = false;
    })
  ];

  meta = with lib; {
    description = "Brotato is a top-down arena shooter roguelite where you play a potato wielding up to 6 weapons at a time to fight off hordes of aliens. Choose from a variety of traits and items to create unique builds and survive until help arrives.";
    homepage = "https://www.blobfish.com/brotato";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "brotato";
  };
})
