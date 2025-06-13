inputs: self: super: {
  traceVal = v: builtins.trace v v;

  # https://kokada.dev/blog/generating-yaml-files-with-nix/
  convertToYAML = {
    runCommandLocal,
    yj,
  }: fname: value:
    runCommandLocal "gen-${fname}" {
      nativeBuildInputs = [yj];
      json = builtins.toJSON value;
      passAsFile = ["json"];
    } ''
      mkdir -p $out
      yj -jy < "$jsonPath" > $out/${fname}
    '';
}
