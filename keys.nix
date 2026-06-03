let
  keys = {
    chonk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUT9jJWba9PeWFpaEyypGMSk1F4hO5rYwtiruh9+uZ";
    builder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKV31uAvktfD733k7NUjI2fStCCf1VvWlIkWYdKORPwk";

    albifrons = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHm3UweR+NM95TBsYQ237BX9y1jvT6wSGgnUjaFkewlP";
    canagicus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYB1t65P81JR8kY60KKiKqwtGzvhWbjIk9uDzMETlue";
    erythropus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRcKG4QalQEsDCE96/mGfmYOZolrDcg3mN5KmupwEo8";
    indicus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg5PTKfTTXffGubprKXFg98mKhnpPTkdAXmcBNon/UU";
    printer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbJtMv8Tr6XODoIfoTq89ytU+9DTmU1X1h+T7vU0Fiy";
  };
in
  keys
  // {
    all = builtins.attrValues keys;
  }
