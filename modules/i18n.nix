{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.chonkos.i18n;
in {
  options.chonkos.i18n = {
    enable = mkEnableOption "enable i18n";
    defaultLocale = mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "the default locale. must be utf-8";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        # If it's not UTF-8, fuck you
        assertion = lib.strings.hasSuffix "UTF-8" cfg.defaultLocale;
        message = "The default locale must be UTF-8, was `${cfg.defaultLocale}`";
      }
    ];

    i18n = let
      inherit (cfg) defaultLocale;
    in {
      inherit defaultLocale;

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

      supportedLocales =
        [
          "en_US.UTF-8/UTF-8"
          "en_US/ISO-8859-1"

          "es_UY.UTF-8/UTF-8"
          "es_UY/ISO-8859-1"

          "ja_JP.EUC-JP/EUC-JP"
          "ja_JP.UTF-8/UTF-8"
        ]
        ++ [(defaultLocale + "/UTF-8")];
    };
  };
}
