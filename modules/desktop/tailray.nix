{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkForce
    mkIf
    ;

  tailscaleEnabled = config.chonkos.tailscale.enable;

  cfg = config.chonkos.desktop;
in {
  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        services.tailray.enable = tailscaleEnabled;

        systemd.user.services.tailray = {
          # This is to replace the value "graphical-session-pre.target" from
          # upstream with "graphical-session.target". Why exactly this is
          # necessary is beyond me, but it fixes the problem. The reason I
          # tried setting it to be this is because network-manager-applet has
          # it done like this.
          Unit.After = mkForce ["graphical-session.target" "tray.target"];
        };
      }
    ];
  };
}
