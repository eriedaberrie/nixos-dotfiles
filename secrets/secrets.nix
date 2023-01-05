let
  errie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElnlmCCIRhwe7z/a4dpwNoPF65II8NsOHUWJIBdr2Rg";
  users = [ errie ];

  nix-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ+Jfnb2G5ZNWGvD3svzGhrpqJcX8yEUJjlyraD764h0";
  systems = [ nix-laptop ];

  keys = users ++ systems;
in {
  "spotify.age".publicKeys = keys;
  "nix-tokens.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
}
