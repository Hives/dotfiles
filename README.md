# My dotfiles

Uses [GNU Stow](https://www.gnu.org/software/stow/).

Running e.g. `stow MY_CONFIG` from the dotfiles folder symlinks the contents of
the `MY_CONFIG` folder into the parent folder of the folder where the command
was run. Capiche?

So you could clone this repo into `~/.dotfiles/`, then run `stow vim` inside
`~/.dotfiles/`, and it will create symlinks of the contents of `vim` in your home
directory, which is what you want. Repeat for whatever else.

### tmux

Follow instructions to install [Tmux Plugin
Manager](https://github.com/tmux-plugins/tpm)

In tmux do `prefix` + `I` to install plugins from `.tmux.conf`

### vim

[`vim-plug`](https://github.com/junegunn/vim-plug) is included in `autoload`
folder. Run `:PlugInstall` to install plugins from `vimrc`.

Do something like `:mkspell ~/.vim/spell/en.utf-8.add` to compile the spellings
file.

## TODO

- zsh
- fzf
- base16
- git
- emacs?
