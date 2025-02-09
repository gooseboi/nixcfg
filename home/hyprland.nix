{
  pkgs,
  config,
  lib,
  ...
}: {
  options.chonkos.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
    enableMpd = lib.mkEnableOption "enable mpd support";
  };

  config = lib.mkIf config.chonkos.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;


      settings = {
      debug.disable_logs = false;

        # This is an example Hyprland config file.
        #
        # Refer to the wiki for more information.

        #
        # Please note not all available settings / options are set here.
        # For a full list, see the wiki
        #

        # See https://wiki.hyprland.org/Configuring/Monitors/
        #monitor = "eDP-1,1920x1080@60,0x0,1";

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        # Execute your favorite apps at launch
        exec-once = [
          "~/.config/waybar/waybar.sh"
          "${pkgs.networkmanagerapplet}/bin/nm-applet"
          "${pkgs.blueman}/bin/blueman-applet"
          "${pkgs.util-linux}/bin/rfkill block bluetooth"
          "${pkgs.dunst}/bin/dunst"
          (lib.optionalString config.chonkos.hyprland.enableMpd "${pkgs/mpd}/bin/mpd")
          "setbg"
          "${pkgs.swayidle}/bin/swayidle -w before-sleep 'hyprland-before-sleep.sh'"
          "pypr"
        ];

        # Some default env vars.
        env = [
          "GDK_SCALE,2"
          "XCURSOR_SIZE,18"
        ];

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input = {
          kb_layout = "us,latam,us";
          kb_variant = ",,dvorak";
          kb_model = "";
          kb_options = "caps:escape_shifted_capslock";
          kb_rules = [
            "repeat_delay = 300"
            "repeat_rate = 50"
          ];
          follow_mouse = "0";

          touchpad = {
            natural_scroll = "true";
            disable_while_typing = "true";
          };

          # -1.0 - 1.0, 0 means no modification.
          sensitivity = "0";
        };

        cursor = {
          no_warps = "true";
        };

        general = {
          gaps_in = "3";
          gaps_out = "10";
          border_size = "2";
          "col.active_border" = "rgba(ffb52aff)";
          "col.inactive_border" = "rgba(1d2021ff)";

          layout = "dwindle";
        };

        decoration = {
          rounding = "0";

          shadow = {
            enabled = "true";
            range = "4";
            render_power = "3";
            color = "rgba(1a1a1aee)";
          };
        };

        animations = {
          enabled = true;

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more

          # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          pseudotile = true;
          force_split = "2";

          # you probably want this
          preserve_split = true;
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          # new_is_master = true
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false;
        };

        layerrule = "blur,waybar";

        bind = [
          "SUPERALT, Q, exit,"

          # Kill current window
          "SUPER, Q, killactive,"

          # Restart waybar
          "SUPERALT, R, exec, ~/.config/waybar/waybar.sh"

          # Move focus with super + vim keys
          "SUPER, H, movefocus, l"
          "SUPER, L, movefocus, r"
          "SUPER, K, movefocus, u"
          "SUPER, J, movefocus, d"
          #bind = SUPER, J, togglesplit, # dwindle

          # Move window with super + shift + vim keys
          "SHIFTSUPER, H, movewindow, l"
          "SHIFTSUPER, L, movewindow, r"
          "SHIFTSUPER, K, movewindow, u"
          "SHIFTSUPER, J, movewindow, d"

          # Swap window order
          "SUPER, O, layoutmsg, togglesplit"
          "CTRLSUPER, H, layoutmsg, preselect l"
          "CTRLSUPER, L, layoutmsg, preselect r"
          "CTRLSUPER, K, layoutmsg, preselect u"
          "CTRLSUPER, J, layoutmsg, preselect d"

          # Lock screen
          "SHIFTSUPER, E, exec, ~/.local/bin/scripts/hyprland/before-sleep.sh"

          # Fullscreen
          "SUPER, F, fullscreen"

          # Change window size
          "SHIFTSUPER, R, submap, resize"
        ];

        #submap=resize
        #
        #binde = , L, resizeactive, 10 0
        #binde = , H, resizeactive, -10 0
        #binde = , J, resizeactive, 0 -10
        #binde = , K, resizeactive, 0 10
        #
        ## use reset to go back to the global submap
        #bind= , escape, submap, reset
        #
        #submap=reset
        #
        #bind = SUPER, Return, exec, $TERMINAL
        #bind = SUPERSHIFT, Return, exec, $TERMINAL -e tmux-sessionizer
        #bind = SUPER, E, exec, dolphin
        #bind = SUPER, Y, togglefloating,
        #bind = SUPER, D, exec, rofi -show run
        #bind = SHIFTSUPER, D, exec, rofi -show drun -show-icons
        #
        ## Volume
        #bindle = SUPER, I, exec, polysetvol -i +5%
        #bindle = , XF86AudioRaiseVolume, exec, polysetvol -i +5%
        #bindle = SUPER, U, exec, polysetvol -i -5%
        #bindle = , XF86AudioLowerVolume, exec, polysetvol -i -5%
        #bindle = SUPER, M, exec, polysetvol -t
        #bindle = , XF86AudioMute, exec, polysetvol -t
        #
        ## Music
        ## Increase or decrease music player volume
        #bindle = SUPERSHIFT, I, exec, mpc volume +5
        #bindle = SUPERSHIFT, U, exec, mpc volume -5
        #bindl = SUPER, COMMA, exec, mpc prev
        #bindl = SUPER, PERIOD, exec, mpc next
        #bindl = SUPERSHIFT, COMMA, exec, mpc seek 0%
        #bindl = SUPERSHIFT, M, exec, mpc toggle
        #bindl = CTRLSUPER, M, exec, playerctl pause -a
        #
        ## Brightness
        #bindle = , XF86MonBrightnessUp, exec, polysetbright -A 5
        #bindle = , XF86MonBrightnessDown, exec, polysetbright -U 5
        #
        ## Launch some common programs
        #bind = CTRLALT, G, exec, gimp
        #bind = CTRLALT, W, exec, $BROWSER
        #bind = CTRLALT, D, exec, discord-canary
        #bind = CTRLALT, F, exec, Thunar
        #
        ## Launch some common terminal programs
        #bind = CTRLALT, M, exec, $TERMINAL -e ncmpcpp
        #bind = CTRLALT, N, exec, $TERMINAL -e nvim
        #bind = CTRLALT, C, exec, $TERMINAL -e calcurse
        #bind = CTRLALT, H, exec, $TERMINAL -e htop
        #bind = CTRLALT, R, exec, $TERMINAL -e run-newsboat
        #
        ## Launch some common scripts
        ## TODO: boomer worked better but no worky on wayland. Maybe port?
        #bind = SUPER, Z, exec, pypr zoom
        #bind = SUPERSHIFT, Z, exec, pypr zoom ++0.7
        #bind = SUPER, V, exec, bmprompt
        #bind = SUPER, C, exec, confprompt
        #bind = SUPER, P, exec, cpcolor
        #bind = SUPER, B, exec, bgprompt
        #
        #bind = SUPER, F9, exec, mountprompt
        #bind = SUPER, F10, exec, umountprompt
        #
        ## Change keyboard layouts
        #bind = SHIFTALT, 1, exec, hyprctl switchxkblayout at-translated-set-2-keyboard 0 # us
        #bind = SHIFTALT, 2, exec, hyprctl switchxkblayout at-translated-set-2-keyboard 1 # latam
        #bind = SHIFTALT, 3, exec, hyprctl switchxkblayout at-translated-set-2-keyboard 2 # us (dvorak)
        #
        ## Screenshots
        #bind = , Print, exec, wayland-screenshot full
        #bind = SHIFT , Print, exec, wayland-screenshot section
        #bind = CTRLSHIFT , Print, exec, wayland-screenshot section copy
        #
        ## Switch workspaces with mainMod + [0-9]
        #bind = SUPER, 1, workspace, 1
        #bind = SUPER, 2, workspace, 2
        #bind = SUPER, 3, workspace, 3
        #bind = SUPER, 4, workspace, 4
        #bind = SUPER, 5, workspace, 5
        #bind = SUPER, 6, workspace, 6
        #bind = SUPER, 7, workspace, 7
        #bind = SUPER, 8, workspace, 8
        #bind = SUPER, 9, workspace, 9
        #bind = SUPER, 0, workspace, 10
        #
        ## Move active window to a workspace with mainMod + SHIFT + [0-9]
        #bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
        #bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
        #bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
        #bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
        #bind = SUPER SHIFT, 5, movetoworkspacesilent, 5
        #bind = SUPER SHIFT, 6, movetoworkspacesilent, 6
        #bind = SUPER SHIFT, 7, movetoworkspacesilent, 7
        #bind = SUPER SHIFT, 8, movetoworkspacesilent, 8
        #bind = SUPER SHIFT, 9, movetoworkspacesilent, 9
        #bind = SUPER SHIFT, 0, movetoworkspacesilent, 10
        #
        ## Scroll through existing workspaces with mainMod + scroll
        #bind = SUPER, mouse_down, workspace, e+1
        #bind = SUPER, mouse_up, workspace, e-1
        #
        ## Move/resize windows with Super + LMB/RMB and dragging
        #bindm = SUPER, mouse:273, resizewindow
        #bindm = SUPER, mouse:272, movewindow
        #
        #bind = SUPER, GRAVE, exec, pypr toggle python
        #bind = SUPER SHIFT, GRAVE, exec, pypr toggle qalc
      };
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
