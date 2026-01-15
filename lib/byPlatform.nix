{lib, ...}: let
  isDarwin = lib.strings.hasInfix "darwin" builtins.currentSystem;
  isLinux = lib.strings.hasInfix "linux" builtins.currentSystem;
in
  {
    darwin ? {},
    linux ? {},
    common ? {},
  }:
    lib.mkMerge [
      (lib.mkIf isDarwin darwin)
      (lib.mkIf isLinux linux)
      common
    ]
