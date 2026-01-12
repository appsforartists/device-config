{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = {
    programs.ghostty = {
      enable = true;

      # nixpkgs doesn't have the Mac version building from source yet, and there
      # may be issues with putting ghostty-bin e.g. in the Dock.  For now, just
      # using Nix to share settings across devices.
      package = lib.mkIf (pkgs.stdenv.isDarwin) null;

      settings = {
        font-family = "Ligconsolata";
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

    programs.zsh = let
      putNixOnPATH = ''
        if [ -f "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-daemon.sh" ]; then
         . "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-daemon.sh"
        fi
      '';

    in {
      enable = true;

      # Gemini says you have to manually set up the PATHs when using single-user
      # mode (e.g. on SteamOS).
      initExtra = lib.mkIf (!config.my.system.hasDeterminate) putNixOnPATH;
      profileExtra = lib.mkIf (!config.my.system.hasDeterminate) putNixOnPATH;

      shellAliases = {
        g = "git";
        gcp = "git cherry-pick";
        grod = "git rebase origin/develop";
        gri = "git rebase -i";
        griod = "git rebase -i origin/develop";
        gmff = "git merge --ff-only";
        grc = "git rebase --continue";
        grs = "git rebase --skip";
        gcl = "git clone";
        gco = "git checkout";
        glo = "git log --oneline --abbrev-commit --graph --decorate --color";
        gsb = "git branch --verbose";
        gst = "git status";
        pscb = "git push";
        yrs = "yarn run start";
        yrbw = "yarn run build --watch";
        yrt = "yarn run test";
        sbdc = "subl ~/Projects/device-config";
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "hms" ''
        #!/usr/bin/env bash
        set -euo pipefail
        exec ${inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager}/bin/home-manager switch \
          --flake "$HOME/Projects/device-config#${config.my.system.environment}" \
          --override-input nixpkgs "git+file://$HOME/Projects/nixpkgs" \
          --impure \
          "$@"
      '')
    ];
  };
}
