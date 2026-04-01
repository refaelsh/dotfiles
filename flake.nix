{
  description = "Refael's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    inherit (nixpkgs.lib) importTree;
    modules = importTree ./modules;
  in
  {
    # The host is now defined inside modules/hosts/refael-nixos.nix
    nixosConfigurations = modules.hosts or {};
  };
}
# {
#   description = "NixOS flake";
#
#   inputs = {
#     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
#     home-manager = {
#       url = "github:nix-community/home-manager";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#     nixvim = {
#       url = "github:nix-community/nixvim";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#     nixmobar.url = "git+https://codeberg.org/xmobar/xmobar.git/?dir=nix";
#     wrappers.url = "github:Lassulus/wrappers";
#   };
#
#   outputs =
#     { nixpkgs, ... }@inputs:
#     let
#       system = "x86_64-linux";
#     in
#     {
#       nixosConfigurations = {
#         myNixos = nixpkgs.lib.nixosSystem {
#           specialArgs = {
#             inherit inputs system;
#           };
#
#           modules = [
#             ./nixos/configuration.nix
#
#             inputs.nixvim.nixosModules.nixvim
#             ./nixvim
#
#             inputs.home-manager.nixosModules.home-manager
#             ./home-manager
#
#             {
#               environment.systemPackages = [
#                 # inputs.nixvim.packages.${system}.default
#                 # inputs.brave.packages.${system}.default
#                 # inputs.zen-browser.packages."${system}".default
#               ];
#             }
#             # === KBDD FIX STARTS HERE ===
#             {
#               nixpkgs.overlays = [
#                 (final: prev: {
#                   kbdd = prev.kbdd.overrideAttrs (old: {
#                     src = prev.fetchFromGitHub {
#                       owner = "qnikst";
#                       repo = "kbdd";
#                       rev = "b87e44afd5859157245eee22b11827605bfa09b9"; # upstream fix
#                       hash = "sha256-cbMcB6jgssfMUjemBOiE06zJK2TbzOWt1Rvt41V33Mo=";
#                     };
#                   });
#                 })
#               ];
#             }
#             # === KBDD FIX ENDS HERE ===
#           ];
#         };
#       };
#     };
# }
