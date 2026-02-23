inputs: self: super: let
  inherit
    (builtins)
    deepSeq
    genList
    isBool
    toJSON
    toString
    trace
    ;
in {
  traceVal = v: trace v v;

  traceValMsg = msg: val: let
    new =
      if isBool val
      then
        (
          if val
          then "true"
          else "false"
        )
      else (deepSeq val val |> toString);
  in (trace "${msg}: `${new}`" val);

  # https://kokada.dev/blog/generating-yaml-files-with-nix/
  convertToYAML = {
    runCommandLocal,
    yj,
  }: fname: value:
    runCommandLocal "${fname}" {
      nativeBuildInputs = [yj];
      json = toJSON value;
      passAsFile = ["json"];
    } ''
      mkdir -p $out
      yj -jy < "$jsonPath" > $out/${fname}
    '';

  iota = {
    base,
    n,
  }:
    genList (i: i + base) n;

  minsToSecs = mins: mins * 60;
  hoursToSecs = hours: self.minsToSecs (hours * 60);
  daysToHours = days: days * 24;
}
