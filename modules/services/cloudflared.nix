{ config, pkgs, ... }:

{
  # Create /etc/cloudflared with restricted permissions.
  # Drop a file at /etc/cloudflared/env (chmod 600, owned by root) with:
  #   TUNNEL_TOKEN=<your-token>
  systemd.tmpfiles.rules = [
    "d /etc/cloudflared 0700 root root -"
  ];

  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel";
    after = [ "network-online.target" "k3s.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${TUNNEL_TOKEN}";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 10;
      EnvironmentFile = "/etc/cloudflared/env";
    };
  };
}
