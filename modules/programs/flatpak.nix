#
# Very janky way of declaring all flatpaks used
# Might cause issues on new system installs
# Only use when you know what you're doing
#
{pkgs, ...}: {
  services.flatpak.enable = true;
  system.activationScripts = {
    flatpak.text = ''
      flatpaks=(
        "com.github.tchx84.Flatseal"
        "org.telegram.desktop"
        "org.gimp.GIMP"
        "org.wxhexeditor.wxHexEditor"
        "md.obsidian.Obsidian"
        "org.inkscape.Inkscape"
        "org.kde.krita"
        "com.github.flxzt.rnote"
        "net.ankiweb.Anki"
        "com.getpostman.Postman"
        "io.freetubeapp.FreeTube"
        "cc.arduino.IDE2"
        "org.winehq.Wine"
        "com.ktechpit.orion"
      )

      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

      for package in ''${flatpaks[*]}; do
        check=$(${pkgs.flatpak}/bin/flatpak list --app | ${pkgs.gnugrep}/bin/grep $package)
        if [[ -z "$check" ]] then
          ${pkgs.flatpak}/bin/flatpak install -y flathub $package
        fi
      done

      installed=($(${pkgs.flatpak}/bin/flatpak list --app | ${pkgs.gawk}/bin/awk -F$'\t*' '{$1=$3=$4=$5=""; print $0}'))

      for remove in ''${installed[*]}; do
        if [[ ! " ''${flatpaks[*]} " =~ " ''${remove} " ]]; then
          ${pkgs.flatpak}/bin/flatpak uninstall -y $remove
          ${pkgs.flatpak}/bin/flatpak uninstall -y --unused
        fi
      done
    '';
  };
}
