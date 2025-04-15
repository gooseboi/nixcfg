{
  programs.git = {
    enable = true;
    userName = "Guzman Zugnoni";
    userEmail = "gooseiman@protonmail.com";

    extraConfig = {
      color.ui = true;

      init.defaultBranch = "master";

      core = {
        editor = "nvim";
        autocrlf = "input";
        safecrlf = true;
      };

      merge.tool = "nvim -d";
    };

    includes = let
      uniConfig = {
        contents = {
          user = {
            name = "Guzman Zugnoni";
            email = "guzman.zugnoni@correo.ucu.edu.uy";
            signingkey = "~/.ssh/id_uni.pub";
          };

          commit.gpgsign = true;
          gpg.format = "ssh";
          core.sshCommand = "ssh -i ~/.ssh/id_uni";

          url."ssh://git@github.com/".insteadOf = "https://github.com";
        };
      };
    in [
      (uniConfig
        // {
          condition = "gitdir:~/dev/uni/**";
        })
      (uniConfig
        // {
          condition = "gitdir:~/dox/uni/**";
        })
    ];

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
