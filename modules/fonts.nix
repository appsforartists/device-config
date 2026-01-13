{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    {
      fonts.fontconfig.enable = true;
      home = {
        packages = with pkgs; [
          inconsolata
          noto-fonts-color-emoji
        ];
      };
    }

    (lib.mkIf pkgs.stdenv.isDarwin {
      home.activation.installFonts = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -d "${config.home.path}/share/fonts" ]; then
          $DRY_RUN_CMD find -L "${config.home.path}/share/fonts" -type f \( -name '*.ttf' -o -name '*.otf' \) -exec ln -sf {} "$HOME/Library/Fonts/" \;
        fi
      '';
    })
  ];
}
