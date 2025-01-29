{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Guzman Zugnoni";
    userEmail = "gooseiman@protonmail.com";

    extraConfig = {
      color.ui = true;

      core = {
        editor = "nvim";
        autocrlf = "input";
        safecrlf = true;
      };
    };

    aliases = {
      c = "commit";
      s = "status";
      d = "diff";
      ap = "add -p";
      ds = "diff --staged";
      rp = "restore -p";
      rs = "restore --staged";
      rsp = "restore --staged -p";
      lol = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      dw = "diff --word-diff";
      dws = "diff --word-diff --staged";
    };
  };
}
