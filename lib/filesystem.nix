_: self: super: let
  inherit (super) attrsToList filter hasSuffix;
in {
  listFiles = dir:
    builtins.readDir dir
    |> attrsToList
    |> filter ({value, ...}: value != "directory")
    |> map ({name, ...}: dir + "/${name}");

  listNix = dir:
    self.listFiles dir
    |> filter (hasSuffix ".nix");

  listNixWithDirs = dir:
    (self.listNix dir)
    ++ (builtins.readDir dir
      |> attrsToList
      |> filter ({value, ...}: value == "directory")
      |> filter ({name, ...}: builtins.pathExists (dir + "/${name}/default.nix"))
      |> map ({name, ...}: dir + "/${name}"));
}
