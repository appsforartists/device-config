{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "git+file:///home/deck/Projects/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."deck" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home.nix];
    };
  };
}
