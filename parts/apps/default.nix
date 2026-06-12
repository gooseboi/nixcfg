{
  perSystem = {
    inputs',
    lib,
    pkgs,
    ...
  }: {
    apps = let
      inherit
        (lib)
        getExe
        getExe'
        ;

      inherit
        (inputs')
        deploy-rs
        disko
        ;

      deploy-rs-exe = getExe deploy-rs.packages.deploy-rs;
    in {
      deploy = {
        type = "app";
        program =
          pkgs.writeShellScriptBin "deploy"
          # bash
          ''
            set -eu
            system=$1;

            echo "Deploying to $system..."
            ${deploy-rs-exe} --skip-checks .#$system
          '';
      };

      rawDeploy = {
        type = "app";
        program = deploy-rs-exe;
      };

      disko = {
        type = "app";
        program = getExe disko.packages.disko;
      };

      htpasswd = {
        type = "app";
        program = "${getExe' pkgs.apacheHttpd "htpasswd"}";
      };

      update_packages = {
        type = "app";
        program =
          pkgs.writeShellScriptBin "update_packages"
          # bash
          ''
            for p in t3code mc-monitor mc-gate helium zen-browser; do
              ${getExe pkgs.nix-update} -F packages.x86_64-linux.$p
            done
          '';
      };
    };
  };
}
