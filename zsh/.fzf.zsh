# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/jzxiao/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/jzxiao/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/jzxiao/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/jzxiao/.fzf/shell/key-bindings.zsh"

