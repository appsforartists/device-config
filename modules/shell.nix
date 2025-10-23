{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    programs.bash = {
      enable = true;
    };
  };
}
