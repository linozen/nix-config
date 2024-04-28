{pkgs, ...}: {
  services.resolved = {
    enable = true;
  };

  # services.nextdns.arguments = ["-profile" "dce164"];
  # services.nextdns.enable = true;

  # Enable Tailscale
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };
  networking.nameservers = [
    "100.100.100.100"
    "45.90.28.0#dce164.dns.nextdns.io"
    "2a07:a8c0::#dce164.dns.nextdns.io"
    "45.90.30.0#dce164.dns.nextdns.io"
    "2a07:a8c1::#dce164.dns.nextdns.io"
  ];
  networking.search = ["wolf-map.ts.net" "tuna-atlas.ts.net"];
  environment.systemPackages = with pkgs; [
    nftables
    iptables
  ];

  # Based on https://github.com/tailscale/tailscale/issues/4432#issuecomment-1112819111
  networking.firewall.checkReversePath = "loose";

  # No IPv6 yet when using Mullvad Exit node
  # https://github.com/tailscale/tailscale/issues/9511
}
