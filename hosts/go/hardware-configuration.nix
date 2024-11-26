# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/052eb8a2-362c-42d0-9267-8a19250122a1";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/052eb8a2-362c-42d0-9267-8a19250122a1";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2534-B86C";
      fsType = "vfat";
      # silence warning about random seed being writable.
      options = [ "umask=0077" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/052eb8a2-362c-42d0-9267-8a19250122a1";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 18*1024;
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
