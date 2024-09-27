{
  # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
  home-manager.users.refaelsh = import ./home-manager/home.nix;
  imports = [ ./home.nix ];
}
