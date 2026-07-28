{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.16.11";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-GyAHQD00x43tZUjHiY3oYmCGCimeB8GgLmhyyyZN3Lg=";
    };

    vendorHash = "sha256-b4CkFBGPiPqdP59sJy5zg/FP9U92JZWyXvdOqvhjxcQ=";
  }
