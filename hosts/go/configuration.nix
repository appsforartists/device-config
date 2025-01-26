{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.jovian.nixosModules.default
    ./hardware-configuration.nix
  ];

  jovian.devices.legiongo.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;

    # zenpower is supposed to be better for reading sensors on a modern AMD APU
    extraModulePackages = with config.boot.kernelPackages; [zenpower];
    kernelModules = ["zenpower"];
    blacklistedKernelModules = ["k10temp"];

    # doesn't seem to be useful yet
    # extraModulePackages = with config.boot.kernelPackages; [ lenovo-legion-module ];

    plymouth = {
      enable = true;
      theme = "steamos";
      themePackages = with pkgs; [
        plymouth-steamos-theme
      ];
    };

    loader = {
      # if we've got no keyboard, no sense in waiting for a screen we can't
      # interact with
      timeout = 0;
      systemd-boot = {
        enable = true;
        # "1" fixes the orientation, but the text is unfortunately small.
        # "max" also fixes the orientation, but stretches the text to fill the
        # screen.
        # The text is clipped no matter which option you choose.
        consoleMode = "max";
        # the docs say to turn this off on modern systems for a more secure
        # setup.
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  services.handheld-daemon = {
    enable = true;
    user = config.mainUser.userName;
  };

  environment.systemPackages = with pkgs; [
    git
    toybox

    p7zip
  ];

  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  powerManagement.enable = true;

  hardware.pulseaudio.enable = lib.mkForce false; #forcing to make plasma-mobile deal with it
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
