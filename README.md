# My NixOS configuration

The instructions here are only valid for this personal configuration which you
probably don't want to use because:

1. My Nix-fu sucks.
2. You probably don't want half the stuff that I deem necessary for my
   computing experience.
3. This is very much work-in-progress.

## Features

- automated partitioning based on [disko](https://github.com/nix-community/disko), see [config](./nixos/disko-config.nix)
- Self-erasing `/boot` and `/home` partitions using [impermanence](https://github.com/nix-community/impermanence). see [config](./nixos/impermanence.nix)
- Secret management based on [agenix](https://github.com/ryantm/agenix)
- Custom Neovim config based on [NixVim](https://github.com/nix-community/nixvim) that lives in its [own flake](https://github.com/linozen/nvim-flake) for easy installation in other systems (e.g. WSL on a Windows machine).

## Inspiration

- Misterio77's great [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) which this repo is based on.
