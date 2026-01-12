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

      initContent = putNixOnPATH;
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

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      # Gemini's port of https://github.com/sapegin/dotfiles/blob/dd063f9c30de7d2234e8accdb5272a5cc0a3388b/includes/bash_prompt.bash
      settings = {
        add_newline = true;
        command_timeout = 5000;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "\${custom.git_clean}"
          "\${custom.git_dirty}"
          "$git_state"
          "$line_break"
          "$character"
        ];

        directory = {
          style = "white";
          format = "[$path]($style)";
        };

        character = {
          success_symbol = "[❯](cyan)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };

        git_state = {
          format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
          style = "bright-black";
        };

        git_branch.disabled = true;
        git_status.disabled = true;

        custom = {
          git_clean = {
            when = "git rev-parse --is-inside-work-tree 2>/dev/null && git diff --quiet --exit-code --ignore-submodules 2>/dev/null && test -z \"$(git status --porcelain 2>/dev/null)\"";
            command = "git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null";
            format = "[ ☀  $output](green)";
          };

          git_dirty = {
            when = "git rev-parse --is-inside-work-tree 2>/dev/null && (! git diff --quiet --exit-code --ignore-submodules 2>/dev/null || test -n \"$(git status --porcelain 2>/dev/null)\")";
            command = "git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null";
            format = "[ ☂  $output](red)";
          };
        };

        cmd_duration = {
          format = "[in $duration]($style)";
          style = "yellow";
        };
      };
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "hms" ''
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

  # On Mac: just use nix for configuration, not for installing apps
  imports = [
    (lib.mkIf pkgs.stdenv.isDarwin {
      programs = {
        # Ghostty's derivation builds from source for Linux, but there's only
        # a binary version (which may not play nicely with e.g. the Dock) for
        # Mac.
        ghostty.package = null;

        # You have to manually `sudo chsh -s /bin/zsh $USER` to change shells on
        # Mac.  The Nix-managed version of zsh isn't in `/etc/shells`, and it's
        # probably not worth it to force it.
        zsh.package = pkgs.emptyDirectory; # doesn't support `null`
      };
    })
  ];
}
