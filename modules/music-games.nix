{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      clonehero
      onyx
    ];
  };
}
