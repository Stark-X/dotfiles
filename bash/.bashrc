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
### Alias ###

#https://stackoverflow.com/questions/8616843/ctrl-s-is-not-working-as-a-horizontal-split-in-vim-when-using-commandt
stty -ixon -ixoff
export PATH=$PATH:/Users/$USER/Applications/kubernetes/client/bin
alias ag='ag --hidden'

# Disable fzf for bash
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

### Command Initial ###
eval $(thefuck --alias)
### Command Initial ###

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
