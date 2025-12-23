{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.16.0";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-6koSgAPSeN5WnBhWAdO/s7AhJOG3vELFwycnNuvoRmo=";
    };

    vendorHash = "sha256-WecUZMX85mWc+qv+Mf/ey3dcm3GlwbdA5eC3utF8zEI=";
  }
