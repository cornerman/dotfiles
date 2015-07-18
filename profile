[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"

export PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"

# colorize manpages
export LESS_TERMCAP_mb=$(printf "\33[01;34m")   # begin blinking
export LESS_TERMCAP_md=$(printf "\33[01;34m")   # begin bold
export LESS_TERMCAP_me=$(printf "\33[0m")       # end mode
export LESS_TERMCAP_se=$(printf "\33[0m")       # end standout-mode
export LESS_TERMCAP_so=$(printf "\33[44;1;37m") # begin standout-mode - info box
export LESS_TERMCAP_ue=$(printf "\33[0m")       # end underline
export LESS_TERMCAP_us=$(printf "\33[01;35m")   # begin underline

# fzf fuzzy file finder
export FZF_DEFAULT_COMMAND='(files=`git ls-tree --full-tree -r --name-only HEAD` && echo "$files" | xargs -I{} echo `git rev-parse --show-toplevel`/{} || ag -l --hidden -g "")'
export FZF_DEFAULT_OPTS="--extended --ansi --exit-0 --select-1 --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all,ctrl-o:toggle-down,tab:toggle-up,ctrl-s:toggle-sort --history=$HOME/.fzf_history"
touch $HOME/.fzf_history
