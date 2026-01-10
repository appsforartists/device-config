{
  config,
  inputs,
  lib,
  pkgs,
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

      shellAliases = {
        g = "git";
        gcp = "git cherry-pick";
        grod = "git rebase origin/develop";
        gri = "git rebase -i";
        griod = "git rebase -i origin/develop";
        gmff = "git merge --ff-only";
        grc = "git rebase --continue";
        grs = "git rebase --skip";
        gcl = "git clone";
        gco = "git checkout";
        glo = "git log --oneline --abbrev-commit --graph --decorate --color";
        gsb = "git branch --verbose";
        gst = "git status";
        pscb = "git push";
        yrs = "yarn run start";
        yrbw = "yarn run build --watch";
        yrt = "yarn run test";
        sbrc = "subl ~/.bashrc";
      };
    };
  };
}
