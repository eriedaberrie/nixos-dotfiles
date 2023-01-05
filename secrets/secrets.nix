let
  errie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElnlmCCIRhwe7z/a4dpwNoPF65II8NsOHUWJIBdr2Rg";
  serverie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmM1h4bv1sp1SUqJAwSNj7kVsjv2ePHu6gq5U+ph2Y8";
  users = [ errie serverie ];

  nix-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ+Jfnb2G5ZNWGvD3svzGhrpqJcX8yEUJjlyraD764h0";
  groceries = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLm/4PyN12Xi/x8+2Y3dvGk2bnuOpETVkH3TK/ZqtuS";
  systems = [ nix-laptop groceries ];

  keys = users ++ systems;
in {
  "spotify.age".publicKeys = keys;
  "nix-tokens.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
  "email.json.age".publicKeys = keys;
  "porkbun-auth.age".publicKeys = keys;
}
