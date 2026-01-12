{
  config,
  inputs,
  pkgs,
  secrets,
  ...
}: {
  my.system = {
    environment = "corp";
    hasDeterminate = true;
  };

  imports = [
    ./common.nix
    ../modules/terminal.nix
  ];
}
