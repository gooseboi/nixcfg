{
  pkgs,
  lib,
  config,
  ...
}: {
  options.chonkos.tmux = {
    enable = lib.mkEnableOption "enable tmux";
    enableSessionizer = lib.mkEnableOption "enable tmux-sessionizer";
  };

  config = {
    programs.tmux = lib.mkIf config.chonkos.tmux.enable {
      enable = true;

      shell = "${pkgs.zsh}/bin/zsh";
      historyLimit = 100000;

      terminal = "tmux-256color";
      escapeTime = 0;
      prefix = "C-a";
      mouse = true;
      keyMode = "vi";

      extraConfig = ''
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
          lib.optionalString config.chonkos.tmux.enableSessionizer ''
            # Start tmux-sessionizer
            bind-key -n M-f run-shell "tmux neww tmux-sessionizer"
          ''
        }

        # Avoid date/time taking up space
        set -g status-right ""
        set -g status-right-length 0
      '';
    };
  };
}
