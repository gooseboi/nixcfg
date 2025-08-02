{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) hiPrio mkEnableOption mkIf;

  cfg = config.chonkos.dev;

  pythonRc = "python/pythonrc";
  mavenSettings = "maven/settings.xml";
  mavenRepo = "maven/repository";
in {
  options.chonkos.dev = {
    enable = mkEnableOption "enable dev tools";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # C/C++
        (hiPrio gcc) # To stop conflict with clang for c++ bin
        clang
        clang-tools
        cmake
        gdb
        gf
        libgcc
        meson

        # Javascript
        bun
        deno
        nodejs
        pnpm

        # Python
        python3.pkgs.pip
        python3Full
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
        cargo-show-asm
        cargo-expand
        cargo-fuzz
        cargo-nextest
        (fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])

        # Haskell
        (
          ghc.withPackages
          (p: [
            p.stack
            p.cabal-install
          ])
        )

        # Reto
        code-cursor-fhs
        (
          dbeaver-bin.override {
            openjdk21 = temurin-bin-21;
          }
        )
        php81
        php81Packages.composer
        postman

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
        tokei
        tracy-wayland
      ];

      sessionVariables = {
        CABAL_CONFIG = "${config.xdg.configHome}/cabal/config";
        CABAL_DIR = "${config.xdg.dataHome}/cabal";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
        ELAN_HOME = "${config.xdg.dataHome}/elan";
        GEM_PATH = "${config.xdg.dataHome}/ruby/gems";
        GEM_SPEC_CACHE = "${config.xdg.dataHome}/ruby/specs";
        GHCUP_USE_XDG_DIRS = "true";
        GOPATH = "${config.xdg.dataHome}/go";
        JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
        MAVEN_ARGS = "--settings ${config.xdg.configHome}/${mavenSettings}";
        MAVEN_OPTS = "-Dmaven.repo.local=${config.xdg.dataHome}/${mavenRepo}";
        NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        NUGET_PACKAGES = "${config.xdg.cacheHome}/nuget";
        OPAMROOT = "${config.xdg.dataHome}/opam";
        PYTHONSTARTUP = "${config.xdg.configHome}/${pythonRc}";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        VAGRANT_HOME = "${config.xdg.dataHome}/vagrant";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dswing.aatext=true -Dawt.useSystemAAFontSettings=on";
      };
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
  };
}
