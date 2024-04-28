let
  # Track progress on yubikeys for agenix
  yubi-wallet = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDqf8875YKiWOmppVNyKIJLFICCjMsUFVK9SnKwyupjSe/8ni0WgzYtT5bU4rJ9EjHiX5VEdJFU5QqkceTSO0aM=";
  yubi-home = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBODwLZY9WHSyvpG1C0lns1e3xZQpIL6Gj1ZZsA61BCjK3agBqHd7pPPZOpCGt0JBNlvc0ZULp93ARZQSPF3rNgs=";
  yubis = [yubi-wallet yubi-home];

  lino = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg8ma28mF3YlbetPZ+eMFMxXbxn8prVYp+wriMcjyGl";
in {
  "passwordHash.age".publicKeys = [lino];
  "sshConfig.age".publicKeys = [lino];
}
