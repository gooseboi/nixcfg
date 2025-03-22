{
  config,
  lib,
  ...
}: let
  cfg = config.chonkos.i18n;
in {
  options.chonkos.i18n = {
    enable = lib.mkEnableOption "enable i18n";
  };

  config = lib.mkIf cfg.enable {
    i18n = rec {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = defaultLocale;
        LC_IDENTIFICATION = defaultLocale;
        LC_MEASUREMENT = defaultLocale;
        LC_MONETARY = defaultLocale;
        LC_NAME = defaultLocale;
        LC_NUMERIC = defaultLocale;
        LC_PAPER = defaultLocale;
        LC_TELEPHONE = defaultLocale;
        LC_TIME = defaultLocale;
      };

      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "en_US/ISO-8859-1"

        "es_UY.UTF-8/UTF-8"
        "es_UY/ISO-8859-1"

        "ja_JP.EUC-JP/EUC-JP"
        "ja_JP.UTF-8/UTF-8"
      ];
    };
  };
}
