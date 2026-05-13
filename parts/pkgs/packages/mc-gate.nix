{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.64.0";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-C+XKDFzsCgZpTS2fEpAKOExPyO9WOjdmHKvVpmNyDRo=";
  };

  subPackages = ["."];

  vendorHash = "sha256-7tDEtZyV4upFG/DGg1rbJbO8XV7MSAzFSs/3NmH4qI4=";

  meta.mainProgram = "gate";
})
