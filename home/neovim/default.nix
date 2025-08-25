inputs @ {
  config,
  isDesktop,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    filter
    hasSuffix
    listFilesWithNames
    lists
    mkDisableOption
    mkEnableOption
    mkIf
    mkOption
    removeSuffix
    ;

  inherit
    (lists)
    flatten
    unique
    ;

  cfg = config.chonkos.neovim;
in {
  options.chonkos.neovim = {
    enable = mkEnableOption "enables neovim support";
    desktopInstall = mkOption {
      description = "makes this neovim install be for a desktop (includes lsp and the like)";
      example = true;
      default = isDesktop;
    };
    setEnvironment = mkDisableOption "set the EDITOR env variable";
  };

  config = mkIf cfg.enable (let
    inherit (config.xdg) configHome;

    luaFiles =
      listFilesWithNames ./lua
      |> filter (file: hasSuffix ".lua" file.path);

    pluginContents =
      listFilesWithNames ./plugins
      |> filter (file: hasSuffix ".nix" file.path)
      |> map ({
        name,
        path,
      }: {
        inherit name;
        file = import path inputs;
      })
      |> filter (file: (file.isDesktop or false) -> cfg.desktopInstall)
      |> filter (file: file.enable or true);

    initContent =
      /*
      lua
      */
      ''
        ${
          luaFiles
          |> map (f: removeSuffix ".lua" f.name)
          |> map (name: ''require("config.${name}")'')
          |> builtins.concatStringsSep "\n"
        }

        -- Add lazy to the `runtimepath`, this allows us to `require` it.
        ---@diagnostic disable-next-line: undefined-field
        vim.opt.rtp:prepend("${pkgs.vimPlugins.lazy-nvim}")

        require("lazy").setup({
          spec = {
              { import = "plugins" },
          },
          rocks = { enabled = false },
          pkg = { enabled = false },
          install = { missing = false },
          change_detection = { enabled = false },
        })
      '';

    initFile = pkgs.writeTextFile {
      name = "init.lua";
      text = initContent;
    };

    filesJoin = let
      pluginItems =
        pluginContents
        |> map (plugin: {
          name = "${removeSuffix ".nix" plugin.name}.lua";
          path = plugin.file.config;
        });

      luaItems = luaFiles;

      mkCopy = items: dir:
        items
        |> map (item:
          /*
          bash
          */
          ''
            cp --dereference --reflink=never ${item.path} $out/${dir}/${item.name}
            chmod 0444 $out/${dir}/${item.name}
          '')
        |> builtins.concatStringsSep "\n";
    in
      pkgs.runCommandNoCC
      "neovimFiles"
      {}
      /*
      bash
      */
      ''
        mkdir -p $out
        cp --dereference --reflink=never ${initFile} $out/init.lua

        mkdir -p $out/lua/plugins
        ${mkCopy pluginItems "lua/plugins"}

        mkdir -p $out/lua/config
        ${mkCopy luaItems "lua/config"}
      '';

    pluginDeps =
      pluginContents
      |> map (p: p.file.packages or [])
      |> flatten
      |> unique;
  in {
    home.sessionVariables = mkIf cfg.setEnvironment {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.neovim = {
      enable = true;

      # We do it ourselves
      defaultEditor = false;
      extraPackages = pluginDeps;
      # TODO:
      #   viAlias = true;
      #   vimAlias = true;
    };

    home.file."${configHome}/nvim" = {
      source = filesJoin;
      recursive = true;
    };
  });
}
