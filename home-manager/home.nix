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
    inputs.agenix.homeManagerModules.default

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

      # VSCodium Extensions
      inputs.nix-vscode-extensions.overlays.default

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
  # Add packages for user
  home.packages = with pkgs; [
    cachix
    firefox
    thunderbird
    textsnatcher
    quickemu
    chromium
    bitwarden
    bitwarden-cli
    signal-desktop
    innernet
    dconf2nix
    gocryptfs
    btrfs-assistant
    tilix
    gnome.gnome-terminal
    gnome-solanum
    trezor-suite
    anki
    unstable.gnome.gnome-tweaks
    unstable.gnomeExtensions.espresso
    unstable.gnomeExtensions.clipboard-history
    unstable.gnomeExtensions.paperwm
    unstable.gnomeExtensions.appindicator
    unstable.trayscale
    unstable.teams-for-linux
    unstable.pdfannots2json
    unstable.rustdesk
    zotero
    pandoc
    pika-backup
    inkscape
    gthumb
    libreoffice
    pdfarranger
    # JavaScript / TypeScript
    nodejs
    corepack
    # Formatters
    alejandra
    nodePackages.prettier
    black
    # ruff
    element-desktop
    # Terminal app
    ripgrep
    fzf
    # Fonts
    inter
    (nerdfonts.override {fonts = ["Iosevka"];})
    papirus-icon-theme
    #
    trash-cli
    minder
    unstable.obsidian
    unstable.publii
    # NixVim from https://github.com/linozen/nvim-flake
    inputs.nixvim.packages."${system}".default
    # agenix
    inputs.agenix.packages."${system}".default
    # devenv
    unstable.devenv
  ];

  # Get secret from agenix
  age.secrets.sshConfig.file = ../secrets/sshConfig.age;
  # Since there is no shell interpolation here, it has to be done impurely
  home.file.".ssh/config".source = "/run/user/1000/agenix/sshConfig";

  home.file.".gitconfig".source = ./.gitconfig;
  home.file.".gitconfig.fsfe".source = ./.gitconfig.fsfe;

  home.file.".config/tilix/schemes/tokyonight.json".source = ./tilix-tokyonight.json;
  home.file.".config/pnpm/rc".text = ''
    store-dir=/home/lino/.local/share/pnpm/
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.yazi = {
    package = pkgs.unstable.yazi;
    enable = true;
    enableFishIntegration = true;
  };

  # xdg mime
  xdg.userDirs.music = "${config.home.homeDirectory}/Syno/audio/music";
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["org.gnome.Evince.desktop"];
      "text/html" = ["firefox.desktop"];
      "application/xhtml+xml" = ["firefox.desktop"];
      "application/x-extension-htm" = ["firefox.desktop"];
      "application/x-extension-html" = ["firefox.desktop"];
      "application/x-extension-shtml" = ["firefox.desktop"];
      "application/x-extension-xhtml" = ["firefox.desktop"];
      "application/x-extension-xht" = ["firefox.desktop"];
      "x-scheme-handler" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
    };
    defaultApplications = {
      # PDF
      "application/pdf" = ["org.gnome.Evince.desktop"];
      # (X)HTML
      "text/html" = ["firefox.desktop"];
      "application/x-extension-htm" = ["firefox.desktop"];
      "application/x-extension-html" = ["firefox.desktop"];
      "application/x-extension-shtml" = ["firefox.desktop"];
      "application/x-extension-xhtml" = ["firefox.desktop"];
      "application/x-extension-xht" = ["firefox.desktop"];
      "application/xhtml+xml" = ["firefox.desktop"];
      "x-scheme-handler" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
    };
  };

  # Enable programs with home-manager integration
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.password-store.enable = true;
  programs.direnv = {
    enable = true;
    # enableFishIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fenv source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" > /dev/null
      set -U DOCKER_HOST unix://$XDG_RUNTIME_DIR/docker.sock

      # TokyoNight Color Palette
      set -l foreground c0caf5
      set -l selection 283457
      set -l comment 565f89
      set -l red f7768e
      set -l orange ff9e64
      set -l yellow e0af68
      set -l green 9ece6a
      set -l purple 9d7cd8
      set -l cyan 7dcfff
      set -l pink bb9af7

      # Syntax Highlighting Colors
      set -g fish_color_normal $foreground
      set -g fish_color_command $cyan
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment

      # Completion Pager Colors
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment
      set -g fish_pager_color_selected_background --background=$selection

      # Aliases & Abbreviations
      abbr --add n nvim
      abbr --add c code
      abbr --add ts sudo tailscale

      # Functions
      function sync_music
          rsync -azvhP --delete "/home/lino/Syno/audio/music/" $HOME/Music/
      end
    '';
  };
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      battery = {
        charging_symbol = "⚡ ";
        discharging_symbol = "💀 ";
        display = [
          {
            style = "bold red";
            threshold = 15;
          }
        ];
        full_symbol = "🔋 ";
      };
      nodejs = {
        format = "via [node $version](bold green) ";
      };
      package = {
        disabled = true;
      };
      docker_context = {
        disabled = true;
      };
    };
  };

  # VSCode
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    mutableExtensionsDir = true;
    # Settings, extensions and keybindings are synced via GitHub
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };

  # Enable services with home-manager integration
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableFishIntegration = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
