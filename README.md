# My dotfiles

Uses [GNU Stow](https://www.gnu.org/software/stow/).

Running e.g. `stow MY_CONFIG` from the dotfiles folder symlinks the contents of
the `MY_CONFIG` folder into the parent folder of the folder where the command
was run. Capiche?

So you could clone this repo into `~/.dotfiles/`, then run `stow vim` inside
`~/.dotfiles/`, and it will create symlinks of the contents of `vim` in your home
directory, which is what you want. Repeat for whatever else.

### Vim

[`vim-plug`](https://github.com/junegunn/vim-plug) is included in `autoload` folder. Run `:PlugInstall` to install
plugins.
