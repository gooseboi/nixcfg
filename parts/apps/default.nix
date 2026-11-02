{
  imports = [
    ./nginx-fs
  ];

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
        meta.description = "deploy to a remote system using deploy-rs";
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
        meta.description = "direct binding to the deploy-rs executable, if needed";
        program = deploy-rs-exe;
      };

      disko = {
        type = "app";
        meta.description = "run the disko executable";
        program = getExe disko.packages.disko;
      };

      htpasswd = {
        type = "app";
        meta.description = "run htpasswd to generate an htpasswd file";
        program = "${getExe' pkgs.apacheHttpd "htpasswd"}";
      };

      update_packages = {
        type = "app";
        meta.description = "update the packages inside this flake";
        program =
          pkgs.writeShellScriptBin "update_packages"
          # bash
          ''
            for p in mc-monitor mc-gate helium zen-browser; do
              ${getExe pkgs.nix-update} -F packages.x86_64-linux.$p
            done
          '';
      };
    };
  };
}
