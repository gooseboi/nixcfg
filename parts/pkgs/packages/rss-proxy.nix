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
    rev = "9609bb3112055dc7d75a470bd6910af1379c1521";
    hash = "sha256-l5JCtBEJNgqBZdQyEp165KgHsJcFjnZiDy0ZJ0ACMxM=";
  };

  cargoHash = "sha256-6rZhBsqjPnDq+hx0vdu0vcKWUXyQEAgyPwExrWrRNhE=";

  meta = {
    mainProgram = "rss-proxy";
  };
}
