{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  isDarwin = lib.strings.hasInfix "darwin" builtins.currentSystem;
  isLinux = lib.strings.hasInfix "linux" builtins.currentSystem;
in {
  config = lib.mkMerge [
    (lib.mkIf isDarwin {
      home.sessionPath = [
        "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
      ];
    })

    (lib.mkIf isLinux {
      nixpkgs.config = {
        allowUnfree = true;

        # required by Sublime for packages that use an old version of Python
        # https://github.com/sublimehq/sublime_text/issues/5984
        #
        # packages can be individually audited and upgraded to use Python 3.8 to
        # avoid using an obsolete version of openssl.
        permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
      };

      home = {
        packages = with pkgs; [
          inconsolata
          sublime4
        ];

        file = {
          ".config/sublime-text/Packages/User/Default.sublime-keymap" = {
            source = ./keybindings.json;
          };

          ".config/sublime-text/Packages/User/Preferences.sublime-settings" = {
            source = ./settings.json;
          };
        };
      };
    })

    {
      home.sessionVariables = {
        EDITOR = "subl -w";
      };
    }
  ];
}
