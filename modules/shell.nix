{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    programs.bash = {
      enable = true;

      # Gemini says you have to manually set up the PATHs when using single-user
      # mode (e.g. on SteamOS).
      initExtra = ''
        if [ -f "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-daemon.sh" ]; then
         . "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-daemon.sh"
        fi
      '';

      profileExtra = ''
        if [ -f "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-daemon.sh" ]; then
         . "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-daemon.sh"
        fi
      '';
    };
  };
}
