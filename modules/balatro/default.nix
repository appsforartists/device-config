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
    ];

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

      mkdir -p $out/bin $out/share/balatro $out/share/icons/hicolor/256x256/apps

      if [ -f "$tmpdir/resources/textures/2x/balatro.png" ]; then
        install -Dm644 $tmpdir/resources/textures/2x/balatro.png $out/share/icons/hicolor/256x256/apps/balatro.png
      fi

      cat ${lib.getExe pkgs.love} $loveFile > $out/share/Balatro
      chmod +x $out/share/Balatro

      makeWrapper $out/share/Balatro $out/bin/balatro

      runHook postInstall
    '';

    meta = pkgs.balatro.meta;
    desktopItems = pkgs.balatro.desktopItems;
  })
