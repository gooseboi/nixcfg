{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.16.2";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-reCUIv7QLMEmBsUvA1GmIaS+HUEcV0TET9N4L4zg4fE=";
    };

    vendorHash = "sha256-qS6on5v+yR6JbfedB2QRfm7+hEEMPB0QdIldAiJQnAI=";
  }
