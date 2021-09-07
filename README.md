# My dotfiles

Uses [GNU Stow](https://www.gnu.org/software/stow/).

You need to clone this project, and its submodules (zsh plugins, base16...), and
move it to e.g. `~/.dotfiles`:

```shell
cd ~
git clone --recurse-submodules git@github.com:Hives/dotfiles.git
mv dotfiles .dotfiles
```

Running e.g. `stow MY_CONFIG` from the dotfiles folder symlinks the contents of
the `MY_CONFIG` folder into the parent folder of the folder where the command
was run. Capiche?

So you could clone this repo into `~/.dotfiles/`, then run `stow vim` inside
`~/.dotfiles/`, and it will create symlinks of the contents of `vim` in your home
directory, which is what you want. Repeat for whatever else.

### zsh

Requires:

- [autojump](https://github.com/wting/autojump)
- [fzf](https://github.com/junegunn/fzf)
  - [fd](https://github.com/sharkdp/fd)
- [starship prompt](https://starship.rs/guide/#%F0%9F%9A%80-installation)
- neovim (`.zshrc` sets it as default editor, check the path)

### vim

[vim-plug](https://github.com/junegunn/vim-plug) is included in `autoload`
folder. Run `:PlugInstall` to install plugins from `vimrc`.

Do something like `:mkspell ~/.vim/spell/en.utf-8.add` to compile the spellings
file.

### tmux

Follow instructions to install [Tmux Plugin
Manager](https://github.com/tmux-plugins/tpm)

In tmux do `prefix` + `I` to install plugins from `.tmux.conf`

## TODO

- fzf
- git
- Xresources
- emacs?
