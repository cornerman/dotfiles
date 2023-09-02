# If not running interactively, don't do anything
[ -z "$PS1" ] && return
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
_priceloop_completions() {
  local IFS=$'\n'
  eval "$(priceloop complete bash-v1 "$(( $COMP_CWORD + 1 ))" "${COMP_WORDS[@]}")"
}

complete -F _priceloop_completions priceloop
