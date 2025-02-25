{
  pkgs,
  config,
  lib,
  ...
}: let
  files = lib.attrsToList (builtins.readDir ./.);
  filteredFiles = builtins.filter (f: f.value != "directory" && !lib.strings.hasSuffix ".nix" f.name) files;
  fileNames = builtins.map (f: f.name) filteredFiles;
in {
  options.chonkos.scripts = {
    enable = lib.mkEnableOption "enable scripts";
  };

  config =
    lib.mkIf config.chonkos.scripts.enable
    {
      home.packages =
        builtins.map (
          f: pkgs.writeShellScriptBin f (builtins.readFile (./. + "/${f}"))
        )
        fileNames
        ++ (with pkgs; [
          curl
          ffmpeg-full
          hyprpicker
          mpv
          rofi-wayland
          simple-mtpfs
          wl-clipboard
          yt-dlp
          file
          libnotify
        ]);
    };
}
