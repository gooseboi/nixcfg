{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.16.6";
in
  buildGoModule {
    pname = "mc-monitor";
    inherit version;

    src = fetchFromGitHub {
      owner = "itzg";
      repo = "mc-monitor";
      tag = version;
      sha256 = "sha256-BTwtXPJITzdKXZrOLeTndgHzmkiMRkhZA6FiDAMAaHw=";
    };

    vendorHash = "sha256-Zc1KpKFQq4Q+eKj3V1d6uC4RQm7R4fd1XKqAwuqsEWk=";
  }
