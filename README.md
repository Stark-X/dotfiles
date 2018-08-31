# dotfiles
Personal dotfiles, including vim, slate, .zshrc, .bashrc, etc.

## Scope
- vimrc
- zshrc
- bashrc
- ~~slate~~ [DEPRECATED]
- HammerSpoon, https://github.com/Hammerspoon/hammerspoon

## Usage

### Mac
1. Install stow with brew 
execute `brew install stow`
2. Apply the dotfiles
```bash
cd ~
git clone https://github.com/Stark-X/dotfiles.git
cd dotfiles
stow $(ls -d */)
```
3. Deactive the changes
Unlink with command `stow -D $(ls -d */)`
