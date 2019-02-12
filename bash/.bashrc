### Custom Functions ###
# gitignore shortcut
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}
# list all symbolic link in curret folder
function lll() {
    local IFS=$'\n'
    ls -l `find . -maxdepth 1 -type l -print`
}
### Custom Functions ###

### Alias ###
alias ag='ag --hidden'
alias twvpn='python3 ~/workspace/myprojects/twvpn/main.py'
### Alias ###

#https://stackoverflow.com/questions/8616843/ctrl-s-is-not-working-as-a-horizontal-split-in-vim-when-using-commandt
stty -ixon -ixoff

export GOPATH=$HOME/workspace/go
# export GOBIN=$HOME/go/bin
export PATH=$PATH:/Users/$USER/Applications/kubernetes/client/bin:$GOPATH/bin

# Disable fzf for bash
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

### Command Initial ###
eval $(thefuck --alias)
### Command Initial ###

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
# Editor for the Hexo
export EDITOR='vim'

### Completion ###
## If running Bash 3.2 included with macOS
# brew install bash-completion
## or, if running Bash 4.1+
# brew install bash-completion@2
# kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
### Completion ###

# Change to using silver search for fzf
export FZF_DEFAULT_COMMAND='ag -l --path-to-ignore ~/.ignore --nocolor --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fzf with preview
function fzfp(){
    fzf --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -100'
}

export PATH="$PATH:$HOME/.rvm/bin:$HOME/Library/Python/3.7/bin"

