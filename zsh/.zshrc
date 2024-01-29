# disable zsh wildcard behavior which is different from bash
setopt +o nomatch
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH=${HOME}/.oh-my-zsh
export ZSH="${HOME}/.local/share/sheldon/repos/github.com/ohmyzsh/ohmyzsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
  python
  pip
  poetry
  # auto-login
  kubectl
)

# z.lua
alias zc='z -c'      # 严格匹配当前路径的子路径
alias zz='z -i'      # 使用交互式选择模式
alias zf='z -I'      # 使用 fzf 对多个结果进行选择
alias zb='z -b'      # 快速回到父目录
# https://github.com/skywind3000/z.lua/wiki/FAQ#how-to-input-a-hyphen---in-the-keyword-
export _ZL_HYPHEN=1 # disable hyphen regex

# User configuration

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

eval "$(sheldon source)"

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
### Alias ###

#https://stackoverflow.com/questions/8616843/ctrl-s-is-not-working-as-a-horizontal-split-in-vim-when-using-commandt
# stty -ixon -ixoff

### golang ###
export GOPATH=$HOME/workspace/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
export GOPROXY=https://goproxy.cn
### golang ###

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

export EDITOR='vim'
command -v nvim >/dev/null && export EDITOR='nvim' && alias vim="nvim"

# Remove the prompt the shell showed
DEFAULT_USER=$USER

#### fzf ####
# ^R -> list histroy using fzf
# ^T -> list folders/files and copy the selected to append to currect command
# M-C -> list folders and enter the selected
# vim ** -> list fuzzy search folders/files

# Change to using silver search for fzf
export FZF_DEFAULT_COMMAND='ag -l --path-to-ignore ~/.ignore --nocolor --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fzf with preview
function fzfp(){
    fzf --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -100'
}
#### fzf ####

alias glgp="git log --graph --oneline --decorate --all"
alias glogp="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

#### Tmux ####
export TERM="xterm-256color"
alias ssh='TERM=xterm-256color \ssh'
#### Tmux ####


# Added by serverless binary installer
export PATH="$HOME/.serverless/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"


# Default PNPM_HOME
export PNPM_HOME="${HOME}/.local/share/pnpm"

# What OS are we running?
if uname -r |grep -iq 'Microsoft' ; then
    #### WSL ####
    export QT_IM_MODULE=fcitx
    export XIM_PROGRAM=fcitx
    export GTK_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
    export rime_dir="$HOME/.config/fcitx/rime"

    # nohup fcitx-autostart  2>&1 >> /dev/null &

    export HOST_IP=$(ip route | grep default | awk '{print $3}')
    export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
    export LIBGL_ALWAYS_INDIRECT=1

    alias pbcopy='win32yank.exe -i'
    alias pbpaste='win32yank.exe -o'

    # disable due to latest WSL support systemd
    # sudo service mysql status >> /dev/null || sudo service mysql start
    # sudo service redis-server status >> /dev/null || sudo service redis-server start
    alias freecachemem='sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null'

elif [[ `uname` == "Darwin" ]]; then
    # MacOs

    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

    if type brew &>/dev/null; then
        FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

        autoload -Uz compinit
        compinit
    fi

    # FIXME: check if necessary
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.rvm/bin:/opt/homebrew/opt/python@3.10/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/python@3.10/lib"

    export PNPM_HOME="$HOME/Library/pnpm"
fi

# 1Password cli completion
command -v op > /dev/null || eval "$(op completion zsh)"; compdef _op op

export PATH="$HOME/.poetry/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


export COLORTERM=truecolor

# pnpm
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# gvm for mutliple go version, refer: https://github.com/moovweb/gvm
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH="$N_PREFIX/bin:$PATH"  # Added by n-install (see http://git.io/n-install-repo).

##### Copilot Alias #####
alias css="gh copilot suggest -t shell "
alias csg="gh copilot suggest -t git "
alias csh="gh copilot suggest -t gh "
##### Copilot Alias #####
