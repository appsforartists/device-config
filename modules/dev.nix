{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    fileSystems."/home/${config.mainUser.userName}/Projects" = {
      device = "/run/media/mmcblk0p1/Projects";
      fsType = "none";
      options = [
        "bind"
        "x-systemd.automount"
        "noauto"
      ];
    };
  };
}
