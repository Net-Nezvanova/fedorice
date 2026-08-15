# Fedora's default login shell is bash, and every piece of this setup --
# ~/.local/bin on $PATH, the XDG variables, ZDOTDIR, and the startx-on-tty1
# line -- lives in .config/shell/profile, which is only ever reached as
# ~/.zprofile once the login shell is actually zsh.
#
# If `usermod -s /bin/zsh` did not take, or this user is logged into from
# anywhere that forces bash, none of that runs: you get a bare prompt, no
# graphical session, and nothing anywhere saying why. Sourcing the same file
# here removes that failure mode. It is harmless when zsh is the login shell,
# because bash never reads this file in that case.

[ -f "$HOME/.config/shell/profile" ] && . "$HOME/.config/shell/profile"
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
