{
  description = "appsforartists/device-config";

  inputs = {
    nixpkgs.url = "github:appsforartists/nixpkgs/qtwayland";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS/f6449e2cc38f2be0a32f1d6e9caf50c4c76898b7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    jovian,
    nix-gaming,
    ...
  } @ inputs:

  let
    goHostname = "${mainUserModule.mainUser.userName}-go";
    mainUserModule = {
      mainUser = {
        userName = "brenton";
        fullName = "Brenton Simpson";
      };
      imports = [
        ./modules/main-user.nix
      ];
    };

  in {
    nixosConfigurations = {
      "${ goHostname }" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {inherit inputs system;};
        modules = [
          {
            nix.settings.experimental-features = ["nix-command" "flakes"];
            networking.hostName = "${ goHostname }";
          }
          mainUserModule
          ./modules/sd-card.nix
          ./modules/steam.nix
          ./hosts/go/configuration.nix
        ];
      };
    };
  };
}
