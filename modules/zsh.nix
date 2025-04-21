{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos;
in {
  options.chonkos.zsh = {
    enable = lib.mkEnableOption "enable system-wide zsh support";
    enableVimMode = lib.mkEnableOption "enable zsh vim mode";
  };

  config = lib.mkIf cfg.zsh.enable {
    programs.zsh.enable = true;
    environment.pathsToLink = ["/share/zsh"];
    users.users.${cfg.user}.shell = pkgs.zsh;

    home-manager.sharedModules = [
      ({mkMyLib, ...} @ hmInputs: let
        hmConfig = hmInputs.config;
        myLib = mkMyLib hmConfig;
      in {
        programs.zsh = lib.mkIf config.chonkos.zsh.enable {
          enable = true;

          enableCompletion = true;

          syntaxHighlighting.enable = true;
          autocd = true;
          dotDir = "${myLib.removeHomeDirPrefixStr "${hmConfig.xdg.configHome}/zsh"}";

          history = {
            append = true;
            path = "${hmConfig.xdg.cacheHome}/zsh_history";
            size = 10000000;
            save = 10000000;
          };

          defaultKeymap = lib.mkIf config.chonkos.zsh.enableVimMode "viins";

          initExtra =
            /*
            bash
            */
            ''
              autoload -U colors && colors

              PS1="%{$fg[blue]%}[%D{%f/%m/%y} %D{%H:%M:%S}] %B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

              zstyle ':completion:*' menu select
              # Auto complete with case insenstivity
              zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

              ${lib.optionalString config.chonkos.zsh.enableVimMode
                /*
                bash
                */
                ''
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
      })
    ];
  };
}
