#
# Shell
#
{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true; # Auto suggest options and highlights syntax, searches in history for options
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      histSize = 100000;

      ohMyZsh = {
        # Extra plugins for zsh
        enable = true;
        plugins = [
          "git"
          "web-search"
          "copyfile"
          "dircycle"
        ];
      };

      shellAliases = {
        c = ". /HDD/Dev/createC.sh";
        co = "function test(){ vim /HDD/Dev/C/Beecrowd/\"$1\"/\"$1\".c; }; test";
        cpp = ". /HDD/Dev/createCPP.sh";
        lg = "lazygit";
      };

      shellInit = ''                            # Zsh theme
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
        # Hook direnv
        #emulate zsh -c "$(direnv hook zsh)"
        #eval "$(direnv hook zsh)"
      '';
    };
  };
}
