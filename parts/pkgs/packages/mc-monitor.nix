{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.16.1";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-/94+Z9FTFOzQHynHiJuaGFiidkOxmM0g/FIpHn+xvJM=";
    };

    vendorHash = "sha256-qq7rIpvGRi3AMnBbi8uAhiPcfSF4McIuqozdtxB5CeQ=";
  }
