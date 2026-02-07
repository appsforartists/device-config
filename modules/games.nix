{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    (lib.my.makeSteamSafe pkgs.brotato)
    (lib.my.makeSteamSafe (
      pkgs.balatro.override {
        src = /nix/store/g44bp7ymc7qlkfv5f03b55cgs1wdmkzl-com.playstack.balatro.android.apk;
      }
    ))
  ];
}
