_: _: super: {
  listFiles = dir:
    builtins.readDir dir
    |> super.attrsToList
    |> super.filter ({value, ...}: value != "directory")
    |> map ({name, ...}: dir + "/${name}");
}
