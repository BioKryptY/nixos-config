#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./editors
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#
{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}: {
  imports =
    # (import ../modules/editors) ++          # Native doom emacs instead of nix-community flake
    import ../modules/shell;

  users.users.${user} = {
    # System User
    isNormalUser = true;
    extraGroups = ["dialout" "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex"];
    shell = pkgs.zsh; # Default shell
    initialHashedPassword = "8c796140427f0a288eda904c3a233c96363e975518c8ffd62ab4d650c28a618200512b71cdbdeae06cc6e3474657397e7f538621686b7cd8e9a4da3e04fdff82";
  };
  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  time.timeZone = "America/Bahia"; # Time zone and internationalisation
  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      # Extra locale settings that need to be overwritten
      LC_TIME = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_ALL = "pt_BR.UTF-8";
    };
  };

  networking.networkmanager.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2"; # or us/azerty/etc
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  fonts.fonts = with pkgs; [
    # Fonts
    carlito # NixOS
    vegur # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    (nerdfonts.override {
      # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];
  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = ["${XDG_BIN_HOME}"];
    };
    systemPackages = with pkgs; [
      # Default packages installed system-wide
      alsa-utils
      jq
      killall
      nano
      fd
      fzf
      pciutils
      pulseaudio
      udisks
      udiskie
      xf86_input_wacom
      libwacom
      ripgrep
      socat
      usbutils
      llvmPackages_rocm.clang
      pipewire
      libcamera
      wget
      gromit-mpx
      git-crypt
      gnupg
      pinentry
      alejandra
      beautysh
      lazygit
      sad
      gnumake
      cmake
      libftdi
      arduino
      arduino-ci
      fritzing
      screen
      time
    ];
  };

  programs = {
    gnupg.agent.enable = true;
    gnupg.agent.pinentryFlavor = "gnome3";
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
  };

  services = {
    localtimed.enable = true;
    automatic-timezoned.enable = true;
    tumbler.enable = true;
    printing = {
      # Printing and drivers for TS5300
      enable = true;
      #drivers = [ pkgs.cnijfilter2 ];          # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now. Also no longer need required since server uses ipp to share printer over network.
    };
    avahi = {
      # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {
        # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    pipewire = {
      # Sound
      enable = true;
      pulse.enable = true;
      # jack.enable = true;
    };
    openssh = {
      # SSH: secure shell (remote connection to shell of server)
      enable = true; # local: $ ssh <user>@<ip>
      # public:
      #   - port forward 22 TCP to server
      #   - in case you want to use the domain name insted of the ip:
      #       - for me, via cloudflare, create an A record with name "ssh" to the correct ip without proxy
      #   - connect via ssh <user>@<ip or ssh.domain>
      # generating a key:
      #   - $ ssh-keygen   |  ssh-copy-id <ip/domain>  |  ssh-add
      #   - if ssh-add does not work: $ eval `ssh-agent -s`
      allowSFTP = true; # SFTP: secure file transfer protocol (send file to server)
      # connect: $ sftp <user>@<ip/domain>
      #   or with file browser: sftp://<ip address>
      # commands:
      #   - lpwd & pwd = print (local) parent working directory
      #   - put/get <filename> = send or receive file
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      ''; # Temporary extra config so ssh will work in guacamole
    };
    # flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
    # sudo flatpak uninstall --delete-data <app-id> (> flatpak list --app) - flatpak uninstall --unused
    # List:
    # com.obsproject.Studio
    # com.parsecgaming.parsec
    # com.usebottles.bottles
  };
  hardware.mwProCapture.enable = true;
  nix = {
    # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable; # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  system = {
    # NixOS settings
    #autoUpgrade = {                         # Allow auto update (not useful in flakes)
    #  enable = true;
    #  channel = "https://nixos.org/channels/nixos-unstable";
    #};
    stateVersion = "22.05";
  };
}
