{pkgs, ...}: {
  environment.etc."/brave/policies/managed/GroupPolicy.json".source = ./policies.json;

  home-manager.sharedModules = [
    {
      programs.chromium = {
        enable = true;
        package = pkgs.brave;
        commandLineArgs = ["--password-store=basic"];
      };
    }
  ];
}
