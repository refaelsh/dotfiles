{
  description = "Refael's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    # Intentionally no nixpkgs.follows for nixvim: upstream tests against its
    # own pin and warns if you override it. System packages are shared instead
    # via programs.nixvim.nixpkgs.useGlobalPackages in the nixvim module.
    nixvim.url = "github:nix-community/nixvim";

    wrappers.url = "github:Lassulus/wrappers";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ (inputs.import-tree ./modules) ];

      systems = [ "x86_64-linux" ];
    };
}
