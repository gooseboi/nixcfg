{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionalString;

  cfg = config.chonkos.zsh;
in {
  options.chonkos.zsh = {
    enable = mkEnableOption "enable system-wide zsh support";
    enableUserShell = mkEnableOption "enable setting as default shell";
    enableVimMode = mkEnableOption "enable zsh vim mode";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    environment.pathsToLink = ["/share/zsh"];
    users.users.${config.chonkos.user} = mkIf cfg.enableUserShell {
      shell = pkgs.zsh;
    };

    home-manager.sharedModules = [
      ({...} @ hmInputs: let
        hmConfig = hmInputs.config;
      in {
        home.packages = [
          (
            pkgs.writeShellScriptBin "reset_env_zsh"
            /*
            zsh
            */
            ''
              # To source all the variables from home-manager again, we have to
              # unset these variables, as hm uses them for caching the results
              # of evaluating the variables.

              # NixOS
              unset __ETC_PROFILE_SOURCED
              unset __NIXOS_SET_ENVIRONMENT_DONE

              # Home Manager
              unset __HM_SESS_VARS_SOURCED
              unset __HM_ZSH_SESS_VARS_SOURCED
              source ${hmConfig.xdg.configHome}/zsh/.zshenv
              source /etc/zshenv
            ''
          )
        ];

        programs.zsh = mkIf config.chonkos.zsh.enable {
          enable = true;

          enableCompletion = true;

          syntaxHighlighting.enable = true;
          autocd = true;
          dotDir = "${hmConfig.xdg.configHome}/zsh";

          history = {
            append = true;
            path = "${hmConfig.xdg.dataHome}/zsh_history";
            size = 10000000;
            save = 10000000;
          };

          defaultKeymap = mkIf config.chonkos.zsh.enableVimMode "viins";

          envExtra =
            /*
            bash
            */
            ''
              # If we are a tty, then any shell we launch is probably a user
              # shell in a display manager or something, and it probably wants
              # to source the variables again
              if [[ $(tty) == /dev/tty* ]]; then
                # NixOS
                unset __ETC_PROFILE_SOURCED
                unset __NIXOS_SET_ENVIRONMENT_DONE

                # Home Manager
                unset __HM_SESS_VARS_SOURCED
                unset __HM_ZSH_SESS_VARS_SOURCED
              fi
            '';

          initContent =
            /*
            bash
            */
            ''
              autoload -U colors && colors

              PS1="%{$fg[blue]%}[%D{%f/%m/%y} %D{%H:%M:%S}] %B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

              zstyle ':completion:*' menu select
              # Auto complete with case insenstivity
              zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

              ${optionalString config.chonkos.zsh.enableVimMode
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
