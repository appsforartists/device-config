{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.google-chrome = {
    enable = true;
    package = lib.my.makeSteamSafe pkgs.google-chrome;
    plasmaSupport = true;
    commandLineArgs = [
      "--enable-features=DefaultANGLEVulkan,TreesInViz,Vulkan,VulkanFromANGLE"
      "--top-chrome-touch-ui=enabled"
    ];
  };
}
