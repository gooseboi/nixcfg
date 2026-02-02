{
  perSystem = {
    inputs',
    lib,
    pkgs,
    ...
  }: {
    apps = let
      inherit (lib) getExe;

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
          /*
          bash
          */
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
        program = "${pkgs.apacheHttpd}/bin/htpasswd";
      };
    };
  };
}
