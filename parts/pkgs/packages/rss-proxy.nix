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
    rev = "b3a610bb0190bbc41bca31975bbd4a3ab3d20697";
    hash = "sha256-jQHxPc/vBQFWryFMEFiii305z1LzAtIOR4OYto9/PmM=";
  };

  cargoHash = "sha256-6rZhBsqjPnDq+hx0vdu0vcKWUXyQEAgyPwExrWrRNhE=";

  meta = {
    mainProgram = "rss-proxy";
  };
}
