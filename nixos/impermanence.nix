{
  lib,
  pkgs,
  ...
}: {
  # Reset both /home and /root
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    # Mount decrypted drive
    mkdir /btrfs_tmp
    mount -o subvol=/ /dev/mapper/crypted /btrfs_tmp

    # Move root subvolume(s) into /old_roots
    if [[ -e /btrfs_tmp/root ]]; then
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-dT%H:%M:%S")
        mkdir -p /btrfs_tmp/old_roots
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    # Delete root subvolumes older 30 days
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    # Delete /home if it exists
    if [[ -e /btrfs_tmp/home ]]; then
      btrfs subvolume delete /btrfs_tmp/home
    fi

    # Create new empty boot and home subvolumes
    btrfs subvolume create /btrfs_tmp/root
    btrfs subvolume create /btrfs_tmp/home

    # Create a blank subvolume if it does not exist
    if [[ ! -e /btrfs_tmp/blank ]]; then
      btrfs subvolume snapshot -r /btrfs_tmp/root /btrfs_tmp/blank
    fi

    # Create a snapshots volume if it does not exist
    if [[ ! -e /btrfs_tmp/snapshots ]]; then
      btrfs subvolume create /btrfs_tmp/snapshots
    fi

    umount /btrfs_tmp
  '';
  environment.systemPackages = let
    # Script for seeing changed files in /
    imp-diff-root = pkgs.writeShellScriptBin "imp-diff-root" ''
      _mount_drive=''${1:-"$(mount | grep '.* on / type btrfs' | awk '{ print $1}')"}
      _tmp_root=$(mktemp -d)
      sudo mount -o subvol=/ "$_mount_drive" "$_tmp_root" > /dev/null 2>&1

      set -euo pipefail

      OLD_TRANSID=$(sudo btrfs subvolume find-new $_tmp_root/blank 9999999)
      OLD_TRANSID=''${OLD_TRANSID#transid marker was }

      sudo btrfs subvolume find-new "$_tmp_root/root" "$OLD_TRANSID" | sed '$d' | cut -f17- -d' ' | sort | uniq |
      while read path; do
        path="/$path"
         if [ -L "$path" ]; then
            : # The path is a symbolic link, so is probably handled by NixOS already
          elif [ -d "$path" ]; then
            : # The path is a directory, ignore
          else
            echo "$path"
          fi
        done
        sudo umount "$_tmp_root"
        rm -rf "$_tmp_root"
    '';
    # Script for seeing changed files in /home
    imp-diff-home = pkgs.writeShellScriptBin "imp-diff-home" ''
      _mount_drive=''${1:-"$(mount | grep '.* on / type btrfs' | awk '{ print $1}')"}
      _tmp_root=$(mktemp -d)
      sudo mount -o subvol=/ "$_mount_drive" "$_tmp_root" > /dev/null 2>&1

      set -euo pipefail

      OLD_TRANSID=$(sudo btrfs subvolume find-new $_tmp_root/blank 9999999)
      OLD_TRANSID=''${OLD_TRANSID#transid marker was }

      sudo btrfs subvolume find-new "$_tmp_root/home" "$OLD_TRANSID" | sed '$d' | cut -f17- -d' ' | sort | uniq |
      while read path; do
        path="/$path"
         if [ -L "$path" ]; then
            : # The path is a symbolic link, so is probably handled by NixOS already
          elif [ -d "$path" ]; then
            : # The path is a directory, ignore
          else
            echo "$path"
          fi
        done
        sudo umount "$_tmp_root"
        rm -rf "$_tmp_root"
    '';
  in
    with pkgs; [
      imp-diff-root
      imp-diff-home
    ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/tailscale"
      "/var/lib/docker"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/innernet"
      "/etc/mullvad-vpn"
      {
        directory = "/etc/NetworkManager/system-connections";
        mode = "0700";
      }
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
    users.lino = {
      directories = [
        # Default
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        # Synology share
        "Syno"
        # Zotero
        "Zotero"
        ".zotero"
        # pnpm
        ".local/share/pnpm"
        # pypoetry
        ".cache/pypoetry"
        # Firefox
        ".mozilla"
        # Thunderbird
        {
          directory = ".thunderbird";
          mode = "0700";
        }
        # home-manager, cachix, direnv
        ".local/state/home-manager"
        ".local/state/nix"
        ".local/share/nix"
        ".local/share/direnv"
        # Gnome Text Editor
        ".local/share/org.gnome.TextEditor"
        ".local/share/backgrounds"
        # Z
        ".local/share/z"
        # Neovim
        ".local/share/nvim"
        # Anki
        ".local/share/Anki2"
        ## Python / Poerty
        ".local/share/virtualenv"
        ## Evolution (only for CalDav and CardDav)
        ".local/share/evolution"
        ".config/evolution"
        ## Obsidian
        ".config/obsidian"
        ## Element
        ".config/Element"
        ## VSCode
        ".vscode"
        ".config/Code"
        ## MS Teams
        ".config/teams-for-linux"
        # Bitwarden
        ".config/Bitwarden"
        # Bitwarden
        ".config/pika-backup"
        # Signal
        {
          directory = ".config/Signal";
          mode = "0700";
        }
        # Gnome
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".cache/tracker3"
        # Podman
        ".local/share/containers"
        # YubiKeys
        {
          directory = ".yubico";
          mode = "0700";
        }
        # SSH, GnuPG and pass
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/password-store";
          mode = "0700";
        }
      ];
      files = [
        # Gnome monitor configuration
        ".config/monitors.xml"
        # Fish history
        ".local/share/fish/fish_history"
      ];
    };
  };
}
