{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.15.4";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-0bCESzH77Ajdsp3LAc0GLHr1a3TrObdy1qBEksBuGkU=";
    };

    vendorHash = "sha256-q56mlGz6Qx+S3YRcYMI2a412Y0VeziUFvhQZOz3ifg4=";
  }
