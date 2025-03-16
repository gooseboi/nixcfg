let
  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuUT9jJWba9PeWFpaEyypGMSk1F4hO5rYwtiruh9+uZ";
  secrets = ["chonk.hashedPassword.age"];
in {
  "modules/secrets/chonk.hashedPassword.age".publicKeys = [publicKey];
}
