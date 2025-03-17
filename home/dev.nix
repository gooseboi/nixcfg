{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.dev;
in {
  options.chonkos.dev = {
    enable = lib.mkEnableOption "enable dev tools";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        clang
        clang-tools
        (lib.hiPrio gcc) # To stop conflict with clang for c++ bin
        gdb
        gf
        go
        libgcc
        odin
        python3Full
        zig

        cargo-expand
        cargo-fuzz
        (fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
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
        PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        VAGRANT_HOME = "${config.xdg.dataHome}/vagrant";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dswing.aatext=true -Dawt.useSystemAAFontSettings=on";
      };
    };
  };
}
