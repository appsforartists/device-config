{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = {
    # required by Sublime for packages that use an old version of Python
    # https://github.com/sublimehq/sublime_text/issues/5984
    #
    # packages can be individually audited and upgraded to use Python 3.8 to
    # avoid using an obsolete version of openssl.
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];

    environment.systemPackages = with pkgs; [
      inconsolata
      sublime4
    ];

    # restart for changes here to take effect
    environment.sessionVariables = {
      EDITOR = "subl -w";
    };
  };
}
