{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;

    syntaxHighlighting.enable = true;
    completionInit = "autoload -U compinit && compinit -u";
    autocd = true;

    history = {
      append = true;
      path = "$HOME/.cache/zsh_history";
      size = 10000000;
      save = 10000000;
    };

    shellAliases = {
      # Common
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      mkd = "mkdir -pv";
      yt = "youtube-dl -f best -ic --add-metadata";
      yta = "youtube-dl -f best -icx --add-metadata";
      ytp = "yt-dlp --download-archive ~/.config/yt/yt-dl-vid.conf";
      ytap = "yt-dlp -icx --add-metadata";
      ffmpeg = "ffmpeg -hide_banner";
      xclipboard = "xclip -selection clipboard";

      # Colour
      grep = "grep --color=auto";
      diff = "diff --color=auto";
    };

    initExtra = ''
      PS1="%{$fg[blue]%}[%D{%f/%m/%y} %D{%H:%M:%S}] %B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
    '';
  };
}
