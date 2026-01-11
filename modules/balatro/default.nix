{
  pkgs,
  lib,
  ...
}: let
  balatro-overridden = pkgs.balatro.override {
    withMods = false;
    withLinuxPatch = false;
  };
in
  balatro-overridden.overrideAttrs (oldAttrs: {
    pname = oldAttrs.pname + "-patched";
    src = /nix/store/xqsnrv314v0vx1dq2v5f8m0sqlv95rz1-Balatro.zip;

    nativeBuildInputs = [
      pkgs.love
      pkgs.makeWrapper
      pkgs.p7zip
      pkgs.copyDesktopItems
      pkgs.libicns
      pkgs.graphicsmagick
    ];

    srcIcon = pkgs.fetchurl {
      name = "balatro.icns";
      url = "https://shared.fastly.steamstatic.com/community_assets/images/apps/2379780/26b1742312f73169f21a3827245a9119d32c1a72.icns";
      hash = "sha256-MrO1faPMLXNFDJWecCoC9/AdEI2ryq/U1Vsmb5Z+1io=";
    };

    installPhase = ''
      runHook preInstall

      tmpdir=$(mktemp -d)
      7z x $src -o$tmpdir -y

      if [ -d "$tmpdir/assets" ]; then
        mv "$tmpdir/assets/"* "$tmpdir/"
        rmdir "$tmpdir/assets"
      elif [ -d "$tmpdir/Assets" ]; then
        mv "$tmpdir/Assets/"* "$tmpdir/"
        rmdir "$tmpdir/Assets"
      fi

      cp ${./bridge_detour.lua} $tmpdir/bridge_detour.lua

      for file in main.lua engine/load_manager.lua engine/save_manager.lua; do
        if [ -f "$tmpdir/$file" ]; then
          sed -i '1i require("bridge_detour")' "$tmpdir/$file"
        else
          echo "Warning: $file not found in extracted source."
        fi
      done

      loveFile=game.love
      cd $tmpdir
      7z a -tzip ../$loveFile ./*
      cd ..

      cp $srcIcon balatro.icns
      icns2png -x balatro.icns
      mkdir -p $out/share/icons/hicolor/32x32/apps
      install -Dm644 balatro_32x32x32.png $out/share/icons/hicolor/32x32/apps/balatro.png

      # the original icon is pixel art, so integer scale it to avoid interpolation
      gm convert balatro_32x32x32.png -scale 512x512 balatro_512x512x32.png
      mkdir -p $out/share/icons/hicolor/512x512/apps
      install -Dm644 balatro_512x512x32.png $out/share/icons/hicolor/512x512/apps/balatro.png

      cat ${lib.getExe pkgs.love} $loveFile > $out/share/Balatro
      chmod +x $out/share/Balatro

      makeWrapper $out/share/Balatro $out/bin/balatro

      runHook postInstall
    '';

    meta = pkgs.balatro.meta;
    desktopItems = pkgs.balatro.desktopItems;
  })
