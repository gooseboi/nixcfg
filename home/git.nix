{
  systemConfig,
  config,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkIf;
in {
  config = mkMerge [
    {
      programs.git = {
        enable = true;

        settings = {
          user = {
            name = "Guzman Zugnoni";
            email = "gooseiman@protonmail.com";
          };

          color.ui = true;

          init.defaultBranch = "master";

          core = {
            editor = "nvim";
            autocrlf = "input";
            safecrlf = true;
          };

          alias = {
            c = "commit";
            s = "status";
            d = "diff";
            ap = "add --patch";
            ds = "diff --staged";
            rp = "restore --patch";
            rs = "restore --staged";
            rsp = "restore --staged --patch";
            lol = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
            l = "log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'";
            dw = "diff --word-diff";
            dws = "diff --word-diff --staged";
          };
        };
      };
    }

    (mkIf systemConfig.chonkos.isDesktop {
      programs.git = {
        settings = {
          core = {
            whitespace = "error";
            preloadindex = true;
          };

          advice = {
            addEmptyPathspec = false;
            pushNonFastForward = false;
            statusHints = false;
          };

          status = {
            branch = true;
            showStash = true;
            showUntrackedFiles = "all";
          };

          diff = {
            context = 3;
            renames = "copies";
            interHunkContext = 10;
          };

          push = {
            autoSetupRemote = true;
            default = "current";
            followTags = true;
          };

          pull = {
            default = "current";
            rebase = true;
          };

          merge.tool = "nvim -d";

          # Github SSH
          url."git@github.com:".insteadOf = "gh:";
          # Github HTTP (Cloning)
          url."https://github.com/".insteadOf = "ghc:";
          # My forgejo
          url."git@git.gooseman.net:".insteadOf = "fj:";

          interactive.singleKey = true;

          gpg.format = "ssh";
        };

        signing = {
          key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
          signByDefault = true;
        };

        lfs = {
          enable = true;
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
      };

      programs.diff-so-fancy = {
        enable = true;

        enableGitIntegration = true;
      };
    })
  ];
}
