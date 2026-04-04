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
    sha256 = "sha256-25XroGctY1Oe/OPD/WRQMKKmNz4DtlFBjzOghzTq4tw=";
  };

  subPackages = ["."];

  vendorHash = "sha256-aPlAZHMJ8LYBuaaLw+ZT0V8rB+ktrf6rjuaztzZFYDQ=";

  meta.mainProgram = "gate";
})
