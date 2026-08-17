{ lib, ... }:
{
  flake.nixosModules.grok-build =
    { config, pkgs, inputs, ... }:
    let
      grokRaw = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok;
      home = config.users.users.refaelsh.home;

      # Wrap the grok binary so the entire agent process tree (main + subagents,
      # monitors, background commands, MCP node process) runs at lower CPU
      # scheduling priority. This keeps the interactive desktop (xmonad, ghostty
      # rendering the TUI, browser, etc.) more responsive during heavy work.
      # Children usually inherit the niceness.
      #
      # The wrapper is transparent: grok works exactly the same, only its
      # scheduling priority is reduced.
      grokWrapped = pkgs.writeShellScriptBin "grok" ''
        exec ${pkgs.coreutils}/bin/nice -n 10 ${lib.getExe grokRaw} "$@"
      '';
    in
    {
      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };

      environment.systemPackages = [ grokWrapped ];

      # One copy of QRSPI skills lives in skills/ next to this module (git).
      # Rebuild runs ln so a new machine does not need a manual step.
      system.activationScripts.grok-skills = ''
        mkdir -p ${home}/.grok
        ln -sfn ${home}/repos/dotfiles/modules/programs/grok-build/skills ${home}/.grok/skills
      '';
    };
}
