{
  security.sudo = {
    enable = true;

    execWheelOnly = true;

    extraConfig =
      /*
      sudo
      */
      ''
        Defaults lecture = never
        Defaults pwfeedback
      '';
  };
}
