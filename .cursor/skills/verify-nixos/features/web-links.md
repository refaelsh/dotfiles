# Web links

Opening an HTML file or an http(s) link uses Brave. The desktop file is `brave-browser.desktop`.

## Sub-features

- `links-html` assigns `text/html` to Brave.
- `links-http` assigns the http, https, about, and unknown schemes to Brave.

## How to get to it (user POV)

- Open an `.html` file from a file manager or with `xdg-open`.
- Activate an `http://` or `https://` link from another program.
- The xmonad session also starts Brave on workspace 1. That is session startup, not this mime map.

## Driving it with verify-nixos

Preconditions:

- `verify-nixos launch` printed `ready host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05`.
- `verify-nixos doctor` printed `activation=unchanged`.
- The commands below use `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos`.

- **HTML.** Require the html type to use Brave's desktop file. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-json --feature web-links --artifact html xdg.mime.defaultApplications --python 'd["text/html"]=="brave-browser.desktop"'`. `html.out` has that pair.
- **Schemes.** Require http, https, about, and unknown to use the same desktop file. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-json --feature web-links --artifact schemes xdg.mime.defaultApplications --python 'd["x-scheme-handler/http"]=="brave-browser.desktop" and d["x-scheme-handler/https"]=="brave-browser.desktop" and d["x-scheme-handler/about"]=="brave-browser.desktop" and d["x-scheme-handler/unknown"]=="brave-browser.desktop"'`. `schemes.out` matches that expression.
- **Activation untouched.** Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-inactive --feature web-links --artifact activation`. `activation.out` shows the same booted path and the same result-link list as launch.

## Gotchas

- Do not run `xdg-open`. That opens the user's browser.
- The desktop id is `brave-browser.desktop`. `brave.desktop` is the wrong name for this mime map and fails the journey.
- `x-scheme-handler/sand` is `grok-bot.desktop`. Do not require it to be Brave.
- This journey evaluates the mime map. It does not prove that the Brave wrapper's command-line flags were applied. Those flags are a different package setting.
