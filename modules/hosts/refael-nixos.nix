{ lib, inputs, ... }:
{
  # ── Automatic dendritic aggregator (no manual imports ever again) ──
  flake.nixosModules.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = lib.attrValues (removeAttrs inputs.self.nixosModules [ "nixos" ]);
    };

  # ── The actual NixOS host ──
  flake.nixosConfigurations.myNixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };

    modules = [
      # One line = all your features (brave, ghostty, starship, git, etc.) are pulled in automatically
      inputs.self.nixosModules.nixos

      # KBDD overlay
      {
        nixpkgs.overlays = [
          (
            final: prev:
            let
              lib = prev.lib;

              # Read the nixpkgs expressions directly. Looking these facts up
              # on python3Packages from this overlay loops: that set is built
              # from pythonPackagesExtensions.
              pyExpr = name: builtins.readFile (prev.path + "/pkgs/development/python-modules/${name}/default.nix");
              srText = pyExpr "speechrecognition";
              # speechrecognition's OpenAI tests mock httpx via respx. openai
              # links httpx2, so the mock misses, the test tries a real DNS
              # lookup, and the sandbox fails it with APIConnectionError.
              # markitdown's install checks depend on that package, and the
              # markitdown command on PATH does not ship the extra. Skip the
              # checks only while that mismatch remains. Evaluation stops
              # once the tests are disabled, respx mocks httpx2, or openai
              # stops using httpx2, so this skip is deleted with the fix.
              openaiWhisperTestsDisabled = lib.any (name: lib.hasInfix name srText) [
                "test_transcribe_with_openai_whisper"
                "test_transcribe_with_specified_language"
                "test_transcribe_with_specified_prompt"
              ];
              speechrecognitionTestsFixed =
                openaiWhisperTestsDisabled
                || lib.hasInfix "httpx2" (pyExpr "respx")
                || !(lib.hasInfix "httpx2" (pyExpr "openai"));
            in
            {
              kbdd = prev.kbdd.overrideAttrs (old: {
                src = prev.fetchFromGitHub {
                  owner = "qnikst";
                  repo = "kbdd";
                  rev = "b87e44afd5859157245eee22b11827605bfa09b9";
                  hash = "sha256-cbMcB6jgssfMUjemBOiE06zJK2TbzOWt1Rvt41V33Mo=";
                };
              });

              pythonPackagesExtensions = lib.throwIf speechrecognitionTestsFixed ''
                nixpkgs no longer needs the markitdown check skip. The
                speechrecognition OpenAI tests are disabled, respx mocks
                httpx2, or openai no longer uses httpx2. Delete the
                markitdown override in modules/hosts/refael-nixos.nix.
              '' (
                prev.pythonPackagesExtensions
                ++ [
                  (
                    pyFinal: pyPrev: {
                      markitdown = pyPrev.markitdown.overridePythonAttrs (_old: {
                        doCheck = false;
                      });
                    }
                  )
                ]
              );
            }
          )
        ];
      }
    ];
  };
}
