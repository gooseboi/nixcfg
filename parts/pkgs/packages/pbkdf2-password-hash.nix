{
  rustPlatform,
  fetchFromSourcehut,
  ...
}: let
  name =  "pbkdf2-password-hash";
  rev = "9dfc0fd353bda7a6ccffbf681efc9a26dcc29a90";
in
  rustPlatform.buildRustPackage {
    pname = name;
    version = builtins.substring 0 8 rev;

    src = fetchFromSourcehut {
      owner = "~laalsaas";
      repo = "pbkdf2-password-hash";
      inherit rev;
      hash = "sha256-eBRArvcGU+63VT8Fx6iIi5RP9F55860CwF4Q3YwT8WU=";
    };

    cargoHash = "sha256-n3VxmR+bjFN/mEJ/SuDYQJWcndR7QFmcVJdZhSHDdmQ=";

    meta = {
      mainProgram = "pbkdf2-hash-password";
    };
  }
