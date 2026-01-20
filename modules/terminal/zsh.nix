{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.my.byPlatform {
    darwin = {
      # On Mac, just use Nix for configuration.
      # You have to manually `sudo chsh -s /bin/zsh $USER` to change shells. The
      # Nix-managed version of zsh isn't in `/etc/shells`, and it's probably
      # not worth it to force it.
      programs.zsh.package = pkgs.emptyDirectory; # doesn't support `null`
    };

    common = {
      programs.zsh = let
        localNixDaemon = "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-daemon.sh";
        globalNixDaemon = "/etc/profile.d/nix.sh";
        putNixOnPATH = ''
          if [ -f "${localNixDaemon}" ]; then
           . "${localNixDaemon}"
          elif [ -f "${globalNixDaemon}" ]; then
           . "${globalNixDaemon}"
          fi
        '';
      in {
        enable = true;

        initContent =
          ''
            if [ -f ~/.zshrc.local ]; then
              source ~/.zshrc.local
            fi
          ''
          + putNixOnPATH;
        profileExtra = putNixOnPATH;

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

      home.packages = with pkgs; [
        (writeShellScriptBin "hms" ''
          #!/usr/bin/env bash
          set -euo pipefail

          ARGS=()
          NIXPKGS_OVERRIDE=""

          for arg in "$@"; do
            if [ "$arg" == "--local" ]; then
              NIXPKGS_OVERRIDE="--override-input nixpkgs git+file://$HOME/Projects/nixpkgs"
            else
              ARGS+=("$arg")
            fi
          done

          exec ${inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager}/bin/home-manager switch \
            --flake "$HOME/Projects/device-config#${config.my.system.environment}" \
            $NIXPKGS_OVERRIDE \
            --impure \
            "''${ARGS[@]}"
        '')
      ];
    };
  };
}
