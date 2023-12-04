#
#  Bspwm Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ home.nix
#   ├─ ./modules
#   │   └─ ./desktop
#   │       └─ ./bspwm
#   │           └─ home.nix *
#   └─ ./services
#       ├─ ./flameshot.nix
#       ├─ ./picom.nix
#       ├─ ./polybar.nix
#       └─ ./sxhkd.nix
{
  config,
  lib,
  pkgs,
  host,
  ...
}: let
  extra = ''
    WORKSPACES                              # Workspace tag names (need to be the same as the polybar config to work)

    bspc config border_width      3
    bspc config window_gaps      12
    bspc config split_ratio     0.5

    bspc config click_to_focus            false
    bspc config focus_follows_pointer     true
    bspc config borderless_monocle        false
    bspc config gapless_monocle           false
    bspc config pointer_action1           move

    #bspc config normal_border_color  "#000000"
    #bspc config focused_border_color "#ffffff"

    #pgrep -x sxhkd > /dev/null || sxhkd &  # Not needed on NixOS

    feh --bg-tile $HOME/.config/wall        # Wallpaper

    killall -q polybar &                    # Reboot polybar to correctly show workspaces
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done

    xsetwacom set "Wacom One by Wacom S Pen stylus" MapToOutput 1920x1080+1920+000000
    xsetwacom set "Wacom One by Wacom S Pen eraser" MapToOutput 1920x1080+1920+000000
    xsetwacom set "Wacom One by Wacom S Pen stylus" Area 0 0 15200 8550
    xsetwacom set "Wacom One by Wacom S Pen eraser" Area 0 0 15200 8550
    xsetwacom set "Wacom One by Wacom S Pen stylus" Button 2 "key F9"
    xsetwacom set "Wacom One by Wacom S Pen stylus" Button 3 "key +shift F9 -shift"
    xsetwacom set "Wacom One by Wacom S Pen eraser" Button 2 "key F9"
    xsetwacom set "Wacom One by Wacom S Pen eraser" Button 3 "key +shift F9 -shift"

    #xsetroot -xcf /usr/share/icons/Dracula-theme/cursors/letf_ptr 16
    gromit-mpx & >/dev/null 2>&1
    polybar main & #2>~/log &               # To lazy to figure out systemd service order
    polybar sec & #2>~/log &
  '';

  extraConf = with host;
    builtins.replaceStrings ["WORKSPACES"]
    [
      (
        if hostName == "desktop"
        then ''
          bspc monitor ${mainMonitor} -d 1 2 3 4 5
          bspc monitor ${secondMonitor} -d 6 7 8 9 0
          bspc wm -O ${mainMonitor} ${secondMonitor}
          polybar main &
          polybar sec &
        ''
        else if hostName == "laptop" || hostName == "vm"
        then ''
          bspc monitor -d 1 2 3 4 5
        ''
        else false
      )
    ]
    "${extra}";
in {
  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager = {
      bspwm = {
        enable = true;
        monitors = with host;
          if hostName == "desktop"
          then {
            ${mainMonitor} = ["1" "2" "3" "4" "5"];
            ${secondMonitor} = ["6" "7" "8" "9" "0"];
          }
          else {}; # Multiple Monitors
        rules = {
          # Specific rules for apps - use xprop
          ".blueman-manager-wrapped" = {
            state = "floating";
            sticky = true;
            desktop = "1";
          };
          "gromit-mpx" = {
            desktop = "11";
          };
          "Pavucontrol" = {
            state = "floating";
            sticky = true;
            desktop = "1";
          };
          "Alacritty" = {
            desktop = "1";
            follow = true;
          };
          "gnome-calculator" = {
            desktop = "1";
            follow = true;
          };
          "Geany" = {
            desktop = "2";
            follow = true;
          };
          "codeblocks" = {
            desktop = "2";
            follow = true;
          };
          "Code" = {
            desktop = "2";
            follow = true;
          };
          "com-cburch-logisim-Main" = {
            desktop = "3";
            follow = true;
          };
          "de-neemann-digital-gui-Main" = {
            desktop = "3";
            follow = true;
          };
          "Arduino IDE" = {
            desktop = "3";
            follow = true;
          };
          "Fritzing" = {
            desktop = "3";
            follow = true;
          };
          "Thunar" = {
            desktop = "4";
            follow = true;
          };
          "file-roller" = {
            desktop = "4";
            follow = true;
          };
          "WxHexEditor" = {
            desktop = "4";
            follow = true;
          };
          "TelegramDesktop" = {
            desktop = "4";
            follow = true;
          };
          "thunar-volman-settings" = {
            desktop = "4";
            follow = true;
          };
          "steam" = {
            desktop = "5";
            follow = true;
          };
          "leagueclientux.exe" = {
            desktop = "5";
            follow = true;
          };
          "Lutris" = {
            desktop = "5";
            follow = true;
          };
          "heroic" = {
            desktop = "5";
            follow = true;
          };
          "PCSX2" = {
            desktop = "5";
            follow = true;
          };
          "prismlauncher" = {
            desktop = "5";
            follow = true;
          };
          "retroarch" = {
            desktop = "5";
            follow = true;
          };
          "com.github.tchx84.Flatseal" = {
            desktop = "5";
            follow = true;
          };
          "Chromium-browser" = {
            desktop = "6";
            follow = true;
          };
          "qutebrowser" = {
            desktop = "6";
            follow = true;
          };
          "Postman" = {
            desktop = "6";
            follow = true;
          };
          "okular" = {
            desktop = "7";
            follow = true;
          };
          "libreoffice" = {
            desktop = "7";
            follow = true;
          };
          "libreoffice-writer" = {
            desktop = "7";
            follow = true;
          };
          "libreoffice-calc" = {
            desktop = "7";
            follow = true;
          };
          "libreoffice-draw" = {
            desktop = "7";
            follow = true;
          };
          "libreoffice-impress" = {
            desktop = "7";
            follow = true;
          };
          "Microsoft Teams - Preview" = {
            desktop = "8";
            follow = true;
          };
          "zoom" = {
            desktop = "8";
            follow = true;
          };
          "obs" = {
            desktop = "8";
            follow = true;
          };
          "Spotify" = {
            desktop = "9";
            follow = true;
          };
          "discord" = {
            desktop = "9";
            follow = true;
          };
          "FreeTube" = {
            desktop = "9";
            follow = true;
          };
          "rnote" = {
            desktop = "1";
            follow = true;
          };
          "Inkscape" = {
            desktop = "9";
            follow = true;
          };
          "krita" = {
            desktop = "9";
            follow = true;
          };
          "Gimp-2.10" = {
            desktop = "9";
            follow = true;
          };
          "*:*:Picture in picture" = {
            #Google Chrome PIP
            state = "floating";
            sticky = true;
          };
          "*:*:Picture-in-Picture" = {
            #Firefox PIP
            state = "floating";
            sticky = true;
          };
          "io.github.alainm23.planify" = {
            desktop = "10";
            follow = true;
          };
          "mpv" = {
            desktop = "10";
            follow = true;
          };
          "obsidian" = {
            desktop = "10";
            follow = true;
          };
          "Anki" = {
            desktop = "10";
            follow = true;
          };
        };
        extraConfig = extraConf;
      };
    };
  };
}
