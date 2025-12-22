build:
	nh os build .

switch:
	nh os switch .

deploy system:
	nix run .#deploy {{system}}
