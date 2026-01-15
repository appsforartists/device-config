{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  makeSteamSafe = import ../makeSteamSafe.nix {inherit lib pkgs;};
in {
  config = lib.my.byPlatform {
    darwin = {
      # On Mac, just use Nix for configuration.
      # Ghostty's derivation builds from source for Linux, but there's only a
      # binary version (which may not play nicely with e.g. the Dock) for Mac.
      programs.ghostty.package = null;
    };

    linux = {
      programs.ghostty.package = makeSteamSafe {pkg = pkgs.ghostty;};
    };

    common = {
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

          keybind = [
            # Ghostty
            "super+comma=open_config"
            "super+shift+comma=reload_config"
            "super+q=quit"

            # File
            "super+n=new_window"
            "super+t=new_tab"
            "super+d=new_split:right"
            "super+shift+d=new_split:down"
            "super+w=close_surface"
            "super+option+w=close_tab:this"
            "super+shift+w=close_window"
            "super+option+shift+w=close_all_windows"

            # Edit
            "super+z=undo"
            "super+shift+z=redo"
            "super+c=copy_to_clipboard"
            "super+v=paste_from_clipboard"
            "super+shift+v=paste_from_selection"
            "super+a=select_all"
            "super+j=scroll_to_selection"

            # View
            "super+0=reset_font_size"
            "super+equal=increase_font_size:1"
            "super+shift+equal=increase_font_size:1"
            "super+minus=decrease_font_size:1"
            "super+shift+p=toggle_command_palette"
            "super+option+i=inspector:toggle"

            # Window
            "super+k=clear_screen"
            "super+ctrl+f=toggle_fullscreen"
            "super+shift+bracket_left=previous_tab"
            "super+shift+bracket_right=next_tab"
            "super+1=goto_tab:1"
            "super+2=goto_tab:2"
            "super+3=goto_tab:3"
            "super+4=goto_tab:4"
            "super+5=goto_tab:5"
            "super+6=goto_tab:6"
            "super+7=goto_tab:7"
            "super+8=goto_tab:8"
            "super+9=last_tab"
            "super+shift+enter=toggle_split_zoom"
            "super+bracket_left=goto_split:previous"
            "super+bracket_right=goto_split:next"
            "super+option+arrow_up=goto_split:up"
            "super+option+arrow_down=goto_split:down"
            "super+option+arrow_left=goto_split:left"
            "super+option+arrow_right=goto_split:right"
            "super+ctrl+equal=equalize_splits"
            "super+ctrl+arrow_up=resize_split:up,10"
            "super+ctrl+arrow_down=resize_split:down,10"
            "super+ctrl+arrow_left=resize_split:left,10"
            "super+ctrl+arrow_right=resize_split:right,10"

            # Navigation
            "super+home=scroll_to_top"
            "super+end=scroll_to_bottom"
            "super+page_up=scroll_page_up"
            "super+page_down=scroll_page_down"
            "ctrl+option+up=scroll_page_lines:-1"
            "ctrl+option+down=scroll_page_lines:1"
            "shift+arrow_left=adjust_selection:left"
            "shift+arrow_right=adjust_selection:right"
            "shift+arrow_up=adjust_selection:up"
            "shift+arrow_down=adjust_selection:down"
            "shift+page_up=adjust_selection:page_up"
            "shift+page_down=adjust_selection:page_down"
            "shift+home=adjust_selection:home"
            "shift+end=adjust_selection:end"
            "super+arrow_up=jump_to_prompt:-1"
            "super+shift+arrow_up=jump_to_prompt:-1"
            "super+arrow_down=jump_to_prompt:1"
            "super+shift+arrow_down=jump_to_prompt:1"
            "super+arrow_right=text:\\x05"
            "super+arrow_left=text:\\x01"
            "super+backspace=text:\\x15"
            "option+arrow_left=esc:b"
            "option+arrow_right=esc:f"
            "super+shift+ctrl+j=write_screen_file:copy"
            "super+shift+j=write_screen_file:paste"
          ];
        };
      };
    };
  };
}
