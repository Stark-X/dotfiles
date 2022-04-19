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
stow vscode
stow zsh
stow vscode -t ~/Library/Application\ Support/Code/User 

# brew install openjdk@11
# sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
cd lsp-examples && python3 ./install.py --enable-bash --enable-yaml --enable-vim --enable-vue --enable-json --enable-groovy --enable-docker
```

3. vscode extensions sync

```bash
# code --list-extensions | xargs -L 1 echo code --install-extension
code --install-extension akamud.vscode-javascript-snippet-pack
code --install-extension austin.code-gnu-global
code --install-extension batisteo.vscode-django
code --install-extension christian-kohler.path-intellisense
code --install-extension cstrap.python-snippets
code --install-extension dbaeumer.vscode-eslint
code --install-extension donjayamanne.jupyter
code --install-extension donjayamanne.python-extension-pack
code --install-extension eamodio.gitlens
code --install-extension eg2.tslint
code --install-extension Equinusocio.vsc-material-theme
code --install-extension formulahendry.code-runner
code --install-extension HookyQR.beautify
code --install-extension Hridoy.rails-snippets
code --install-extension jonsmithers.open-in-vim
code --install-extension magicstack.MagicPython
code --install-extension mitaki28.vscode-clang
code --install-extension MS-CEINTL.vscode-language-pack-zh-hans
code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.Go
code --install-extension PeterJausovec.vscode-docker
code --install-extension PKief.material-icon-theme
code --install-extension rebornix.ruby
code --install-extension redhat.java
code --install-extension robertohuertasm.vscode-icons
code --install-extension rogalmic.bash-debug
code --install-extension shakram02.bash-beautify
code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension vayan.haml
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension vscjava.vscode-java-debug
code --install-extension vscjava.vscode-java-dependency
code --install-extension vscjava.vscode-java-pack
code --install-extension vscjava.vscode-java-test
code --install-extension vscjava.vscode-maven
code --install-extension vscodevim.vim
code --install-extension wayou.vscode-todo-highlight
code --install-extension wholroyd.jinja
code --install-extension wmontalvo.vsc-jsonsnippets
code --install-extension yzane.markdown-pdf
code --install-extension yzhang.markdown-all-in-one
code --install-extension zhuangtongfa.Material-theme
```

4. Deactive the changes
Unlink with command `stow -D <package_name>

