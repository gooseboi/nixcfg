{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.chonkos.dev;

  python_rc = "python/pythonrc";
in {
  options.chonkos.dev = {
    enable = lib.mkEnableOption "enable dev tools";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # C/C++
        (lib.hiPrio gcc) # To stop conflict with clang for c++ bin
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
        python3Full
        uv

        # Java
        temurin-bin-21
        maven

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
        NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        NUGET_PACKAGES = "${config.xdg.cacheHome}/nuget";
        OPAMROOT = "${config.xdg.dataHome}/opam";
        PYTHONSTARTUP = "${config.xdg.configHome}/" + python_rc;
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        VAGRANT_HOME = "${config.xdg.dataHome}/vagrant";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dswing.aatext=true -Dawt.useSystemAAFontSettings=on";
      };
    };

    xdg.configFile = {
      ${python_rc}.text =
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
