{
  fetchFromGitHub,
  fetchPnpmDeps,
  jq,
  lib,
  makeWrapper,
  nodejs_22,
  openssl,
  pnpmConfigHook,
  pnpm_10,
  sqlite,
  stdenvNoCC,
  buildNpmPackage,
  callPackage,
  sqliteSupport ? false,
  ...
}: let
  ferdium-recipes = callPackage ./ferdium-recipes.nix {};

  # Bcrypt requires a native build to work and must therefore be built
  # separately. This is taken from the nixpkgs definition for the linkwarden
  # package, as they have the same problem.
  bcrypt = buildNpmPackage rec {
    pname = "bcrypt";
    version = "5.1.1";

    src = fetchFromGitHub {
      owner = "kelektiv";
      repo = "node.bcrypt.js";
      tag = "v${version}";
      hash = "sha256-mgfYEgvgC5JwgUhU8Kn/f1D7n9ljnIODkKotEcxQnDQ=";
    };

    npmDepsHash = "sha256-CPXZ/yLEjTBIyTPVrgCvb+UGZJ6yRZUJOvBSZpLSABY=";

    npmBuildScript = "install";

    postInstall = ''
      cp -r lib $out/lib/node_modules/bcrypt/
    '';
  };

  pnpm = pnpm_10.override {nodejs = nodejs_22;};
in
  stdenvNoCC.mkDerivation rec {
    pname = "ferdium-server";
    version = "2.0.11";

    src = fetchFromGitHub {
      owner = "ferdium";
      repo = "ferdium-server";
      tag = "v${version}";
      hash = "sha256-PtcQxK7kLPFFG+qLaX8lL6zyigcS9gUXWphTyRgpXNA=";
    };

    nativeBuildInputs = [
      nodejs_22
      pnpm
      pnpmConfigHook
      makeWrapper
    ];

    buildInputs =
      [
        openssl
      ]
      ++ lib.optional sqliteSupport sqlite;

    # We do this because there is no way (that I know of) to tell pnpm to
    # ignore the engines field and so we just take it out manually.
    postPatch = ''
      ${jq}/bin/jq 'del(.engines) | del(."engine-strict")' package.json > package.json.tmp
      mv package.json.tmp package.json
    '';

    pnpmDeps = fetchPnpmDeps {
      inherit pname version src pnpm;

      hash = "sha256-USEE09aQmyBG8e7+jAdXQGxnEY9lta6HKrzs6UYPhBw=";
      fetcherVersion = 3;
    };

    buildPhase = ''
      runHook preBuild

      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/ferdium-server

      cp -r node_modules $out/lib/ferdium-server/
      rm -rf $out/lib/ferdium-server/node_modules/bcrypt
      ln -s ${bcrypt}/lib/node_modules/bcrypt $out/lib/ferdium-server/node_modules/

      cp -r build $out/lib/ferdium-server/
      cp -r resources $out/lib/ferdium-server/
      cp -r public $out/lib/ferdium-server/
      cp -r database $out/lib/ferdium-server/
      cp -r scripts $out/lib/ferdium-server/
      ln -s ${ferdium-recipes}/share/ferdium-recipes/recipes $out/lib/ferdium-server/recipes

      mkdir -p $out/bin
      makeWrapper ${nodejs_22}/bin/node $out/bin/ferdium-server \
        --add-flags "$out/lib/ferdium-server/build/server.js" \
        --set NODE_ENV "production" \
        --prefix PATH : ${
        lib.makeBinPath (
          [nodejs_22]
          ++ lib.optional
          sqliteSupport
          sqlite
        )
      }

      cat > $out/bin/ferdium-server-migrate <<EOF
      #!/usr/bin/env bash
      cd $out/lib/ferdium-server
      exec ${nodejs_22}/bin/node ace migration:run --force "\$@"
      EOF
      chmod +x $out/bin/ferdium-server-migrate

      runHook postInstall
    '';

    meta = with lib; {
      description = "Server for Ferdium that you can re-use to run your own";
      homepage = "https://github.com/ferdium/ferdium-server";
      license = licenses.mit;
      platforms = ["aarch64-linux" "x86_64-linux"];
      mainProgram = "ferdium-server";
    };
  }
