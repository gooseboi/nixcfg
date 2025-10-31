inputs @ {
  config,
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
    types
    ;

  inherit
    (lists)
    flatten
    unique
    ;

  cfg = config.chonkos.neovim;

  luaFiles =
    cfg.luaFiles
    |> filter (file: file.enable)
    |> map ({
      name,
      source,
      text,
      ...
    }: {
      inherit name;
      path =
        if text != null
        then
          pkgs.writeTextFile {
            inherit name text;
          }
        else source;
    });

  pluginContents =
    listFilesWithNames ./plugins
    |> filter (plugin: hasSuffix ".nix" plugin.path)
    |> map ({
      name,
      path,
    }: {
      inherit name;
      file = import path inputs;
    })
    |> filter (plugin: (plugin.file.isDesktop or false) -> cfg.desktopInstall)
    |> filter (plugin: plugin.file.enable or true);

  initFile = pkgs.writeTextFile {
    name = "init.lua";
    text =
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
  };

  filesJoin = let
    pluginItems =
      pluginContents
      |> map (plugin: {
        name = "${removeSuffix ".nix" plugin.name}.lua";
        path = plugin.file.config;
      });

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
      ${mkCopy luaFiles "lua/config"}
    '';

  pluginDeps =
    pluginContents
    |> map (p: p.file.packages or [])
    |> flatten
    |> unique;
in {
  options.chonkos.neovim = {
    enable = mkEnableOption "enables neovim support";

    desktopInstall = mkOption {
      description = "makes this neovim install be for a desktop (includes lsp and the like)";
      type = types.bool;
      example = true;
      default = config.chonkos.isDesktop;
    };

    setEnvironment = mkDisableOption "set the EDITOR env variable";

    includeDefaultLuaFiles = mkDisableOption "enable including the lua files included in the module";

    luaFiles = mkOption {
      description = "list of plain lua files to include in the config";
      type =
        types.listOf
        <| types.submodule {
          options = {
            enable = mkDisableOption "enable linking this file";

            name = mkOption {
              description = "the name of the resulting file";
              type = types.str;
            };

            source = mkOption {
              description = "the path of the source file";
              type = types.path;
            };

            text = mkOption {
              description = "the text of the resulting file. This overrides source if non-null";
              default = null;
              type = types.nullOr types.str;
            };
          };
        };
    };
  };

  config = {
    chonkos.neovim.luaFiles = mkIf cfg.includeDefaultLuaFiles (
      listFilesWithNames ./lua
      |> filter (file: hasSuffix ".lua" file.path)
      |> map ({
        name,
        path,
      }: {
        inherit name;
        source = path;
      })
    );

    programs.neovim = {enable = true;};

    home-manager.sharedModules = mkIf cfg.enable [
      (hmInputs: let
        hmConfig = hmInputs.config;
      in {
        home.sessionVariables = mkIf cfg.setEnvironment {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };

        # TODO: Is there a way to override the final wrapped package here?
        #
        # Probably just not using the home-manager module, but I don't wanna do
        # that now. The point of doing this is to disable the dependency on
        # wl-clipboard for neovim if this module is for a server.
        programs.neovim = {
          enable = true;

          # We do it ourselves
          defaultEditor = false;
          extraPackages = pluginDeps;
          viAlias = true;
          vimAlias = true;
        };

        home.file."${hmConfig.xdg.configHome}/nvim" = {
          source = filesJoin;
          recursive = true;
        };
      })
    ];
  };
}
