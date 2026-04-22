{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    hiPrio
    mkBoolOption
    mkIf
    ;

  inherit (config.chonkos) isDesktop;

  cfg = config.chonkos.dev;
in {
  options.chonkos.dev = {
    enable = mkBoolOption "enable dev tools" isDesktop;
  };

  config = mkIf cfg.enable {
    chonkos.unfree.allowed = [
      "antigravity"
      "cursor"
      "ngrok"
    ];

    environment.systemPackages = with pkgs; [
      # C/C++
      (hiPrio gcc) # To stop conflict with clang for c++ bin
      cdecl
      clang
      clang-tools
      cmake
      gdb
      gf
      libgcc
      meson
      ninja

      # Javascript
      bun
      deno
      nodejs
      pnpm

      # Python
      python3.pkgs.pip
      python3
      uv
      virtualenv

      # Java
      temurin-bin-21
      (
        maven.override {
          jdk_headless = temurin-bin-21.override {gtkSupport = false;};
        }
      )

      # Rust
      bacon
      binaryen
      cargo-expand
      cargo-flamegraph
      cargo-fuzz
      cargo-leptos
      cargo-nextest
      cargo-show-asm
      dart-sass
      (fenix.combine [
        (fenix.complete.withComponents [
          "cargo"
          "clippy"
          "miri"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        fenix.targets.wasm32-unknown-unknown.latest.rust-std
      ])

      # Haskell
      (
        ghc.withPackages
        (p: [
          p.stack
          p.cabal-install
        ])
      )

      # AI Slop
      antigravity-fhs
      code-cursor-fhs
      codex
      gemini-cli
      opencode
      t3code

      # Web Dev
      (
        dbeaver-bin.override {
          openjdk21 = temurin-bin-21;
        }
      )

      # Golang
      air
      go

      # Solo
      lean4
      odin
      rocq-core
      zig

      # General
      cloc
      codespelunker
      gh
      gnumake
      mermaid-cli
      ngrok
      tokei
      tracy
    ];

    home-manager.sharedModules = [
      (hmInputs: let
        hmConfig = hmInputs.config;

        mavenSettings = "maven/settings.xml";
        mavenRepo = "maven/repository";
      in {
        home.sessionVariables = {
          CABAL_CONFIG = "${hmConfig.xdg.configHome}/cabal/config";
          CABAL_DIR = "${hmConfig.xdg.dataHome}/cabal";
          CARGO_HOME = "${hmConfig.xdg.dataHome}/cargo";
          DOTNET_CLI_HOME = "${hmConfig.xdg.dataHome}/dotnet";
          ELAN_HOME = "${hmConfig.xdg.dataHome}/elan";
          GEM_PATH = "${hmConfig.xdg.dataHome}/ruby/gems";
          GEM_SPEC_CACHE = "${hmConfig.xdg.dataHome}/ruby/specs";
          GHCUP_USE_XDG_DIRS = "true";
          GOPATH = "${hmConfig.xdg.dataHome}/go";
          JUPYTER_CONFIG_DIR = "${hmConfig.xdg.configHome}/jupyter";
          MAVEN_ARGS = "--settings ${hmConfig.xdg.configHome}/${mavenSettings}";
          MAVEN_OPTS = "-Dmaven.repo.local=${hmConfig.xdg.dataHome}/${mavenRepo}";
          NODE_REPL_HISTORY = "${hmConfig.xdg.dataHome}/node_repl_history";
          NPM_CONFIG_CACHE = "${hmConfig.xdg.cacheHome}/npm";
          NPM_CONFIG_INIT_MODULE = "${hmConfig.xdg.configHome}/npm/config/npm-init.js";
          NPM_CONFIG_TMP = ''''${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}/npm'';
          NPM_CONFIG_USERCONFIG = "${hmConfig.xdg.configHome}/npm/npmrc";
          NUGET_PACKAGES = "${hmConfig.xdg.cacheHome}/nuget";
          OPAMROOT = "${hmConfig.xdg.dataHome}/opam";
          PYTHON_HISTORY = "${hmConfig.xdg.stateHome}/python/history";
          RUSTUP_HOME = "${hmConfig.xdg.dataHome}/rustup";
          VAGRANT_HOME = "${hmConfig.xdg.dataHome}/vagrant";
          _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${hmConfig.xdg.configHome}/java -Dswing.aatext=true -Dawt.useSystemAAFontSettings=on";
        };

        xdg.stateFile."python/.keep".text = "";

        xdg.configFile.${mavenSettings}.text =
          # xml
          ''
            <localRepository>''${env.XDG_CACHE_HOME}/${mavenRepo}</localRepository>
          '';
      })
    ];
  };
}
