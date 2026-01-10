{lib, ...}: {
  options.my.system = {
    environment = lib.mkOption {
      type = lib.types.str;
      description = "Which of environments/ to generate?";
    };

    hasDeterminate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is Nix from the multi-user Determinate Nix installer?";
    };
  };
}
