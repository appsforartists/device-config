{
  description = "appsforartists/device-config";

  inputs = {
    # # If you don't have nixpkgs checked out, the branch I use is here:
    # nixpkgs.url = "github:appsforartists/nixpkgs/appsforartists";
    # # not sure how to use `mainUser.userName` in an `input`, so please excuse
    # # the hardcoding.
    nixpkgs.url = "git+file:///home/brenton/Projects/nixpkgs";

    gnome-mobile-experimental = {
      url = "github:chuangzhu/nixpkgs-gnome-mobile";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  nixConfig = {
    extra-substituters = [ "https://cosmic.cachix.org/" ];
    extra-trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  outputs = {
    nixpkgs,
    jovian,
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
          ./modules/cosmic.nix
          ./modules/sd-card.nix
          ./modules/steam.nix
          ./modules/sublime.nix
          ./hosts/go/configuration.nix
        ];
      };
    };
  };
}
