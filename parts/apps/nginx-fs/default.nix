{
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    apps = {
      nginx-fs = {
        type = "app";
        program =
          lib.getExe
          <| pkgs.writeShellScriptBin "nginx-fs"
          # bash
          ''
            ${lib.getExe pkgs.nginx} -c ${./nginx.conf} -p "$PWD" -e stderr
          '';
      };
    };
  };
}
