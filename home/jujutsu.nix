{
  pkgs,
  config,
  lib,
  ...
}: {
  options.chonkos.jujutsu = {
    enable = lib.mkEnableOption "enable jujutsu";
  };

  config.programs.jujutsu = lib.mkIf config.chonkos.jujutsu.enable {
    enable = true;
    settings = {
      ui.paginate = "never";
      user = {
        name = "Guzman Zugnoni";
        email = "gooseiman@protonmail.com";
      };
    };
  };
}
