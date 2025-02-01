# Adds the udev rules that mount an SD card to `/run/media/mmcblk0p1`, the
# ephemeral location used on the Steam Deck.
#
# Mounting in `hardware-configuration` doesn't work, since `/run/media` is an
# ephemeral path.

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.sdCard;
in
{
  options.sdCard = {
    ext4Options = lib.mkOption {
      default = [
        "noatime"
        "rw"
      ];
      description = ''
        The mount options for a ext4 SD card.
      '';
    };
  };

  config = {
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="block", KERNEL=="mmcblk[0-9]p[0-9]", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${ pkgs.systemd }/bin/systemd-mount -o ${ lib.concatStringsSep "," cfg.ext4Options } --no-block --automount=yes --collect $devnode /run/media/mmcblk0p1"
    '';
  };
}
