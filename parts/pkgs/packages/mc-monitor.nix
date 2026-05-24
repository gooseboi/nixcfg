{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.16.5";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-zLaXhEbDtE0NVH70aVb6SWY0/ROEV6aE28Dlb1HseeA=";
    };

    vendorHash = "sha256-6E/hQu65Cj/vPG+SDHMwyHQOAlcNrJ6ZqflzYI71RXU=";
  }
