{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.62.3";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-tOyXVqmexAWpC2s86aUUjmDp6V+qvP3ve8FrqdtexvU=";
  };

  subPackages = ["."];

  vendorHash = "sha256-AZa9u1f8MgnqW0QX6X+naRqukGTxI7WMNY4ZgJHoKyw=";

  meta.mainProgram = "gate";
})
