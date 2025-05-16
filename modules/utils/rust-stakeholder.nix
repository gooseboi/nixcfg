{
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "rust-stakeholder";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "giacomo-b";
    repo = "rust-stakeholder";
    rev = "52f64ad3d61c439b500bc893cbc96050e7a2c85a";
    hash = "sha256-qMekgaGMe+PquhBOS9itWLEgqZluO2H794HH9nAt6Mg=";
  };

  cargoHash = "sha256-p3E4Yk7sDI6u5dv8bxRyE/Hj3kOIU54EYodX4PG23Dw=";
}
