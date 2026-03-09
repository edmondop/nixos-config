{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "podman";
    containers.registry = {
      image = "registry:2";
      ports = [ "5000:5000" ];
      volumes = [ "/var/lib/registry:/var/lib/registry" ];
    };
  };

  # Tell k3s to use the local registry without TLS
  environment.etc."rancher/k3s/registries.yaml".text = ''
    mirrors:
      "localhost:5000":
        endpoint:
          - "http://localhost:5000"
  '';
}
