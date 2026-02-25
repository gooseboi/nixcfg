inputs: self: super: let
  inherit
    (builtins)
    deepSeq
    genList
    isBool
    isList
    isString
    replaceStrings
    toJSON
    toString
    trace
    typeOf
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

  replaceStringsWith = patterns: to: string:
    assert super.assertMsg (isList patterns)
    "replaceStringsWith: first argument is ${typeOf patterns}, but should be list";
    assert super.assertMsg (isString to)
    "replaceStringsWith: second argument is ${typeOf to}, but should be string";
    assert super.assertMsg (isString string)
    "replaceStringsWith: third argument is ${typeOf string}, but should be string";
      replaceStrings patterns (genList (_: to) <| builtins.length patterns) string;
}
