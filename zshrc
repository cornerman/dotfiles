# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history

# import new commands from the history file also in other zsh-session
setopt share_history

# save each command's beginning timestamp and the duration to the history file
setopt extended_history

# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups

# Expire duplicate entries first when trimming history.
setopt hist_expire_dups_first

# Don't record an entry that was just recorded again.
setopt hist_ignore_dups

# Don't write duplicate entries in the history file.
setopt hist_save_no_dups

# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

# When searching history don't display results already cycled through twice
setopt hist_find_no_dups

# Remove extra blanks from each command line being added to history
setopt hist_reduce_blanks

# !keyword
setopt bang_hist

# if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
#setopt cdablevar

# if a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob

# display PID when suspending processes as well
setopt longlistjobs

# try to avoid the 'zsh: no matches found...'
setopt nonomatch

# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

# Don't send SIGHUP to background processes when the shell exits.
# setopt nohup

# make cd push the old directory onto the directory stack.
setopt auto_pushd

# swap the meaning of + and -, makes more sense and is easier to type
setopt pushdminus

# don't push the same dir twice.
setopt pushd_ignore_dups

# avoid "beep"ing
setopt nobeep

# * shouldn't match dotfiles. ever.
setopt noglobdots

# use zsh style word splitting
setopt noshwordsplit

# correct me if i'm wrong
setopt correct

# comments in shell
setopt interactivecomments

# When completing from the middle of a word, move the cursor to the end of the word
setopt always_to_end

# Allow completion from within a word/phrase
setopt complete_in_word

# Automatically list choices on an ambiguous completion
setopt auto_list

# only show the rprompt on the current prompt
setopt transient_rprompt

# perform implicit tees or cats when multiple redirections are attempted
setopt multios

# don't error out when unset parameters are used
#setopt unset

# we don't want no flow control, i.e. unfreeze/freeze
unsetopt flow_control
stty -ixon

# set some important variables
export EDITOR=vim
export PAGER=/usr/local/bin/vimpager
alias less=$PAGER
alias zless=$PAGER
export BROWSER=x-www-browser
export HIST_PATH=~/
export TEMP_PATH=~/
export MAIL=${MAIL:-/var/mail/$USER}
export SHELL='/bin/zsh'

# persistent dirstack
DIRSTACKSIZE=20
DIRSTACKFILE=~/.zdirs
if [[ -f ${DIRSTACKFILE} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    # "cd -" won't work after login by just setting $OLDPWD, so
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

chpwd() {
    if (( $DIRSTACKSIZE <= 0 )) || [[ -z $DIRSTACKFILE ]]; then return; fi
    local -ax my_stack
    my_stack=( ${PWD} ${dirstack} )
    builtin print -l ${(u)my_stack} >! ${DIRSTACKFILE}
}

# history
HISTFILE=~/.zsh_history
HISTSIZE=15000
SAVEHIST=15000

# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5

# watch for everyone but me and root
watch=(notme root)

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# only slash should be considered as a word separator:
slash-backward-kill-word() {
    local WORDCHARS="${WORDCHARS:s@/@}"
    # zle backward-word
    zle backward-kill-word
}
zle -N slash-backward-kill-word

# activate zmv command
autoload -U zmv

# colors
eval $( dircolors -b $HOME/.dir_colors )
alias allcolors='for i in {0..255}; do echo -e "\e[38;05;${i}m\\\e[38;05;${i}m"; done | column -c 80 -s " "; echo -e "\e[m]]]"'

# completion
#if
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete # _correct  _approximate
zstyle ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/5 )) numeric )'
zstyle ':completion:*' completions 1
zstyle ':completion:*' file-sort name
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#cache for package managers
zstyle ':completion:*' use-cache on
zstyle ':completion:*' verbose on
zstyle ':completion:*' cache-path ~/.zshcache

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

#proper tabing for directorys ../ is niiice
zstyle ':completion:*' special-dirs true

#tabbing menu
zstyle ':completion:*' menu yes=long-list
zstyle ':completion:*' menu select=2

#color partial completions in menu
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")';

#nice for kill (now with colors)
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps xf -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:kill:*' insert-ids single
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*[0-9][0-9]:[0-9][0-9]:[0-9][0-9] #([|\\_ ]#) #([^ ]#)*=0=01;31=0=01;34'

#nice for killall
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd|grep --color=none -Eo "^[^ ]*"| grep --color=none -Eo "[^/]*$"|sed -e 1d'

#tabing for man pages
zstyle ':completion:*:man:*' separate-sections true

#allready rmed files will not show up again
zstyle ':completion:*:(cp|rm):*' ignore-line yes
zstyle ':completion:*:*:firefox:*:*' file-patterns '*.(html|htm)' '%p:all-files'
#cd into folder only
zstyle ':completion:*:*:cd_wrapper:*:*' file-patterns '*(-/):directories'
zstyle ':completion:*:*:evince:*:*' file-patterns '*.pdf:pdfs:pdfs *(-/):directories'

# automatic rehash on completion
zstyle ":completion:*:commands" rehash 1

#history search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

#fix insert mode fuckup
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char

#proper undo
zle -A .undo vi-undo-change

# key setup
typeset -A key
key=(
Home     "${terminfo[khome]}"
End      "${terminfo[kend]}"
Insert   "${terminfo[kich1]}"
Delete   "${terminfo[kdch1]}"
Up       "${terminfo[kcuu1]}"
Down     "${terminfo[kcud1]}"
Left     "${terminfo[kcub1]}"
Right    "${terminfo[kcuf1]}"
PageUp   "${terminfo[kpp]}"
PageDown "${terminfo[knp]}"
BackTab  "${terminfo[kcbt]}"
)

function bind2maps () {
    local i sequence widget
    local -a maps

    while [[ "$1" != "--" ]]; do
        maps+=( "$1" )
        shift
    done
    shift

    if [[ "$1" == "-s" ]]; then
        shift
        sequence="$1"
    else
        sequence="${key[$1]}"
    fi
    widget="$2"

    [[ -z "$sequence" ]] && return 1

    for i in "${maps[@]}"; do
        bindkey -M "$i" "$sequence" "$widget"
    done
}

# vi mode
export KEYTIMEOUT=1
bindkey -v

# enable menuselect map
zmodload -i zsh/complist

# Shift-tab Perform backwards menu completion
bind2maps menuselect -- BackTab reverse-menu-complete

# ctrl-p ctrl-n history navigation
bind2maps emacs viins vicmd -- '^P' up-history
bind2maps emacs viins vicmd -- '^N' down-history

# backspace and ^h working even after returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# [Space] - do history expansion
bindkey ' ' magic-space

#vim style control in completion lists
bind2maps menuselect -- 'h' vi-backward-char                # links
bind2maps menuselect -- 'j' vi-down-line-or-history         # unten
bind2maps menuselect -- 'k' vi-up-line-or-history           # oben
bind2maps menuselect -- 'l' vi-forward-char                 # rechts

# use Ctrl-left-arrow and Ctrl-right-arrow for jumping to word-beginning/end
bind2maps emacs viins vicmd -- -s '^[[1;5C' forward-word
bind2maps emacs viins vicmd -- -s '^[[1;5D' backward-word

# use home/end to move to beginning/end of line
bind2maps emacs viins vicmd -- "Home" beginning-of-line
bind2maps emacs viins vicmd -- "End" end-of-line

# search history backward/forward for entry beginning with typed text with up/down
bind2maps emacs viins vicmd -- Up     up-line-or-search
bind2maps emacs viins vicmd -- Down   down-line-or-search

# move in insert mode
bind2maps emacs viins vicmd -- -s '^w' vi-forward-blank-word
bind2maps emacs viins vicmd -- -s '^b' vi-backward-blank-word
bind2maps emacs viins vicmd -- -s '^e' end-of-line
bind2maps emacs viins vicmd -- -s '^a' beginning-of-line

# search history backwards/forwards with ctrl+r/ctrl+f
bind2maps emacs viins vicmd -- -s '^r' history-incremental-pattern-search-backward
bind2maps emacs viins vicmd -- -s '^f' history-incremental-pattern-search-forward

# just increase the last number in the current line
_increase_number() {
    local -a match mbegin mend
    [[ $LBUFFER =~ '([0-9]+)[^0-9]*$' ]] &&
        LBUFFER[mbegin,mend]=$(printf %0${#match[1]}d $((10#$match+${NUMERIC:-1})))
}
zle -N increase-number _increase_number
bind2maps emacs viins vicmd -- -s '^x' increase-number

# color in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS=-asrRix8

# edit command in editor
autoload edit-command-line
zle -N edit-command-line
bind2maps vicmd -- -s 'v' edit-command-line

# zsh with pwd in window title
function precmd {
    term=$(echo $TERM | grep -Eo '^[^-]+')
    print -Pn "\e]0;$term:zsh %~\a"
}

# current command with args in window title
function preexec {
    term=$(echo $TERM | grep -Eo '^[^-]+')
    printf "\033]0;%s:%s\a" "$term" "$1"
}

# prompt settings
autoload promptinit && promptinit
prompt hjem 8bit vimode

# include function
include(){
    [ -f "$1" ] && . "$1"
}

include_all(){
    if [[ -d $1 ]]; then
        for file in $1/*; do
            . "$file"
        done
    fi
}

# "persistent history"
# just write important commands you always need to ~/.important_commands
if [[ -r ~/.important_commands ]] ; then
    fc -R ~/.important_commands
fi

# custom zsh completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit
#parameter completions for programms that understand --hrlp
compdef _gnu_generic df wc tar make date mv cp grep sed feh awk tail head watch unzip unrar ln ssh diff cdrecord nc strings objdump od

# custom bash completion
autoload bashcompinit && bashcompinit
include_all ~/.zsh/bash_completion

# local settings
include ~/.zshrc.local
