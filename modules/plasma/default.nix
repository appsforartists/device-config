{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./keybindings.nix
    ./panel.nix
  ];

  programs.plasma.workspace = {
    wallpaper = "${../../images/quang-binh/1600p.jpg}";
  };
}
