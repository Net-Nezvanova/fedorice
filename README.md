# Voidrice, Fedora fork

A fork of [Luke Smith's voidrice](https://github.com/LukeSmithxyz/voidrice)
patched to run on Fedora. Deployed by
[`fedora.sh`](https://github.com/Net-Nezvanova/FedoraLARBS/blob/main/fedora-larbs/fedora.sh), the Fedora port of
[LARBS](https://larbs.xyz).

- Very useful scripts are in `~/.local/bin/`
- Settings for:
	- vim/nvim (text editor)
	- zsh (shell)
	- lf (file manager)
	- mpd/ncmpcpp (music)
	- sxiv (image/gif viewer)
	- mpv (video player)
	- other stuff like xdg default programs, inputrc and more, etc.
- I try to minimize what's directly in `~` so:
	- All configs that can be in `~/.config/` are.
	- Some environmental variables have been set in `~/.zprofile` to move configs into `~/.config/`
- Bookmarks in text files used by various scripts (like `~/.local/bin/shortcuts`)
	- File bookmarks in `~/.config/shell/bm-files`
	- Directory bookmarks in `~/.config/shell/bm-dirs`

## What differs from upstream

**Line endings and symlinks.** `.gitattributes` pins the whole tree to LF. Six
files are stored as symlinks (`git ls-files -s` shows mode `120000`):
`.zprofile`, `.xprofile`, `.xinitrc`, `.gtkrc-2.0`, `.config/sxiv` and
`.local/share/bg`. Both matter: a CRLF shebang is unrunnable on Linux, and
`~/.zprofile` arriving as a regular file means the login profile never runs at
all — no `$PATH`, no `$XINITRC`, no `startx`, and nothing in any log to say why.
**Always deploy this repo by cloning it on the target machine.** Never copy the
working tree from a Windows checkout.

**Package manager.** `ifinstalled`, `cron/checkup`, `sb-popupgrade` and
`aliasrc` use dnf and rpm. `sb-pacpackages` is now `sb-dnfpackages`, and it
tests `dnf check-update` for exit code **100** — the code that means "updates
are available". Treating any non-zero status as success would report every
metadata failure as a pending upgrade.

**Session start.** Three upstream lines are Artix/runit accommodations that are
wrong on systemd and fail silently:

- `.config/shell/profile` runs plain `exec startx`, not `startx "$XINITRC"`.
  Passing an explicit client path makes startx skip `/etc/X11/xinit/xinitrc`
  and its `xinitrc.d` snippets, one of which imports `DISPLAY` into the systemd
  user manager. `~/.xinitrc` is a symlink so plain `startx` still finds it, and
  `.config/x11/xinitrc` sources the system snippets itself.
- `.config/x11/xinitrc` ends in `exec ssh-agent dwm`, without `dbus-launch`.
  systemd already provides a session bus; a second one leaves dunst, keyring
  and pinentry each talking to whichever they inherited.
- `pipewire` is gone from the `xprofile` autostart list and
  `.config/pipewire/pipewire.conf.d/user-session.conf` is deleted, leaving
  exactly one pipewire started by systemd socket activation.

**Program substitutions**, where Fedora packages nothing equivalent:
`nsxiv`→`sxiv`, `xwallpaper`→`feh`, `simple-mtpfs`→`jmtpfs`,
`xbacklight`→`brightnessctl`, `geoiplookup`→an HTTP country lookup (Fedora's
GeoIP data has been frozen since 2018), Arc-Gruvbox→Arc-Dark, JoyPixels
dropped, and the zsh syntax-highlighting `source` line searches both the Arch
and Fedora paths so it still works on either.

**Removed:** mail, RSS and calendar. No neomutt, mutt-wizard, newsboat,
calcurse or abook, and the `sb-mailbox`, `sb-news`, `rssadd`, `rssget`,
`podentr`, `queueandnotify` and `cron/newsup` scripts are gone with them.

**Torrents** use `transmission-remote` only; `stig` is not packaged anywhere
and its published metadata caps at Python 3.11.

## Usage

These dotfiles are intended to go with numerous suckless programs:

- [dwm](https://github.com/lukesmithxyz/dwm) (window manager)
- [dwmblocks](https://github.com/lukesmithxyz/dwmblocks) (statusbar)
- [st](https://github.com/lukesmithxyz/st) (terminal emulator)
- [dmenu](https://github.com/lukesmithxyz/dmenu) (menu)

The dmenu fork is not optional. `dmenupass`, the `SUDO_ASKPASS` handler, needs
its `-P` flag to mask input. Fedora's packaged dmenu is vanilla and does not
have it, so every password prompt in the session would silently fail.

## Install

See [`RUNBOOK.md`](https://github.com/Net-Nezvanova/FedoraLARBS/blob/main/fedora-larbs/RUNBOOK.md). In short: on a
fresh minimal Fedora, as root,

```
./fedora.sh -n -r <url-of-this-repo>   # dry run: resolve everything first
./fedora.sh -r <url-of-this-repo>
```

If this repo lives inside a larger one alongside the installer, name the
subdirectory that holds `.config` and `.local`:

```
./fedora.sh -r <url-of-the-monorepo> -d voidrice -b main
```

## Default Desktop Artwork

Thomas Thiemeyer's *The Road to Samarkand* ([fb](https://www.facebook.com/t.thiemeyer/), [insta](https://www.instagram.com/tthiemeyer/))
