{
  modulesPath,
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
    ./koios-disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_scsi" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "koios";

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  # SSL
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@sehn.dev";
  };
  services.nginx = {
    enable = true;
    virtualHosts."uptime.sehn.dev" = {
      enableACME = true;
      onlySSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4000";
      };
    };
  };

  # Configure Uptime Kuma
  services.uptime-kuma = {
    enable = true;
    appriseSupport = true;
    settings = {
      PORT = "4000";
      NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg8ma28mF3YlbetPZ+eMFMxXbxn8prVYp+wriMcjyGl lino@leto"
  ];

  system.stateVersion = "23.11";
}
