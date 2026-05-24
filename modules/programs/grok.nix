# e.g. modules/packages/ai-tools.nix  or inside your host module
{
  config,
  pkgs,
  llm-agents,
  ...
}:
{
  # Binary cache for numtide (highly recommended)
  nix.settings = {
    extra-substituters = [
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "cache.numtide.com-1:2Qv1l3q4z5w6x7y8z9a0b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9u0v" # verify current key if needed
    ];
  };

  # Allow unfree packages (Grok Build is unfree)
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    grok
  ];
}
