{
  perSystem = {
    inputs',
    lib,
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
        program = getExe deploy-rs.packages.deploy-rs;
      };

      disko = {
        type = "app";
        program = getExe disko.packages.disko;
      };
    };
  };
}
