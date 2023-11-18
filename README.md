# dotfiles

Personal dotfiles, including vim, .zshrc, .bashrc, etc.

## Scope

- vimrc
- zshrc
- bashrc
- HammerSpoon, <https://github.com/Hammerspoon/hammerspoon>
- coc
- tmux
- sheldon

## Usage

1. Install stow with brew
execute `brew install stow` on Macos, or `apt install stow` for Debian distribution
2. Apply the dotfiles

``` bash
cd
git clone https://github.com/Stark-X/dotfiles.git
# install oh-my-tmux
git clone --depth 1 https://github.com/gpakosz/.tmux
ln -s -f .tmux/.tmux.conf

cd dotfiles
# change to use neovim for better performance and lua config convenient
#stow coc -t ~/.vim
#stow vim
stow bash
stow hammerspoon
stow ideavim
stow zsh
stow tmux
# symbol link to .config, including neovim and sheldon config
mkdir ~/.config/
stow -t ~/.config dot_config
```

3. install [sheldon](https://github.com/rossmacarthur/sheldon) and [Neovim nightly](https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-package)

## Disable

Unlink with command `stow -D <package_name>`
