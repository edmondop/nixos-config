{ ... }: {
  # Attic binary cache running in k3s at https://cache.edmondo.lol.
  # Push paths with: attic push edmondo:nixpkgs <store-path>
  # Admin token: kubectl get secret attic-admin-token -n attic -o jsonpath='{.data.token}' | base64 -d
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.edmondo.lol/nixpkgs"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs:GCbjglRqXb2ZnADQknuG3YMdw7Tv8seDmjXRjI6eaeU="
    ];
  };
}
