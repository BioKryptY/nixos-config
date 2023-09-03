#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;        # Theme.rasi alternative. Add Theme here
  colors = import ../themes/colors.nix;
in
{
  config = lib.mkIf (config.xsession.enable) {
    home = {
      packages = with pkgs; [
        rofi-power-menu
      ];
    };

    programs = {
      rofi = {
        enable = true;
        terminal = "${pkgs.alacritty}/bin/alacritty";           # Alacritty is default terminal emulator
        location = "center";
        font = "FiraCode Nerd Font Mono 12";
        extraConfig = {
	   display-drun = " ";
            show-icons = true;
            drun-display-format = "{name}";
            disable-history = false;
             sidebar-mode = false; 
	 };
         theme = ./style.rasi;
        };
     
    };
  };
}
