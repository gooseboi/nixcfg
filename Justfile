build:
	nh os build .

switch:
	nh os switch .

switch_remote system:
	nh os switch --target-host {{system}} --build-host {{system}} .

update:
	nix flake update

deploy system:
	nix run .#deploy {{system}}

check:
	nix flake check

check_impure:
	NIXPKGS_ALLOW_UNFREE=1 nix flake check --impure
