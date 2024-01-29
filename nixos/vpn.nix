{pkgs, ...}: {
  # Enable Tailscale
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };
  networking.nameservers = ["100.100.100.100" "194.242.2.2" "2a07:e340::2"];
  networking.search = ["wolf-map.ts.net"];

  environment.systemPackages = with pkgs; [
    nftables
    iptables
  ];

  # Based on https://github.com/tailscale/tailscale/issues/4432#issuecomment-1112819111
  networking.firewall.checkReversePath = "loose";

  # No IPv6 yet when using Mullvad Exit node
  # https://github.com/tailscale/tailscale/issues/9511
}
