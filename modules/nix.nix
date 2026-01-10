{
  config,
  lib,
  pkgs,
  secrets,
  ...
}: {
  config = {
    # The Determinate Nix installer wants you to unlock SteamOS's immutable
    # filesystem.  I don't want to do that, so on immutable systems, I'm using
    # Nix single-user mode  managed by home-manager.
    #
    # Determinate Nix sets a bunch of modern defaults like opting-into flakes.
    # To ensure cross-environment consistency, I'm setting the same values on
    # all devices (even though most of them are already set by Determinate on
    # mutable environments).
    #
    # On Determinate Nix systems, that requires this
    #
    #     trusted-users = root @admin
    #
    # to be added to `/private/etc/nix/nix.custom.conf`
    #
    # Home Manager manages what's in your home folder.  On single-user
    # installs, that includes nix and its settings; however, it doesn't let you
    # specify `nix.settings` on multi-user installs.  As a workaround, generate
    # the config file like it's any other app.
    xdg.configFile."nix/nix.conf".text = ''
      experimental-features = nix-command flakes
      max-jobs = auto
      auto-optimise-store = true
      always-allow-substitutes = true
      builders-use-substitutes = true
      bash-prompt-prefix = (nix:%n)
      extra-nix-path = nixpkgs=flake:nixpkgs
      substituters = https://cache.nixos.org
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    '';
    # Home Manager owns ~ and the binaries inside of it.  On a single-user
    # install, that includes `nix` itself.  On a Determinate install, nix is on
    # the global path, outside the purview of Home Manager.
    #
    # `nix.package` is a special home for nix, in lieu of `home.packages`
    nix.package = lib.mkIf (!config.my.system.hasDeterminate) pkgs.nix;

    home = {
      packages = with pkgs; [
        alejandra
      ];
    };
  };

  # `imports = [ mkIf {` lets you scope a bunch of settings to the same conditional
  imports = [
    (lib.mkIf pkgs.stdenv.isLinux {
      systemd.user.sessionVariables = {
        PATH = "${config.home.homeDirectory}/.nix-profile/bin:''$PATH";
        XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:''$XDG_DATA_DIRS";
      };

      # Ensures new desktop items appear after `hms` is run
      home.packages = with pkgs; [desktop-file-utils];
      home.activation = {
        updateDesktopDatabase = lib.hm.dag.entryAfter ["writeBoundary"] ''
          $DRY_RUN_CMD ${pkgs.desktop-file-utils}/bin/update-desktop-database $VERBOSE_ARG ~/.local/share/applications
        '';
      };
    })
  ];
}
