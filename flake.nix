{
  description = "appsforartists/device-config";

  inputs = {
    # # If you don't have nixpkgs checked out, the branch I use is here:
    # nixpkgs.url = "github:appsforartists/nixpkgs/appsforartists";
    # # not sure how to use `mainUser.userName` in an `input`, so please excuse
    # # the hardcoding.
    nixpkgs.url = "git+file:///home/brenton/Projects/nixpkgs";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gnome-mobile-experimental = {
      url = "github:chuangzhu/nixpkgs-gnome-mobile";
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
    gnome-mobile-experimental,
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
          ./modules/chrome.nix
          ./modules/gnome.nix
          ./modules/sd-card.nix
          ./modules/steam.nix
          ./hosts/go/configuration.nix
        ];
      };
    };
  };
}
