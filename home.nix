{
  config,
  lib,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deck";
  home.homeDirectory = "/home/deck";

  imports = [
    ./modules/nix.nix
    ./modules/sshd.nix
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/tools.nix
    ./modules/sublime
    ./modules/games.nix
  ];

  # Gemini says you have to manually set up the paths in single-user mode
  # (e.g. on SteamOS)
  systemd.user.sessionVariables = {
    PATH = "${config.home.homeDirectory}/.nix-profile/bin:''$PATH";
    XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:''$XDG_DATA_DIRS";
  };

  # Ensure the desktop-file-utils package is available if not already
  home.packages = [pkgs.desktop-file-utils];

  home.activation = {
    updateDesktopDatabase = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${pkgs.desktop-file-utils}/bin/update-desktop-database $VERBOSE_ARG ~/.local/share/applications
    '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deck/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
