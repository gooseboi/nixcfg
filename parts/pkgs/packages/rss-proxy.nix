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
    rev = "9dcd15a682cc041345cada72731b4d66c5923bd8";
    hash = "sha256-HkJSKZSjeK0nB+l9wkGFJ87CaVCnFrbijonLEhAd/hw=";
  };

  cargoHash = "sha256-cgt2d7Ik8OZMpxUGnH3UcANgcInIxb9cJIt5Qzhcfqk=";

  meta = {
    mainProgram = "rss-proxy";
  };
}
