# Gemini updates itself faster than I can be bothered to update a flake.
#
# That means package.json needs to stay mutable, and its settings.json does to
# to allow auth to switch between OAuth and keys as quota from one or the other
# exhausts
#
# Therefore, I set up Gemini with an activation script, but leave it mutable to
# allow it to manage itself.
{
  config,
  lib,
  pkgs,
  ...
}: let
  npmPackages = [
    "@google/gemini-cli"
    "dhost"
  ];
  npmGlobalDir = "${config.home.homeDirectory}/.npm-global";

  geminiSettings = {
    contextFileName = "AGENTS.md";
    security.auth.selectedType = "oauth-personal";
  };
  geminiConfigDir = "${config.home.homeDirectory}/.config/gemini";
in {
  config = {
    home.packages = [pkgs.nodejs];
    home.sessionPath = ["${npmGlobalDir}/bin"];
    home.sessionVariables.NPM_CONFIG_PREFIX = npmGlobalDir;

    home.activation.installNPMGlobalPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
      export PATH="${pkgs.nodejs}/bin:${npmGlobalDir}/bin:$PATH"
      export NPM_CONFIG_PREFIX="${npmGlobalDir}"

      MISSING=()
      for pkg in ${toString npmPackages}; do
        if ! ${pkgs.nodejs}/bin/npm list -g "$pkg" >/dev/null 2>&1; then
          MISSING+=("$pkg")
        fi
      done

      if [ ''${#MISSING[@]} -gt 0 ]; then
        ${pkgs.nodejs}/bin/npm install -g "''${MISSING[@]}"
      fi


      if [ ! -f "${geminiConfigDir}/settings.json" ]; then
        mkdir -p "${geminiConfigDir}"
        echo '${builtins.toJSON geminiSettings}' > "${geminiConfigDir}/settings.json"
      fi
    '';
  };
}
