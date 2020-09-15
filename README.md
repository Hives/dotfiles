# My dotfiles

Uses [GNU Stow](https://www.gnu.org/software/stow/).

Running e.g. `stow vim` from the dotfiles folder symlinks the contents of the
`vim` folder into the parent folder of the folder where the command was run.

So you could clone this repo into `~/.dotfiles/`, then run `stow vim` inside
`~/.dotfiles/`, and it will create symlinks of the contents of `vim` in your home
directory, which is what you want. Repeat for whatever else.

### Vim

`vim-plug` is included in `autoload` folder. Run `:PlugInstall` to install
plugins.
