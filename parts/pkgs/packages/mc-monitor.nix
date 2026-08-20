{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.17.0";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-LTkJ80vpiOKdP+dy8cG5cCecrjJHy4FL5eUbiv536Y4=";
    };

    vendorHash = "sha256-FBoyQ3w34FJDVzTPmnaQah1IAPcR5aCVThv1IQodFWk=";
  }
