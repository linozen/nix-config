# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.agenix.nixosModules.default

    # Use home-manager as a NixOS module
    inputs.home-manager.nixosModules.home-manager

    # Or modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # Import disk config
    ./disko-config.nix
    # Impermanene config
    ./impermanence.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  networking.hostName = "leto";
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  services.resolved.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;
  networking.nameservers = ["100.100.100.100" "9.9.9.9" "149.112.112.112"];
  networking.search = ["wolf-map.ts.net"];

  # Mount Synology NFS shares
  fileSystems."/home/lino/Syno/video" = {
    device = "100.94.222.31:/volume1/video";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-gvfs-hide" "user" "users"];
  };
  fileSystems."/home/lino/Syno/audio" = {
    device = "100.94.222.31:/volume1/audio";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-gvfs-hide" "user" "users"];
  };
  fileSystems."/home/lino/Syno/archive" = {
    device = "100.94.222.31:/volume1/archive";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-gvfs-hide" "user" "users"];
  };
  fileSystems."/home/lino/Syno/pictures" = {
    device = "100.94.222.31:/volume1/pictures";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-gvfs-hide" "user" "users"];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Yubikey
  services.udev.packages = [pkgs.yubikey-personalization pkgs.android-udev-rules];
  services.pcscd.enable = true;
  security.pam.yubico = {
    enable = true;
    debug = true;
    mode = "challenge-response";
  };
  services.yubikey-agent = {
    enable = true;
  };

  services.btrbk.instances."btrbk" = {
    onCalendar = "*:0/10";
    settings = {
      snapshot_preserve_min = "2d";
      volume."/" = {
        subvolume = "/home";
        snapshot_dir = "/snapshots";
      };
    };
  };
  age.identityPaths = [/persist/home/lino/.ssh/id_ed25519];
  age.secrets.passwordHash.file = ../secrets/passwordHash.age;

  users.mutableUsers = false;
  users.users = {
    lino = {
      hashedPasswordFile = config.age.secrets.passwordHash.path;
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      # Import your home-manager configuration
      lino = import ../home-manager/home.nix;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
