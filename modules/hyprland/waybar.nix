{systemConfig, ...}: let
  inherit (systemConfig.chonkos) theme;

  cfg = systemConfig.chonkos.hyprland;
in {
  config.programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      enableDebug = cfg.enableDebug;
    };

    # This, and style.css, are mostly stolen from https://gitlab.com/librephoenix/nixos-config/
    # with some small changes for me
    #
    # Cool dude
    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;
        margin = "7 7 3 7";
        spacing = 1;

        modules-left = ["pulseaudio" "cpu" "memory" "backlight" "mpd"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["disk" "network" "sway/language" "clock" "battery" "tray"];

        disk = {
          interval = 30;
          format = "({path}):{free}";
        };

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          all-outputs = true;
          cursor = true;
        };

        network = {
          format-wifi = "{essid} {ipaddr}({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "sway/language" = {
          format = "{short} {variant}";
        };

        tray = {
          icon-size = 22;
          spacing = 10;
        };

        clock = {
          interval = 1;
          format = "{:%a %Y-%m-%d %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          interval = 1;
          format = "{usage}%  - {avg_frequency}GHz";
        };

        memory = {
          interval = 1;
          format = "{}% ";
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          interval = 1;
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          # format-good = ""; # An empty format will hide the module
          # format-full = "";
          format-icons = ["" "" "" "" ""];
        };

        pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon}   {format_source}";
          format-bluetooth = "{volume}% {icon}   {format_source}";
          format-bluetooth-muted = "󰸈 {icon}   {format_source}";
          format-muted = "󰸈 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pypr toggle pavucontrol && hyprctl dispatch bringactivetotop";
        };

        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          interval = 10;
          max-length = 30;
          consume-icons = {
            # Icon shows only when "consume" is on
            on = " ";
          };
          random-icons = {
            # Icon grayed out when "random" is off
            off = "<span color=\"#f53c3c\"></span>";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };
      }
    ];

    style =
      # css
      ''
        * {
        	font-family: ${theme.font.sans.name};

        	font-size: ${builtins.toString theme.font.size.big}px;
        }

        window#waybar {
        	background-color: #1d2021;
        	opacity: 1;
        	border-radius: 8px;
        	color: #fbf1c7;
        	transition-property: background-color;
        	transition-duration: .2s;
        }

        window > box {
        	border-radius: 8px;
        	opacity: 0.94;
        }

        window#waybar.hidden {
        	opacity: 0.2;
        }

        button {
        	border: none;
        }

        #custom-hyprprofile {
        	color: #83a598;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
        	background: inherit;
        }

        #workspaces button {
        	padding: 0 7px;
        	background-color: transparent;
        	color: #bdae93;
        }

        #workspaces button:hover {
        	color: #fbf1c7;
        }

        #workspaces button.active {
        	color: #fb4934;
        }

        #workspaces button.focused {
        	color: #fabd2f;
        }

        #workspaces button.visible {
        	color: #d04e20;
        }

        #workspaces button.urgent {
        	color: #fe8019;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,
        #idle_inhibitor,
        #scratchpad,
        #mpd {
        	padding: 0 10px;
        	color: #fbf1c7;
        	border: none;
        	border-radius: 8px;
        }

        #window,
        #workspaces {
        	margin: 0 4px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
        	margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
        	margin-right: 0;
        }

        #clock {
        	color: #83a598;
        }

        #battery {
        	color: #b8bb26;
        }

        #battery.charging, #battery.plugged {
        	color: #8ec07c;
        }

        @keyframes blink {
        	to {
        		background-color: #fbf1c7;
        		color: #1d2021;
        	}
        }

        #battery.critical:not(.charging) {
        	background-color: #fb4934;
        	color: #fbf1c7;
        	animation-name: blink;
        	animation-duration: 0.5s;
        	animation-timing-function: linear;
        	animation-iteration-count: infinite;
        	animation-direction: alternate;
        }

        label:focus {
        	background-color: #1d2021;
        }

        #cpu {
        	color: #83a598;
        }

        #memory {
        	color: #d3869b;
        }

        #disk {
        	color: #d65d0e;
        }

        #backlight {
        	color: #fabd2f;
        }

        #pulseaudio {
        	color: #8ec07c;
        }

        #pulseaudio.muted {
        	color: #bdae93;
        }

        #tray > .passive {
        	-gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
        	-gtk-icon-effect: highlight;
        }

        #idle_inhibitor {
        	color: #bdae93;
        }

        #idle_inhibitor.activated {
        	color: #d65d0e;
        }
      '';
  };
}
