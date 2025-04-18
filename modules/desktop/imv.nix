{
  programs.imv = {
    enable = true;
    settings = {
      binds = {
        q = "quit";

        # Image navigation
        "<Left>" = "prev";
        "<Right>" = "next";
        "<Shift+K>" = "prev";
        "<Shift+J>" = "next";
        gg = "goto 1";
        "<Shift+G>" = "goto -1";

        # Panning
        j = "pan 0 -50";
        k = "pan 0 50";
        h = "pan 50 0";
        l = "pan -50 0";

        # Zooming
        "<Shift+plus>" = "zoom 1";
        "<minus>" = "zoom -1";
        "<Shift+I>" = "zoom 1";
        "<Shift+O>" = "zoom -1";

        # Rotate Clockwise by 90 degrees
        "<Ctrl+r>" = "rotate by 90";

        # Other commands
        f = "fullscreen";
        i = "overlay";
        p = "exec echo $imv_current_file";
        c = "center";
        s = "scaling next";
        "<Shift+S>" = "upscaling next";
        a = "zoom actual";
        r = "reset";

        # Gif playback
        "<period>" = "next_frame";
        "<space>" = "toggle_playing";

        # Slideshow control
        t = "slideshow +1";
        "<Shift+T>" = "slideshow -1";
      };
    };
  };
}
