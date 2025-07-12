{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionalString;
in {
  options.chonkos.tmux = {
    enable = mkEnableOption "enable tmux";
    enableSessionizer = mkEnableOption "enable tmux-sessionizer";
  };

  config = {
    programs.tmux = mkIf config.chonkos.tmux.enable {
      enable = true;

      # TODO: Use current user shell
      shell = "${pkgs.zsh}/bin/zsh";
      historyLimit = 100000;

      terminal = "tmux-256color";
      escapeTime = 0;
      prefix = "C-a";
      mouse = true;
      keyMode = "vi";

      extraConfig =
        /*
        tmux
        */
        ''
          # Fixing colors
          set -ga terminal-overrides ",alacritty:Tc"

          # Fix titlebar
          set -g set-titles on
          set -g set-titles-string "#T"

          bind-key -n M-n new-window -c "#{pane_current_path}"
          bind-key -n M-0 select-window -t :0
          bind-key -n M-1 select-window -t :1
          bind-key -n M-2 select-window -t :2
          bind-key -n M-3 select-window -t :3
          bind-key -n M-4 select-window -t :4
          bind-key -n M-5 select-window -t :5
          bind-key -n M-6 select-window -t :6
          bind-key -n M-7 select-window -t :7
          bind-key -n M-8 select-window -t :8
          bind-key -n M-9 select-window -t :9
          bind-key -n M-. select-window -n
          bind-key -n M-, select-window -p
          bind-key -n M-< swap-window -t -1
          bind-key -n M-> swap-window -t +1
          bind-key -n M-x kill-pane

          ${
            optionalString config.chonkos.tmux.enableSessionizer ''
              # Start tmux-sessionizer
              bind-key -n M-f run-shell "tmux neww tmux-sessionizer"
            ''
          }

          # Avoid date/time taking up space
          set -g status-right ""
          set -g status-right-length 0
        '';
    };

    home.packages = [
      (mkIf
        config.chonkos.tmux.enableSessionizer
        (pkgs.writeShellScriptBin
          "tmux-sessionizer"
          ''
               if [[ $# -eq 1 ]]; then
                   selected=$1
               else
                   selected=$(find ~/dev/personal ~/dev/thirdparty ~/dev/uni/* ~/dev/test -mindepth 1 -maxdepth 1 -type d | sed "s#$HOME/##g" | fzf)
               fi

               if [[ -z $selected ]]; then
                   exit 0
               fi

               selected_name=$(basename "$selected" | tr . _)
               tmux_running=$(pgrep tmux)

               if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
                   tmux new-session -s $selected_name -c "$HOME/$selected"
                   exit 0
               fi

               if ! tmux has-session -t=$selected_name 2> /dev/null; then
                   tmux new-session -ds $selected_name -c "$HOME/$selected"
               fi

               if [[ -z $TMUX ]]; then
                   tmux attach-session -t $selected_name
               else
            tmux switch-client -t $selected_name
               fi
          ''))
    ];
  };
}
