{
  config,
  lib,
  pkgs,
  secrets,
  ...
}: {
  config = lib.my.byPlatform {
    linux = {
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
    };

    common = {
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
        extra-substituters = https://install.determinate.systems
        extra-trusted-substituters = https://cache.flakehub.com https://install.determinate.systems
        trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
        extra-trusted-public-keys = cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio= cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU= cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU= cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8= cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ= cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o= cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y=
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
  };
}
