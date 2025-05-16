{
  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.displayManager.autoLogin.user = "kodi";
  services.xserver.displayManager.lightdm.greeter.enable = false;

  # Define a user account
  users.extraUsers.kodi.isNormalUser = true;
}
