{
  fetchFromGitHub,
  fetchPnpmDeps,
  git,
  lib,
  jq,
  nodejs_22,
  pnpmConfigHook,
  pnpm_10,
  stdenvNoCC,
  ...
}: let
  pnpm = pnpm_10.override {nodejs = nodejs_22;};
in
  stdenvNoCC.mkDerivation rec {
    pname = "ferdium-recipes";
    version = "1.0.1";

    src = fetchFromGitHub {
      owner = "ferdium";
      repo = "ferdium-recipes";
      rev = "8566e82ef16bf503b921712aee0d5f67a0827a19";
      hash = "sha256-b7mq76xWPRzD835LQwJeBeIZlmen8j0RW9OSjOhBcIQ=";
    };

    nativeBuildInputs = [
      git
      nodejs_22
      pnpm
      pnpmConfigHook
    ];

    # We do this because there is no way (that I know of) to tell pnpm to
    # ignore the engines field and so we just take it out manually.
    postPatch = ''
      cat package.json | ${lib.getExe jq} 'del(.engines) | del(."engine-strict")' > package.json.tmp
      mv package.json.tmp package.json
    '';

    pnpmDeps = fetchPnpmDeps {
      inherit pname version src pnpm;

      hash = "sha256-j0QM/PQ//Ph16DSJtjijLTJXQr3b4kDKB7ANY/kY7C0=";
      fetcherVersion = 3;
    };

    buildPhase = ''
      runHook preBuild

      pnpm package

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/ferdium-recipes/recipes
      cp -r recipes/* $out/share/ferdium-recipes/recipes/

      runHook postInstall
    '';
  }
