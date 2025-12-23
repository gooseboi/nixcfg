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

  vendorHash = "sha256-WecUZMX85mWc+qv+Mf/ey3dcm3GlwbdA5eC3utF8zEI=";

  meta.mainProgram = "gate";
})
