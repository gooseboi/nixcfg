{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.62.2";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-WxR2VKlvDFOzIiDPuJLoBa5U9afMrYJ9QTDl0yTgSu4=";
  };

  subPackages = ["."];

  vendorHash = "sha256-f7SkECS80Lwkd0xSzHq+x05ZBjBYKXsA4rPidyIAYak=";

  meta.mainProgram = "gate";
})
