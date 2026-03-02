{
  config,
  lib,
  ...
}: {
  options.my.system = {
    environment = lib.mkOption {
      type = lib.types.str;
      description = "Which of environments/ to generate?";
    };

    hasDeterminate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is Nix from the multi-user Determinate Nix installer?";
    };

    terminalBackgroundColor = lib.mkOption {
      type = lib.types.str;
      default = builtins.head config.programs.ghostty.settings.background;
      description = ''
        Override the terminal background color for this host, to help keep track
        of which environment you're in when SSHed into multiple devices.

        Accepts hex colors, X11 named colors, and `rgb:255/255/255`.
      '';
    };

    terminalForegroundColor = lib.mkOption {
      type = lib.types.str;
      default = builtins.head config.programs.ghostty.settings.foreground;
      description = ''
        Override the terminal foreground color for this host, to help keep track
        of which environment you're in when SSHed into multiple devices.

        Accepts hex colors, X11 named colors, and `rgb:255/255/255`.
      '';
    };
  };
}
