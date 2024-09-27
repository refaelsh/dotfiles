{
  # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
  home-manager.users.refaelsh = import ./home.nix;
  # imports = [ ./home.nix ];
}
