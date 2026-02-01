{
  config,
  lib,
  pkgs,
  ...
}: let
  iconSize = "40"; # must be a string because it's used in paths below

  widgetPackages = {
    andromeda-launcher = pkgs.stdenv.mkDerivation rec {
      pname = "andromeda-launcher";
      version = "unstable-2026-01-04";
      src = pkgs.fetchFromGitHub {
        owner = "EliverLara";
        repo = "AndromedaLauncher";
        rev = "995a51367785e2c9688456660c05ada955f4da6a";
        hash = "sha256-ZrWKr6VNNCErwBruAYVNenbwjB6CJFwJFQHwNXl/hUE=";
      };
      dontBuild = true;
      passthru.widgetID = "AndromedaLauncher";
      installPhase = ''
        mkdir -p $out/share/plasma/plasmoids/${passthru.widgetID}
        cp -r * $out/share/plasma/plasmoids/${passthru.widgetID}/
      '';
    };

    html-clock = pkgs.stdenv.mkDerivation rec {
      pname = "html-clock";
      version = "2.1.0";
      src = pkgs.fetchFromGitHub {
        owner = "MarcinOrlowski";
        repo = "html-clock-plasmoid";
        rev = version;
        hash = "sha256-azHLv7WgF7KrVTvZkzsm28GUKJxYC3d2HGoWJ0di76I=";
      };
      dontBuild = true;
      passthru.widgetID = "com.marcinorlowski.htmlclock";
      installPhase = ''
        mkdir -p $out/share/plasma/plasmoids/${passthru.widgetID}
        cp -r src/* $out/share/plasma/plasmoids/${passthru.widgetID}/
      '';
    };
  };

  widgets = {
    battery = {
      battery = {
        showPercentage = true;
      };
    };

    apps = {
      iconTasks = {
        launchers = [
          "applications:com.google.Chrome.desktop"
          "applications:sublime_text.desktop"
          "applications:com.mitchellh.ghostty.desktop"
          "preferred://filemanager"
          "applications:steam.desktop"
          "applications:systemsettings.desktop"
        ];
        appearance = {
          showTooltips = true;
          highlightWindows = true;
          indicateAudioStreams = true;
          fill = true;
          iconSpacing = "medium";
        };
        behavior.grouping.clickAction = "showPresentWindowsEffect";
      };
    };
    wifi = "org.kde.plasma.networkmanagement";
    clipboard = "org.kde.plasma.clipboard";

    clock = {
      name = widgetPackages.html-clock.passthru.widgetID;
      config = {
        Appearance = {
          useUserLayout = "true";
        };
        Layout = {
          layout = ''
            <center style="
              font-family: Jost;
              font-weight: 600;
              font-size: 15px;
              color: white;
            ">
              {k}:{ii}
            </center>
          '';
        };
      };
    };

    drawer = {
      name = widgetPackages.andromeda-launcher.passthru.widgetID;
      config = {
        General = {
          customButtonImage = config.misc.material-icons.absolutePath "launcher.svg";
          floating = "true";
          launcherPosition = "2";
          showItemsInGrid = "true";
          useCustomButtonImage = "true";
        };
      };
    };
  };
in {
  misc.material-icons = {
    enable = true;
    groups = {
      "panel-icons" = {
        color = "white";
        icons = {
          "launcher.svg" = "symbols/web/action_key/materialsymbolssharp/action_key_fill1_${iconSize}px.svg";
          "settings.svg" = "symbols/web/settings/materialsymbolssharp/settings_fill1_${iconSize}px.svg";
        };
      };
    };
    hash = "sha256-wm2iomOeKwWL8jOldGRb+Qi+shTVrTutKxW0RFGcQJg=";
  };

  programs.plasma.dataFile."applications/systemsettings.desktop" = {
    "Desktop Entry" = {
      Type = "Application";
      Name = "System Settings";
      Exec = "systemsettings";
      Icon = config.misc.material-icons.absolutePath "settings.svg";
      StartupWMClass = "systemsettings";
      Categories = "Qt;KDE;Settings;";
      GenericName = "System Settings";
      Comment = "Configuration tools for your computer";
    };
  };

  home.packages = with widgetPackages; [
    pkgs.jost
    andromeda-launcher
    html-clock
  ];

  programs.plasma.panels = with widgets; [
    {
      location = "right";
      height = 56;
      widgets = with widgets; [
        {
          plasmaPanelColorizer = {
            general.enable = true;
            panelBackground.customBackground = {
              enable = true;
              colorSource = "custom";
              customColor = "#000000";
              opacity = 1.0;
            };
          };
        }
        battery
        clock
        apps
        drawer
        wifi
        clipboard
      ];
    }
  ];
}
