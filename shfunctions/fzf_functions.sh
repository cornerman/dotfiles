# fe - edit
fe() {
  local file
  curr_dir=$(pwd)
  cd-git-root
  file=$(fzf --multi --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
  cd "$curr_dir"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fh - repeat history
fh() {
  eval $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s | sed 's/ *[0-9]* *//')
}

# fkill - kill process
fk() {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

# ft - edit tags
ft() {
    local tagsdir=$PWD
    while [[ -n "$tagsdir" && ! -f "$tagsdir/tags" ]]; do
        tagsdir=${tagsdir%/*}
    done

    if [[ -f "$tagsdir/tags" ]]; then
        tags=$(cat "$tagsdir/tags")
    else
        tags=$(cat ~/.vim/vimtags/*)
    fi

    tag=$(echo "$tags" | grep language | sed 's/^\(\S*\).*\(\w\)\s*language:\(\w*\)\s*\(\S*\).*$/[\2] \1 |\3 \4/' | column -t | fzf --query="$1" --select-1 --exit-0)

    if [ -n "$tag" ]; then
        tag=$(echo "$tag" | tr -d '|' | awk '{ print $2 " " $3 }')
        IFS=' ' read tag ft <<<$tag
        ft=$(echo $ft | tr '[A-Z]' '[a-z]')
        vim -c "set filetype=$ft | tag $tag"
    fi
}

# fa - execute any command on selection
fa () {
    fzf | while read -r line; do $@ "$line"; done
}
