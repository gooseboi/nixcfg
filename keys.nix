let
  keys = {
    anatidae = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg5PTKfTTXffGubprKXFg98mKhnpPTkdAXmcBNon/UU";
    chonk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUT9jJWba9PeWFpaEyypGMSk1F4hO5rYwtiruh9+uZ";
    cowboy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm3UweR+NM95TBsYQ237BX9y1jvT6wSGgnUjaFkewlP";
    printer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbJtMv8Tr6XODoIfoTq89ytU+9DTmU1X1h+T7vU0Fiy";
    canagicus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYB1t65P81JR8kY60KKiKqwtGzvhWbjIk9uDzMETlue";
  };
in
  keys
  // {
    all = builtins.attrValues keys;
  }
