{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) hiPrio mkEnableOption mkIf;

  cfg = config.chonkos.dev;
in {
  options.chonkos.dev = {
    enable = mkEnableOption "enable dev tools";
  };

  config = mkIf cfg.enable {
    chonkos.unfree.allowed = [
      "antigravity"
      "claude-code"
      "cursor"
      "ngrok"
    ];

    environment.systemPackages = with pkgs; [
      # C/C++
      (hiPrio gcc) # To stop conflict with clang for c++ bin
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
      claude-code
      code-cursor-fhs
      gemini-cli
      opencode

      # Web Dev
      (
        dbeaver-bin.override {
          openjdk21 = temurin-bin-21;
        }
      )

      # Solo
      go
      lean4
      odin
      rocq-core
      zig

      # General
      cloc
      gh
      gnumake
      mermaid-cli
      ngrok
      tokei
      tracy-wayland
    ];

    home-manager.sharedModules = [
      (hmInputs: let
        hmConfig = hmInputs.config;

        pythonRc = "python/pythonrc";
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
          NPM_CONFIG_USERCONFIG = "${hmConfig.xdg.configHome}/npm/npmrc";
          NUGET_PACKAGES = "${hmConfig.xdg.cacheHome}/nuget";
          OPAMROOT = "${hmConfig.xdg.dataHome}/opam";
          PYTHONSTARTUP = "${hmConfig.xdg.configHome}/${pythonRc}";
          RUSTUP_HOME = "${hmConfig.xdg.dataHome}/rustup";
          VAGRANT_HOME = "${hmConfig.xdg.dataHome}/vagrant";
          _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${hmConfig.xdg.configHome}/java -Dswing.aatext=true -Dawt.useSystemAAFontSettings=on";
        };

        xdg.configFile = {
          ${mavenSettings}.text =
            /*
            xml
            */
            ''
              <localRepository>''${env.XDG_CACHE_HOME}/${mavenRepo}</localRepository>
            '';

          ${pythonRc}.text =
            /*
            python
            */
            ''
              def is_vanilla() -> bool:
                  import sys
                  return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys.argv[0]


              def setup_history():
                  import os
                  import atexit
                  import readline
                  from pathlib import Path

                  if state_home := os.environ.get('XDG_STATE_HOME'):
                      state_home = Path(state_home)
                  else:
                      state_home = Path.home() / '.local' / 'state'

                  history: Path = state_home / 'python_history'

                  history.touch(exist_ok=True)
                  readline.read_history_file(str(history))
                  atexit.register(readline.write_history_file, str(history))


              if is_vanilla():
                  setup_history()
            '';
        };
      })
    ];
  };
}
