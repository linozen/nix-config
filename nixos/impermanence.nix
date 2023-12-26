{
  lib,
  pkgs,
  ...
}: {
  # Reset both /home and /root
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount -o subvol=/ /dev/mapper/crypted /btrfs_tmp

    timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-dT%H:%M:%S")
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    if [[ -e /btrfs_tmp/home ]]; then
        mkdir -p /btrfs_tmp/old_homes
        mv /btrfs_tmp/home "/btrfs_tmp/old_homes/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done
    for i in $(find /btrfs_tmp/old_homes/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    btrfs subvolume create /btrfs_tmp/home
    umount /btrfs_tmp
  '';
  environment.systemPackages = let
    # Script for seeing changed files in /
    imp-diff-root = pkgs.writeShellScriptBin "imp-diff-root" ''
      _mount_drive=''${1:-"$(mount | grep '.* on / type btrfs' | awk '{ print $1}')"}
      _tmp_root=$(mktemp -d)
      sudo mount -o subvol=/ "$_mount_drive" "$_tmp_root" > /dev/null 2>&1

      set -euo pipefail

      OLD_TRANSID=$(sudo btrfs subvolume find-new $_tmp_root/root-blank 9999999)
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

      OLD_TRANSID=$(sudo btrfs subvolume find-new $_tmp_root/root-blank 9999999)
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
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
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
        # Source code
        "Source"

        # Exocortex
        "Exocortex"

        # Various folders in /home/lino
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"

        # Applications
        ## Git
        ".config/git"
        ## Firefox
        ".mozilla"
        ## Thunderbird
        {
          directory = ".thunderbird";
          mode = "0700";
        }
        ## Bitwarden
        ".config/Bitwarden"
        ## Signal
        {
          directory = ".config/Signal";
          mode = "0700";
        }
        ## Gnome Text Editor
        ".local/share/org.gnome.TextEditor"

        # home-manager
        ".local/state/home-manager"
        ".local/state/nix"

        # Gnome
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".cache/tracker3"

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
          directory = ".password-store";
          mode = "0700";
        }
      ];
      files = [
        # Gnome monitor configuration
        ".config/monitors.xml"
      ];
    };
  };
}
