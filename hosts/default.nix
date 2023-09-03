#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop OR ./work OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, user, location, dslr, doom-emacs, hyprland, plasma-manager, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  fix = import dslr {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  beelink = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs unstable system user location fix hyprland;
      host = {
        hostName = "beelink";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "HDMI-A-2";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      ./beelink
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user fix doom-emacs;
          host = {
            hostName = "beelink";
            mainMonitor = "HDMI-A-1";
            secondMonitor = "HDMI-A-2";
          };
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./beelink/home.nix
          ];
        };
      }
    ];
  };

  desktop = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit unstable inputs user location;
      host = {
        hostName = "desktop";
        mainMonitor = "DP-2";
	secondMonitor = "DP-0";
      };
    };
    modules = [
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user;
          host = {
            hostName = "desktop";
            mainMonitor = "DP-2";
	    secondMonitor = "DP-0";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./desktop/home.nix)];
        };
      }
    ];
  };

  work = lib.nixosSystem {                                  # Work profile
    inherit system;
    specialArgs = {
      inherit unstable system inputs user location hyprland;
      host = {
        hostName = "work";
        mainMonitor = "eDP-1";
        secondMonitor = "HDMI-A-2";
        thirdMonitor = "DP-1";
      };
    };
    modules = [
      ./work
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user;
          host = {
            hostName = "work";
            mainMonitor = "eDP-1";
            secondMonitor = "HDMI-A-2";
            thirdMonitor = "DP-1";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./work/home.nix)];
        };
      }
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = {
      inherit unstable inputs user location;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
      };
    };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user;
          host = {
            hostName = "vm";
            mainMonitor = "Virtual-1";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        };
      }
    ];
  };

    laptop = lib.nixosSystem {                               # DEPRECATED Desktop profile 
    inherit system;
    specialArgs = {
      inherit inputs unstable system user location fix hyprland;
      host = {
        hostName = "laptop";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "HDMI-A-2";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user fix doom-emacs;
          host = {
            hostName = "laptop";       #For Xorg iGPU  | Hyprland iGPU
            mainMonitor = "HDMI-A-1";   #HDMIA3         | HDMI-A-3
            secondMonitor = "HDMI-A-2"; #DP1            | DP-1
          };
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./laptop/home.nix
          ];
        };
      }
    ];
  };
}
