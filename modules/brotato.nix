{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "brotato";
  src = /nix/store/grynblqk7023xsv6sgfr7hc8vy76fqjh-Brotato.pck;
  srcIcon = pkgs.fetchurl {
    name = "brotato.icns";
    url = "https://shared.fastly.steamstatic.com/community_assets/images/apps/1942280/c096e6b30bcb9749183fe5d1b78f77de7ae89383.icns";
    hash = "sha256-6ZZ1kqdOjqwIByrX1Bqrhy2yMaShlsbsEhuDBTK77gw=";
  };

  unpackPhase = ":";

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.godot3
    pkgs.libicns
    pkgs.copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    makeWrapper ${lib.getExe' pkgs.godot3 "godot3"} $out/bin/brotato \
      --add-flags "--main-pack $src"

    cp $srcIcon brotato.icns
    icns2png -x brotato.icns
    mkdir -p $out/share/icons/hicolor/512x512/apps
    install -Dm644 brotato_512x512x32.png $out/share/icons/hicolor/512x512/apps/brotato.png

    runHook postInstall
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "brotato";
      desktopName = "Brotato";
      exec = "${placeholder "out"}/bin/brotato";
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
