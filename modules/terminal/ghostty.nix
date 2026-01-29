{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.my.byPlatform {
    darwin = {
      # Ghostty's derivation builds from source for Linux, but there's only a
      # binary version (which may not play nicely with e.g. the Dock) for Mac.
      # So install terminfo there to make SSH work, and otherwise just use Nix
      # for configuration.
      programs.ghostty.package = pkgs.ghostty-bin.terminfo;
      home.sessionVariables.TERMINFO_DIRS = "${pkgs.ghostty-bin.terminfo}/share/terminfo";
    };

    linux = {
      programs.ghostty.package = lib.my.makeSteamSafe pkgs.ghostty;
      home.sessionVariables.TERMINFO_DIRS = "${pkgs.ghostty.terminfo}/share/terminfo";
    };

    common = let
      toGhosttyKeybinding = keybinding: let
        replacements = {
          "," = ">";
          # ghostty doesn't let you chord "escape", but you can map sequences using ">"
          "escape+" = "escape>";
          # the +s ensure we don't collide with substrings.  left/right_
          # modifier keys are still technically susceptible, but we don't
          # specify those individuall in keybindings.
          "+up" = "+arrow_up";
          "+down" = "+arrow_down";
          "+left" = "+arrow_left";
          "+right" = "+arrow_right";
        };
      in
        lib.replaceStrings (builtins.attrNames replacements) (builtins.attrValues replacements) keybinding;

      toGhosttyKeybindings = keybinding:
        if builtins.isList keybinding
        then map toGhosttyKeybinding keybinding
        else toGhosttyKeybinding keybinding;

      ghosttyKeybindings = lib.mapAttrsRecursive (_: value: toGhosttyKeybindings value) lib.my.keybindings;
    in {
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

          keybind = lib.flatten [
            "${ghosttyKeybindings.preferences.open}=open_config"
            "${ghosttyKeybindings.preferences.reload}=reload_config"
            "${ghosttyKeybindings.app.quit}=quit"

            "${ghosttyKeybindings.file.newFile}=new_window"
            "${ghosttyKeybindings.windowNavigation.newTab}=new_tab"
            "${ghosttyKeybindings.terminal.newSplitRight}=new_split:right"
            "${ghosttyKeybindings.terminal.newSplitDown}=new_split:down"
            "${ghosttyKeybindings.windowNavigation.closeTab}=close_surface"
            "${ghosttyKeybindings.windowNavigation.closeAll}=close_tab:this"
            "${ghosttyKeybindings.windowNavigation.closeWindow}=close_window"
            "${ghosttyKeybindings.windowManagement.closeAllAppWindows}=close_all_windows"

            "${ghosttyKeybindings.edit.undo}=undo"
            "${ghosttyKeybindings.edit.redo}=redo"
            "${ghosttyKeybindings.edit.copy}=copy_to_clipboard"
            "${ghosttyKeybindings.edit.paste}=paste_from_clipboard"
            "${ghosttyKeybindings.edit.pasteSpecial}=paste_from_selection"
            "${ghosttyKeybindings.edit.selectAll}=select_all"
            "${ghosttyKeybindings.terminal.scrollToSelection}=scroll_to_selection"

            "${ghosttyKeybindings.view.resetZoom}=reset_font_size"
            "${ghosttyKeybindings.view.zoomIn}=increase_font_size:1"
            "${ghosttyKeybindings.view.zoomOut}=decrease_font_size:1"
            (map (keybinding: "${keybinding}=toggle_command_palette") ghosttyKeybindings.windowNavigation.openCommandPalette)
            "${ghosttyKeybindings.view.toggleInspector}=inspector:toggle"

            "${ghosttyKeybindings.view.clearScreen}=clear_screen"
            "${ghosttyKeybindings.view.toggleFullScreen}=toggle_fullscreen"
            "${ghosttyKeybindings.windowNavigation.previousTab}=previous_tab"
            "${ghosttyKeybindings.windowNavigation.nextTab}=next_tab"
            "${ghosttyKeybindings.windowNavigation.goToTab1}=goto_tab:1"
            "${ghosttyKeybindings.windowNavigation.goToTab2}=goto_tab:2"
            "${ghosttyKeybindings.windowNavigation.goToTab3}=goto_tab:3"
            "${ghosttyKeybindings.windowNavigation.goToTab4}=goto_tab:4"
            "${ghosttyKeybindings.windowNavigation.goToTab5}=goto_tab:5"
            "${ghosttyKeybindings.windowNavigation.goToTab6}=goto_tab:6"
            "${ghosttyKeybindings.windowNavigation.goToTab7}=goto_tab:7"
            "${ghosttyKeybindings.windowNavigation.goToTab8}=goto_tab:8"
            "${ghosttyKeybindings.windowNavigation.goToTab9}=last_tab"
            "${ghosttyKeybindings.terminal.toggleSplitZoom}=toggle_split_zoom"
            "${ghosttyKeybindings.terminal.gotoPreviousSplit}=goto_split:previous"
            "${ghosttyKeybindings.terminal.gotoNextSplit}=goto_split:next"
            "${ghosttyKeybindings.terminal.gotoSplitUp}=goto_split:up"
            "${ghosttyKeybindings.terminal.gotoSplitDown}=goto_split:down"
            "${ghosttyKeybindings.terminal.gotoSplitLeft}=goto_split:left"
            "${ghosttyKeybindings.terminal.gotoSplitRight}=goto_split:right"
            "${ghosttyKeybindings.terminal.equalizeSplits}=equalize_splits"
            "${ghosttyKeybindings.terminal.resizeSplitUp}=resize_split:up,10"
            "${ghosttyKeybindings.terminal.resizeSplitDown}=resize_split:down,10"
            "${ghosttyKeybindings.terminal.resizeSplitLeft}=resize_split:left,10"
            "${ghosttyKeybindings.terminal.resizeSplitRight}=resize_split:right,10"

            "${ghosttyKeybindings.terminal.scrollToTop}=scroll_to_top"
            "${ghosttyKeybindings.terminal.scrollToBottom}=scroll_to_bottom"
            "${ghosttyKeybindings.terminal.scrollPageUp}=scroll_page_up"
            "${ghosttyKeybindings.terminal.scrollPageDown}=scroll_page_down"
            "${ghosttyKeybindings.terminal.scrollLinesUp}=scroll_page_lines:-1"
            "${ghosttyKeybindings.terminal.scrollLinesDown}=scroll_page_lines:1"
            "${ghosttyKeybindings.terminal.adjustSelectionLeft}=adjust_selection:left"
            "${ghosttyKeybindings.terminal.adjustSelectionRight}=adjust_selection:right"
            "${ghosttyKeybindings.terminal.adjustSelectionUp}=adjust_selection:up"
            "${ghosttyKeybindings.terminal.adjustSelectionDown}=adjust_selection:down"
            "${ghosttyKeybindings.terminal.adjustSelectionPageUp}=adjust_selection:page_up"
            "${ghosttyKeybindings.terminal.adjustSelectionPageDown}=adjust_selection:page_down"
            "${ghosttyKeybindings.terminal.adjustSelectionHome}=adjust_selection:home"
            "${ghosttyKeybindings.terminal.adjustSelectionEnd}=adjust_selection:end"
            "${ghosttyKeybindings.terminal.jumpToPromptUp}=jump_to_prompt:-1"
            "${ghosttyKeybindings.terminal.jumpToPromptDown}=jump_to_prompt:1"
            "${ghosttyKeybindings.textNavigation.moveToLineEnd}=text:\\x05"
            "${ghosttyKeybindings.textNavigation.moveToLineStart}=text:\\x01"
            "${ghosttyKeybindings.terminal.shellDeleteLine}=text:\\x15"
            "${ghosttyKeybindings.terminal.shellWordBack}=esc:b"
            "${ghosttyKeybindings.terminal.shellWordForward}=esc:f"
            "${ghosttyKeybindings.terminal.writeScreenToFileCopy}=write_screen_file:copy"
            "${ghosttyKeybindings.terminal.writeScreenToFilePaste}=write_screen_file:paste"
          ];
        };
      };
    };
  };
}
