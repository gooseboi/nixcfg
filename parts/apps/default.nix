{
  perSystem = {inputs', ...}: {
    apps = let
      inherit (inputs') deploy-rs;
    in {
      deploy = {
        type = "app";
        program = "${deploy-rs.packages.deploy-rs}/bin/deploy";
      };
    };
  };
}
