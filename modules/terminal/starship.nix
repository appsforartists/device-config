{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = {
    # Adds git metadata to the prompt
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
  };
}
