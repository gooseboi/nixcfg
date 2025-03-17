{
  pkgs,
  config,
  lib,
  mkMyLib,
  ...
}: let
  myLib = mkMyLib config;
in {
  options.chonkos.zsh = {
    enable = lib.mkEnableOption "enable zsh";
    enableVimMode = lib.mkEnableOption "enable zsh vim mode";
    enableFzfIntegration = lib.mkEnableOption "enable zsh fzf integration";
  };

  config.programs = {
    zsh = lib.mkIf config.chonkos.zsh.enable {
      enable = true;

      enableCompletion = true;

      syntaxHighlighting.enable = true;
      completionInit = "autoload -U compinit && compinit -u";
      autocd = true;
      dotDir = "${myLib.removeHomeDirPrefixStr "${config.xdg.configHome}/zsh"}";

      history = {
        append = true;
        path = "${config.xdg.cacheHome}/zsh_history";
        size = 10000000;
        save = 10000000;
      };

      shellAliases = {
        # Common
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -vI";
        mkd = "mkdir -pv";
        yt = "youtube-dl -f best -ic --add-metadata";
        yta = "youtube-dl -f best -icx --add-metadata";
        ytp = "yt-dlp --download-archive ~/.config/yt/yt-dl-vid.conf";
        ytap = "yt-dlp -icx --add-metadata";
        ffmpeg = "ffmpeg -hide_banner";
        xclipboard = "xclip -selection clipboard";

        # Colour
        grep = "grep --color=auto";
        diff = "diff --color=auto";
      };

      defaultKeymap = lib.mkIf config.chonkos.zsh.enableVimMode "viins";

      initExtra = ''
        autoload -U colors && colors

        PS1="%{$fg[blue]%}[%D{%f/%m/%y} %D{%H:%M:%S}] %B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

        zstyle ':completion:*' menu select
        # Auto complete with case insenstivity
        zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

        ${lib.optionalString config.chonkos.zsh.enableVimMode ''
          # Fix backspace bug when switching modes
          bindkey "^?" backward-delete-char

          # Change cursor shape for different vi modes.
          function zle-keymap-select {
            if [[ ''${KEYMAP} == vicmd ]] ||
               [[ $1 = 'block' ]]; then
              echo -ne '\e[1 q'
            elif [[ ''${KEYMAP} == main ]] ||
                 [[ ''${KEYMAP} == viins ]] ||
                 [[ ''${KEYMAP} = ''' ]] ||
                 [[ $1 = 'beam' ]]; then
              echo -ne '\e[5 q'
            fi
          }
        ''}

        zle -N zle-keymap-select
      '';
    };

    fzf = lib.mkIf config.chonkos.zsh.enableFzfIntegration {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
