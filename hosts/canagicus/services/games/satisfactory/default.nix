{pkgs, ...}: let
  name = "satisfactory";

  mkBuilder = {
    stdenvNoCC,
    depotdownloader,
  }: {
    name,
    appId,
    depotId,
    manifestId,
    hash,
  }:
    stdenvNoCC.mkDerivation {
      name = "${name}-src";
      inherit appId depotId manifestId;
      builder = ./builder.sh;
      buildInputs = [
        depotdownloader
      ];

      outputHash = hash;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };

  builder = pkgs.callPackage mkBuilder {};
in {
  chonkos.unfree.allowed = [
    "steamcmd"
    "steam-unwrapped"
  ];

  networking.firewall = {
    allowedTCPPorts = [7777 8888];
    allowedUDPPorts = [7777];
  };

  flux.servers.satisfactory = {
    package = pkgs.mkSteamServer {
      inherit name;
      src = builder {
        inherit name;
        appId = "1690800";
        depotId = "1690802";
        manifestId = "6002578218905311874";

        hash = "sha256-Mn+HLd7hmlVubyYTKVothpEvdEZnDkz9swSAWE4TraY=";
      };

      startCmd = "FactoryServer.sh";

      hash = "sha256-zxCOq5Uakk0iFJgcD7pVTP+59bV+4LvU8ah9hFp6EIQ=";
    };
  };
}
