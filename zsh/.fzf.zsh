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

# Customize settings
# ------------
export FZF_COMPLETION_TRIGGER=''
# ^T trigger the context completion
bindkey '^T' fzf-completion
# ^I/TAB trigger the default command completion
bindkey '^I' $fzf_default_completion
# M-C trigger the context search with tree preview
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
# ^R trigger the fuzzy command search, use ? to toggle the preview window
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# [Solarized-Dark theme](https://github.com/junegunn/fzf/wiki/Color-schemes#alternate-solarized-lightdark-theme)
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  # Comment and uncomment below for the light theme.

  # Solarized Dark color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "
  ## Solarized Light color scheme for fzf
  #export FZF_DEFAULT_OPTS="
  #  --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
  #  --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  #"
}
_gen_fzf_default_opts
