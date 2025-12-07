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
    rev = "d3e6becd8681788c96a3f8943c722908d4356107";
    hash = "sha256-b7SBjLWLtmCwmiYzKCY7+sVU/S0r56bZdb4j6vcu4MQ=";
  };

  cargoHash = "sha256-6rZhBsqjPnDq+hx0vdu0vcKWUXyQEAgyPwExrWrRNhE=";

  meta = {
    mainProgram = "rss-proxy";
  };
}
