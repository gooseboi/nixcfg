# TODO: https://tonsky.me/blog/syntax-highlighting/
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
    makeBinPath
    mkDisableOption
    mkEnableOption
    mkIf
    mkOption
    optionalString
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

  plugins =
    cfg.plugins
    |> filter (plugin: plugin.enable)
    |> filter (plugin: plugin.isDesktop -> cfg.desktopInstall);

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
      plugins
      |> map (plugin: {
        name = "${removeSuffix ".nix" plugin.name}.lua";
        path = plugin.config;
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
    pkgs.runCommand
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

  pluginPackages =
    plugins
    |> map (p: p.packages)
    |> flatten
    |> unique;

  pkg = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;

    # I don't actually know what having these accomplishes, but I assume that
    # only NixOS bundles these with the package, so it should probably be fine,
    # I guess.
    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

    # Enabling this adds wl-clipboard, which doesn't really make sense if this
    # is a server.
    waylandSupport = cfg.desktopInstall;

    wrapRc = false;
    configure = {};
  };
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

    includeDefaultPlugins = mkDisableOption "enable including the plugins included in the module";

    plugins = mkOption {
      description = "list of plugins to include in the config";
      type =
        types.listOf
        <| types.submodule {
          options = {
            enable = mkDisableOption "enable linking this plugin";

            isDesktop = mkEnableOption "make this plugin only be installed if isDesktop is set";

            name = mkOption {
              description = "the name of the resulting file";
              type = types.str;
            };

            config = mkOption {
              description = "the config of the plugin, as to be a file included by lazy.nvim";
              type = types.path;
            };

            packages = mkOption {
              description = "list of packages that should be added to neovim's path";
              default = [];
              type = types.listOf types.package;
            };
          };
        };
    };
  };

  config = {
    chonkos.neovim = {
      luaFiles = mkIf cfg.includeDefaultLuaFiles (
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

      plugins = mkIf cfg.includeDefaultPlugins (
        listFilesWithNames ./plugins
        |> filter (plugin: hasSuffix ".nix" plugin.path)
        |> map ({
          name,
          path,
        }:
          (import path inputs) // {inherit name;})
      );
    };

    environment.systemPackages = [
      pkg
    ];

    environment.variables = mkIf cfg.setEnvironment {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home-manager.sharedModules = mkIf cfg.enable [
      {
        home.sessionVariables = mkIf cfg.setEnvironment {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };

        home.packages = [
          (pkg.override {
            wrapperArgs =
              optionalString
              (pluginPackages != [])
              ''--suffix PATH : "${makeBinPath pluginPackages}"'';
          })
        ];

        xdg.configFile."nvim" = {
          source = filesJoin;
          recursive = true;
        };
      }
    ];
  };
}
