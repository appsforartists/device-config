# This is a thin sugar over the default `users.users`, but it allows a user to
# be set once, and used in all the places that expect a username, e.g.
# `jovian.steam.user`.
#
# This presumes we're on single-user machines.
#
# from https://github.com/vimjoyer/flake-starter-config

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.mainUser;
in
{
  options.mainUser = {
    userName = lib.mkOption {
      default = "mainuser";
      description = ''
        Linux account username
      '';
    };
    fullName = lib.mkOption {
      default = "Main user";
      description = ''
        The user's full name, as used in `passwd`
      '';
    };
  };

  config = {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = cfg.fullName;
      extraGroups = ["networkmanager" "wheel"];
    };
  };
}
