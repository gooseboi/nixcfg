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
            ${getExe deploy-rs.packages.deploy-rs} --skip-checks .#$system
          '';
      };

      rawDeploy = {
        type = "app";
        program = getExe deploy-rs.packages.deploy-rs;
      };

      disko = {
        type = "app";
        program = getExe disko.packages.disko;
      };
    };
  };
}
