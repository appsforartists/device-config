{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  makeSteamSafe = import ../makeSteamSafe.nix {inherit lib pkgs;};
in {
  config = {
    programs.ghostty = {
      enable = true;

      package =
        if pkgs.stdenv.isLinux
        then makeSteamSafe {pkg = pkgs.ghostty;}
        else
          # On Mac, just use Nix for configuration.
          # Ghostty's derivation builds from source for Linux, but there's only
          # a binary version (which may not play nicely with e.g. the Dock) for
          # Mac.
          lib.mkIf pkgs.stdenv.isDarwin null;

      settings = {
        font-family = [
          "Ligconsolata"
          "Noto Color Emoji"
        ];
        font-feature = "dlig";
        font-size = 18;

        adjust-cell-height = "20%";
        window-padding-x = 8;
        window-padding-y = 8;
        window-padding-balance = true;

        foreground = "#28FE14";
        bold-color = "#00FF00";
        background = "#000123";
        background-blur = 50;
        background-opacity = 0.90;

        # keep the Mac defaults for text nav and special characters on left option
        macos-option-as-alt = "right";
      };
    };
  };
}
