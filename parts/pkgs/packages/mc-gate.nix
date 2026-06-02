{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-FvwwVx2b4TB0gVfeWhygAJABea/u7dsgz1iHa0U+E5g=";
  };

  subPackages = ["."];

  vendorHash = "sha256-487PKbLfeiB2IRWGvclp/M76RprVYcaE2v8FCqlPX9I=";

  meta.mainProgram = "gate";
})
