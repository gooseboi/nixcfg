{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.62.0";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-gDRw/YQtIpYiX3uKjvmttbVkohj2k5f+pvv+xYyY3S8=";
  };

  subPackages = ["."];

  vendorHash = "sha256-4LJwb4ZXs+CUcxhvRveJy+xu7/UEjxIEwLV5Z5gBbT4=";

  meta.mainProgram = "gate";
})
