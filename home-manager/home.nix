# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./dconf.nix
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "lino";
    homeDirectory = "/home/lino";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    firefox
    thunderbird
    bitwarden
    bitwarden-cli
    signal-desktop
    dconf2nix
    gocryptfs
    gnome.gnome-tweaks
    # JavaScript / TypeScript
    corepack
    # Formatters
    alejandra
    ripgrep
    # Fonts
    inter
    (nerdfonts.override {fonts = ["Iosevka"];})
    # NixVim from https://github.com/linozen/nvim-flake
    inputs.nixvim.packages."${system}".default
    # agenix
    inputs.agenix.packages."${system}".default
  ];

  
  home.file.".ssh/config".source = ./ssh.conf;
  home.file.".gitconfig".source = ./.gitconfig;

  programs.bash = {
    enable = true;
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Enable programs with home-manager integration
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.password-store.enable = true;

  # Enable services with home-manager integration
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
