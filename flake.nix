{
  description = "Home Manager configuration for each environment";

  inputs = {
    nixpkgs = {
      # @terminal's alias `hms` replaces this with the local checkout
      url = "github:appsforartists/nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Each device has a ./secrets.nix that contains metadata I don't want to
    # share on GitHub.  Since I keep all my git repos in ~/Projects, the
    # absolute path to that file can be computed and imported as `secrets` when
    # `home-manager switch` is run with `--impure` (aliased to `hms` in
    # @terminal.nix).
    secrets = import ((builtins.getEnv "HOME") + "/Projects/device-config/secrets.nix");
    pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
  in {
    homeConfigurations = {
      "steamos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs secrets;};
        modules = [
          secrets.userInfo
          ./environments/steamos.nix
        ];
      };

      "corp" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs secrets;};
        modules = [
          secrets.userInfo
          ./environments/corp.nix
        ];
      };
    };

    devShells = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"] (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShellNoCC {
          packages = [pkgs.alejandra];
          shellHook = ''
            git_root=$(git rev-parse --show-toplevel)
            if [ -d "$git_root/.git/hooks" ]; then
              ln -sf "$git_root/hooks/pre-commit" "$git_root/.git/hooks/pre-commit"
            fi
          '';
        };
      }
    );
  };
}
