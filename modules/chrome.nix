{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  toXremapKeybinding = keybinding: let
    replacements = {
      "option" = "alt";
      "+" = "-";
      "." = "dot";
      "," = "comma";
      "/" = "slash";
      ";" = "semicolon";
      "'" = "apostrophe";
      "`" = "grave";
      "[" = "leftbrace";
      "]" = "rightbrace";
      "\\" = "backslash";
      "=" = "equal";
      "-" = "minus";
    };
  in
    lib.replaceStrings (builtins.attrNames replacements) (builtins.attrValues replacements) keybinding;

  toXremapKeybindings = keybinding:
    if builtins.isList keybinding
    then map toXremapKeybinding keybinding
    else toXremapKeybinding keybinding;

  xremapBindings = lib.mapAttrsRecursive (_: value: toXremapKeybindings value) lib.my.keybindings;
in {
  imports = [
    inputs.xremap.homeManagerModules.default
  ];

  services.xremap = {
    enable = true;
    withX11 = true;
    config = {
      keymap = [
        {
          name = "Chrome";
          application = {
            only = "Google-chrome";
          };
          remap = {
            "${xremapBindings.windowNavigation.newTab}" = "ctrl-t";
            "${xremapBindings.fileManager.newWindow}" = "ctrl-n";
            "${xremapBindings.windowNavigation.newWindow}" = "ctrl-shift-n";
            "${xremapBindings.windowNavigation.closeTab}" = "ctrl-w";
            "${xremapBindings.windowNavigation.closeWindow}" = "ctrl-shift-w";
            "${xremapBindings.file.reopenLastFile}" = "ctrl-shift-t";
            "${xremapBindings.windowNavigation.previousTab}" = "ctrl-shift-tab";
            "${xremapBindings.windowNavigation.nextTab}" = "ctrl-tab";
            "${xremapBindings.windowNavigation.goToTab1}" = "alt-1";
            "${xremapBindings.windowNavigation.goToTab2}" = "alt-2";
            "${xremapBindings.windowNavigation.goToTab3}" = "alt-3";
            "${xremapBindings.windowNavigation.goToTab4}" = "alt-4";
            "${xremapBindings.windowNavigation.goToTab5}" = "alt-5";
            "${xremapBindings.windowNavigation.goToTab6}" = "alt-6";
            "${xremapBindings.windowNavigation.goToTab7}" = "alt-7";
            "${xremapBindings.windowNavigation.goToTab8}" = "alt-8";
            "${xremapBindings.windowNavigation.goToTab9}" = "alt-9";
            "super-alt-n" = "alt-shift-n"; # New Split Tab

            "super-ctrl-c" = "alt-shift-c"; # Add Tab to Group
            "super-ctrl-p" = "alt-shift-p"; # Create New Group
            "super-ctrl-w" = "alt-shift-w"; # Close Tab Group
            "super-ctrl-x" = "alt-shift-x"; # Focus Next Group
            "super-ctrl-z" = "alt-shift-z"; # Focus Previous Group

            "super-left" = "alt-left"; # Back (alternate)
            "${xremapBindings.fileManager.goBack}" = "alt-left";
            "super-right" = "alt-right"; # Forward (alternate)
            "${xremapBindings.fileManager.goForward}" = "alt-right";
            "${xremapBindings.windowNavigation.reload}" = "ctrl-r";
            "${xremapBindings.browser.hardReload}" = "ctrl-shift-r";
            "${xremapBindings.windowNavigation.home}" = "alt-home";
            "${xremapBindings.browser.history}" = "ctrl-h";
            "${xremapBindings.fileManager.openDownloads}" = "ctrl-j";
            "${xremapBindings.browser.clearData}" = "ctrl-shift-delete";
            "${xremapBindings.windowNavigation.focusLocation}" = "ctrl-l";

            "${xremapBindings.find.find}" = "ctrl-f";
            "${xremapBindings.find.findNext}" = "ctrl-g";
            "${xremapBindings.find.findPrevious}" = "ctrl-shift-g";
            "${xremapBindings.file.print}" = "ctrl-p";
            "${xremapBindings.bookmarks.add}" = "ctrl-d";
            "${xremapBindings.bookmarks.addAllTabs}" = "ctrl-shift-d";
            "${xremapBindings.bookmarks.manager}" = "ctrl-shift-o";
            "${xremapBindings.browser.developerTools}" = "ctrl-shift-i";
            "${xremapBindings.browser.inspectElement}" = "ctrl-shift-c";
            "${xremapBindings.browser.inspectElementAlt}" = "ctrl-shift-c";
            "${xremapBindings.browser.devConsole}" = "ctrl-shift-j";
            "${xremapBindings.browser.viewSource}" = "ctrl-u";
            "${xremapBindings.windowNavigation.focusNextPane}" = "F6";
            "${xremapBindings.windowNavigation.focusPreviousPane}" = "Shift-F6";
            "${xremapBindings.windowNavigation.openMenu}" = "ctrl-shift-m";
            "${xremapBindings.windowNavigation.findTab}" = "ctrl-shift-a";
            "${xremapBindings.view.toggleFullScreen}" = "F11";
            "super-alt-p" = "ctrl-shift-p"; # Print using System Dialog

            "${xremapBindings.view.zoomIn}" = "ctrl-equal";
            "${xremapBindings.view.zoomOut}" = "ctrl-minus";
            "${xremapBindings.view.resetZoom}" = "ctrl-0";

            "${xremapBindings.file.open}" = "ctrl-o";
            "${xremapBindings.file.save}" = "ctrl-s";
            "${xremapBindings.edit.undo}" = "ctrl-z";
            "${xremapBindings.edit.redo}" = "ctrl-shift-z";
            "${xremapBindings.edit.cut}" = "ctrl-x";
            "${xremapBindings.edit.copy}" = "ctrl-c";
            "${xremapBindings.edit.paste}" = "ctrl-v";
            "super-alt-v" = "ctrl-shift-v"; # Paste as Plain Text
            "${xremapBindings.edit.selectAll}" = "ctrl-a";
            "${xremapBindings.bookmarks.toggleBar}" = "ctrl-shift-b";
            "${xremapBindings.windowNavigation.cancel}" = "Esc";
            "${xremapBindings.app.showHelp}" = "F1";

            "super-alt-shift-a" = "alt-shift-a"; # Focus Inactive Popup
          };
        }
      ];
    };
  };

  programs.google-chrome = {
    enable = true;
    package = lib.my.makeSteamSafe pkgs.google-chrome;
    plasmaSupport = true;
    commandLineArgs = [
      "--enable-features=DefaultANGLEVulkan,TreesInViz,Vulkan,VulkanFromANGLE"
      "--top-chrome-touch-ui=enabled"
    ];
  };
}
