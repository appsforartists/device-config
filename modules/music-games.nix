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
      yarg
    ];

    fileSystems."/home/${config.mainUser.userName}/.clonehero" = {
      device = "/run/media/mmcblk0p1/Clone Hero";
      fsType = "none";
      options = [
        "bind"
        "x-systemd.automount"
        "noauto"
      ];
    };

    fileSystems."/home/${config.mainUser.userName}/YARG" = {
      device = "/run/media/mmcblk0p1/YARG";
      fsType = "none";
      options = [
        "bind"
        "x-systemd.automount"
        "noauto"
      ];
    };
  };
}
