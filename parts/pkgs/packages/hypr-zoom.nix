{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "hypr-zoom";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "FShou";
    repo = "hypr-zoom";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-/5nC4iLcDJ+UODLpzuVitQTFdBZtz75ep73RSN37hHE=";
  };

  vendorHash = "sha256-BCx2hKi6U/MPJlwAmnM4/stiolhYkakpe4EN3e5r6L4=";

  meta.mainProgram = "hypr-zoom";
})
