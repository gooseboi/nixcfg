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
        ++ [
          pkgs.curl
          pkgs.ffmpeg-full
          pkgs.hyprpicker
          pkgs.mpv
          pkgs.rofi-wayland
          pkgs.simple-mtpfs
          pkgs.wl-clipboard
          pkgs.yt-dlp
        ];
    };
}
