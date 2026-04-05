{
  environment.shellAliases = {
    # Common
    cp = "cp --interactive --verbose";
    mv = "mv --interactive --verbose";
    rm = "rm --verbose --interactive=once";
    mkd = "mkdir --parents --verbose";
    ytp = "yt-dlp --download-archive ~/.config/yt/yt-dl-vid.conf";
    ytap = "yt-dlp --ignore-errors --continue --extract-audio --add-metadata";
    ffmpeg = "ffmpeg -hide_banner";
    xclipboard = "xclip -selection clipboard";

    # Colour
    grep = "grep --color=auto";
    diff = "diff --color=auto";
  };
}
