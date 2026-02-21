{ config, pkgs, lib, ... }:

{
  # Self-hosted GitHub Actions runner for the testio repository.
  #
  # The runner replaces GitHub-hosted (ubuntu-latest) compute at zero cost.
  # Dagger pipelines run on this machine; the layer cache persists between
  # runs in /var/lib/github-runners/testio, making subsequent runs faster
  # than cold GitHub-hosted runners.
  #
  # Token setup (one-time):
  #
  #   1. Create a fine-grained PAT at:
  #        https://github.com/settings/personal-access-tokens
  #      Repository: edmondop/testio
  #      Permission: "Actions" → Read and Write
  #
  #   2. Write it to the token file (no trailing newline):
  #        sudo install -d -m 700 /var/secrets
  #        echo -n 'github_pat_...' | sudo tee /var/secrets/github-runner-testio-token
  #        sudo chmod 600 /var/secrets/github-runner-testio-token
  #
  #   3. Rebuild: sudo nixos-rebuild switch --flake ~/Development/nixos-config
  #
  # To scale later: move the token file and this config to a Hetzner VPS
  # running the same NixOS flake. No other changes needed.

  services.github-runners.testio = {
    enable = true;
    url = "https://github.com/edmondop/testio";
    tokenFile = "/var/secrets/github-runner-testio-token";
    name = "framework-13";
    replace = true;

    # Node.js: required to execute JS-based GitHub Actions
    #   (actions/checkout, actions/setup-go, dagger/dagger-for-github)
    # docker: Dagger needs the Docker CLI + daemon socket
    # git: used by actions/checkout and the Dagger pipeline
    # go: optional (actions/setup-go downloads its own, but having it
    #   in PATH avoids an extra download on every run)
    extraPackages = with pkgs; [
      nodejs
      docker
      git
      go
    ];
  };

  # The runner service runs as user "github-runner-testio".
  # Add it to the docker group so it can reach /var/run/docker.sock.
  users.groups.docker.members = [ "github-runner-testio" ];
}
