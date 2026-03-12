{ config, pkgs, ... }:

{
  # cloudflared runs inside k3s as a Deployment (manifests-seed/cloudflared/).
  # The host-level systemd service is intentionally absent — k3s CoreDNS
  # is required to resolve *.svc.cluster.local ingress targets.
}
