let
  keys = {
    chonk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUT9jJWba9PeWFpaEyypGMSk1F4hO5rYwtiruh9+uZ";
    anatidae = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg5PTKfTTXffGubprKXFg98mKhnpPTkdAXmcBNon/UU";
    printer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbJtMv8Tr6XODoIfoTq89ytU+9DTmU1X1h+T7vU0Fiy";
    swordsmachine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYB1t65P81JR8kY60KKiKqwtGzvhWbjIk9uDzMETlue";
  };
in
  keys
  // {
    all = builtins.attrValues keys;
  }
