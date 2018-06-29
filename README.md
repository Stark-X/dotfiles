# dotfiles
Personal dotfiles, including vim, slate, .zshrc, .bashrc, etc.

## Scope
- vimrc
- zshrc
- bashrc
- slate

## Usage

### Mac
1. Install stow with brew 
execute `brew install brew`
2. Apply the dotfiles
```bash
cd ~
git clone https://github.com/Stark-X/dotfiles.git
cd dotfiles
stow $(ls -d */)
```
3. Deactive the changes
Unlink with command `stow -D $(ls -d */)`
