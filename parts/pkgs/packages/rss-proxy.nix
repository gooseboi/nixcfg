{
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "rss-proxy";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "gooseboi";
    repo = "rss-proxy";
    rev = "bd123e546b715fd8b9e0d2146a88b1c000cc4ac9";
    hash = "sha256-S2aeLdVtunGJgcsw2r28PHa2Dm6WnRWa8bZ/cdMZDzE=";
  };

  cargoHash = "sha256-cgt2d7Ik8OZMpxUGnH3UcANgcInIxb9cJIt5Qzhcfqk=";

  meta = {
    mainProgram = "rss-proxy";
  };
}
