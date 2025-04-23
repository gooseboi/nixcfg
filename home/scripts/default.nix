{
  config,
  lib,
  pkgs,
  ...
}: let
  files = builtins.readDir ./. |> lib.attrsToList;
  filteredFiles = files |> builtins.filter (f: f.value != "directory" && !lib.strings.hasSuffix ".nix" f.name);
  fileNames = filteredFiles |> map (f: f.name);
in {
  options.chonkos.scripts = {
    enable = lib.mkEnableOption "enable scripts";
  };

  config =
    lib.mkIf config.chonkos.scripts.enable
    {
      chonkos.rofi.enable = true;

      home.packages =
        (fileNames
          |> map (
            f: pkgs.writeShellScriptBin f (builtins.readFile (./. + "/${f}"))
          ))
        ++ (with pkgs; [
          curl
          ffmpeg-full
          file
          hyprpicker
          libnotify
          mpv
          simple-mtpfs
          swaybg
          wl-clipboard
          yt-dlp
        ]);

      xdg.configFile."yt/yt-dl-channel.conf".text = ''
        -i
        -c
        -o "%(uploader)s/%(playlist_title)s/%(upload_date)s - %(title)s - (%(duration)ss) [%(resolution)s] [%(id)s].%(ext)s"

        # Cookies
        --cookies ~/.local/share/youtube_cookies.txt

        # Uniform Format
        --prefer-ffmpeg
        --merge-output-format mkv

        # Get All Subs to SRT
        --convert-subs srt
        --all-subs
        --embed-subs

        # Get metadata
        --add-metadata
        --write-description
        --embed-chapters
        --write-thumbnail

        # Debug
        -v
      '';

      xdg.configFile."yt/yt-dl-playlist.conf".text = ''
        -i
        -c
        -o "%(playlist_title)s/%(playlist_index)s - %(uploader)s - %(upload_date)s - %(title)s - (%(duration)ss) [%(resolution)s] [%(id)s].%(ext)s"

        # Cookies
        --cookies ~/.local/share/youtube_cookies.txt

        # Uniform Format
        --prefer-ffmpeg
        --merge-output-format mkv

        # Get All Subs to SRT
        --convert-subs srt
        --all-subs
        --embed-subs

        # Get metadata
        --add-metadata
        --write-description
        --write-thumbnail
        --embed-chapters

        # Debug
        -v
      '';

      xdg.configFile."yt/yt-dl-vid.conf".text = ''
        -i
        -c
        -o "%(uploader)s - %(upload_date)s - %(title)s - (%(duration)ss) [%(resolution)s] [%(id)s].%(ext)s"

        # Cookies
        --cookies ~/.local/share/youtube_cookies.txt

        # Uniform Format
        --prefer-ffmpeg
        --merge-output-format mkv

        # Get All Subs to SRT
        --convert-subs srt
        --all-subs
        --embed-subs

        # Get metadata
        --add-metadata
        --embed-chapters
        --embed-thumbnail

        # Debug
        -v
      '';
    };
}
