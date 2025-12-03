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
    rev = "c72dc2ac12a3793e58743898c200103035a91627";
    hash = "sha256-y67Id/TPRZFA80vW8Yc5jGU4iEWs+JVbt2+f5JhgRVU=";
  };

  cargoHash = "sha256-6rZhBsqjPnDq+hx0vdu0vcKWUXyQEAgyPwExrWrRNhE=";

  meta = {
    mainProgram = "rss-proxy";
  };
}
