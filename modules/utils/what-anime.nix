{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule {
  pname = "what-anime-cli";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "irevenko";
    repo = "what-anime-cli";
    rev = "5f212cab4cefd4109ef342797a2c942cc850e3e3";
    sha256 = "sha256-GFhKu4fbN4uWSTbg3N1XP9e8fADm+26vwmavvARKxdk=";
  };

  vendorHash = "sha256-CNhdXIL5MK+942c9BSWezqq0NmcgD/QuK26pqZeius0=";
}
