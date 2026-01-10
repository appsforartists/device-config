# Welcome to `appsforartists/device-config`!

This repo is where I experiment with potentially esoteric device setups.  It was previously used to [run Sublime Text on a Chromebook Pixel](../../tree/pixel-webdev), and [try NixOS on a Lenovo Legion Go](../../tree/nixos).

Now, I'm using it to hold my Nix Home Manager config.  Home Manager lets me install packages on otherwise-immutable SteamOS, as well as ensure that my settings are shared across devices (e.g. between work and home).

# Setup

## Checkout the repos
By convention, this repo always lives at `~/Projects`, alongside a blobless clone of `nixpkgs`.

```
mkdir -p ~/Projects
cd ~/Projects
git clone git@github.com:appsforartists/device-config.git
git clone --filter=blob:none git@github.com:appsforartists/nixpkgs.git
cd nixpkgs
git checkout appsforartists
cd ../device-config
```

## Setup the secrets
By that same convention, device-specific config that doesn't belong on Github goes in `~/Projects/device-config/secrets.nix`

```nix
{
  userInfo = {
    home.username = "deck";
    home.homeDirectory = "/home/deck";
  };

  geminiAPIKey = "…";
}
```

## Close the Klein bottle
Those conventions allow us to keep secrets out of Git without defying Nix's usual reluctance to include `.gitignore`d files.

`home-manager switch` needs some flags to set itself up.  Pick an environment from `./environments` and then run:

```
FLAKE_ENVIRONMENT="…"
nix run home-manager/master -- switch \
  --flake "$HOME/Projects/device-config#$FLAKE_ENVIRONMENT" \
  --override-input nixpkgs "git+file://$HOME/Projects/nixpkgs" \
  --impure
```

After its first run, this command will be encoded to the alias `hms` for future usage.
