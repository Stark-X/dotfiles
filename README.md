# dotfiles

Personal dotfiles, including vim, .zshrc, .bashrc, etc.

## Scope

- vimrc
- zshrc
- bashrc
- HammerSpoon, <https://github.com/Hammerspoon/hammerspoon>
- coc

## Usage

### Mac

1. Install stow with brew
execute `brew install stow`
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

# brew install openjdk@11
# sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
cd lsp-examples && python3 ./install.py --enable-bash --enable-yaml --enable-vim --enable-vue --enable-json --enable-groovy --enable-docker
```

3. Deactive the changes
Unlink with command `stow -D <package_name>

