#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#              └─ home.nix
#
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/desktop/bspwm/home.nix # Window Manager
  ];

  home = {
    # Specific packages for laptop
    packages = with pkgs; [
      # Applications
      libreoffice # Office packages

      # Display
      #light                              # xorg.xbacklight not supported. Other option is just use xrandr.

      # Power Management
      #auto-cpufreq                       # Power management
      #tlp                                # Power management
    ];
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      ];
    };
    alacritty.settings.font.size = 12;
    git = {
      userName = "Lucas Fernandes";
      userEmail = "luqinhafernandes@hotmail.com";
    };
  };

  services = {
    # Applets
    network-manager-applet.enable = true; # Network
    #   cbatticon = {
    #     enable = true;
    #     criticalLevelPercent = 10;
    #     lowLevelPercent = 20;
    #     iconType = null;
    #   };
  };
}
