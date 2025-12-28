{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    home = {
      packages = with pkgs; [
        (pkgs.bundlerApp {
          pname = "rmate";
          gemdir = ./gem;
          exes = ["rmate"];
        })
      ];
    };
  };
}
