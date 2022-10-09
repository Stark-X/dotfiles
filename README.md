# dotfiles

Personal dotfiles, including vim, .zshrc, .bashrc, etc.

## Scope

- vimrc
- zshrc
- bashrc
- HammerSpoon, <https://github.com/Hammerspoon/hammerspoon>
- coc
- tmux

## Usage

1. Install stow with brew
execute `brew install stow` on Macos, or `apt install stow` for Debian distribution
2. Apply the dotfiles

```bash
cd ~
git clone https://github.com/Stark-X/dotfiles.git
cd dotfiles
stow coc -t ~/.vim
stow bash
stow hammerspoon
stow ideavim
stow vim
stow zsh
stow tmux
```

3. install [Oh my tmux!](https://github.com/gpakosz/.tmux) and [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

## Disable

Unlink with command `stow -D <package_name>

