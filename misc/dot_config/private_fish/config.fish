#!/usr/bin/fish
alias ls="ls --color=auto"

function fish_greeting
end

# Start X at login.
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end

starship init fish | source

set PATH "/$HOME/.cargo/bin:$PATH"
