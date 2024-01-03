{pkgs, ...}: {
  # Enable Tailscale
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };
  networking.nameservers = ["100.100.100.100" "8.8.8.8" "149.112.112.112"];
  networking.search = ["wolf-map.ts.net"];

  # Enable Mullvad
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.unstable.mullvad-vpn;
  };

  # https://mullvad.net/en/help/split-tunneling-with-linux-advanced/
  environment.etc."nft/mullvadExcludeTraffic.rules".text = ''
    define EXCLUDED_IPS = {
        100.94.222.31,
        100.111.94.93,
        100.115.207.15
    }

    table inet excludeTraffic {
      chain excludeOutgoing {
        type route hook output priority -100; policy accept;
        ip daddr $EXCLUDED_IPS ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    }
  '';

  networking.firewall.extraCommands = "${pkgs.nftables}/bin/nft -f /etc/nft/mullvadExcludeTraffic.rules";
}
