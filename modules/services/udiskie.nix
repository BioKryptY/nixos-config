#
# Mounting tool
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    udiskie = {
      # Udiskie wil automatically mount storage devices
      enable = true;
      automount = true;
      tray = "always"; # Will only show up in systray when active
    };
  };
}
