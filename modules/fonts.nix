{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.my.byPlatform {
    # TODO: figure out how to get these fonts to register with the system
    darwin = {
      home.activation.installFonts = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -d "${config.home.path}/share/fonts" ]; then
          $DRY_RUN_CMD find -L "${config.home.path}/share/fonts" -type f \( -name '*.ttf' -o -name '*.otf' \) -exec ln -sf {} "$HOME/Library/Fonts/" \;
        fi
      '';
    };

    linux = {
      fonts.fontconfig.enable = true;
    };

    common = {
      home = {
        packages = with pkgs; [
          inconsolata
          noto-fonts-color-emoji
        ];
      };
    };
  };
}
