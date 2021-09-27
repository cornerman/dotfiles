# v - edit
v() {
  local file
  local curr_dir
  curr_dir=$(pwd)
  cd-git-root
  file=$(fzf --multi --query="$(echo $@ | tr ' ' '\ ')" --select-1 --exit-0 | tr "\n" " ")
  [ -n "$file" ] && eval "${EDITOR:-vim} $file"
  cd "$curr_dir"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fkill - kill process
fk() {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fbr - checkout git branch (including remote branches)
fcob() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fsha() {
  local commits commit
  commits=$(git log --all --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
    while out=$(
      git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
      fzf --ansi --no-sort --query="$q" --print-query \
          --expect=ctrl-d,ctrl-b);
    do
      q=$(head -1 <<< "$out")
      k=$(head -2 <<< "$out" | tail -1)
      sha=$(tail -1 <<< "$out" | cut -d' ' -f1)
      [ -z "$sha" ] && continue
      if [ "$k" = 'ctrl-d' ]; then
        git diff $sha
      elif [ "$k" = 'ctrl-b' ]; then
        git stash branch "stash-$sha" $sha
        break;
      else
        git stash show -p $sha
      fi
    done
}

unalias z
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

zz() {
  cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q $_last_z_args)"
}

# fa - execute any command on selection
fa () {
    fzf | while read -r line; do $@ "$line"; done
}

# start vms
fvm() {
    vboxmanage list vms | awk '{ print $1 }' | tr -d '"' | fa vboxmanage startvm
}

# ftstate - show terraform state
# example usage: ftstate
ftstate() {
  local states state
  states=$(terraform state list) &&
  state=$(echo "$states" | fzf --tac +s +m -e --ansi --reverse) &&
  terraform state show "$state"
}

# fni - install nixpack
# example usage: fni <pkg>
fni() {
  local packages package
  packages=$(nix search $1 | tr -d '\n' | sed 's/  / /g' | sed s/*/\\n/g | sed 's/^ //g' | grep '\S') &&
  package=$(echo "$packages" | fzf --tac +s +m -e --ansi --reverse | cut -F1) &&
  nix-env -iA "$package"
}
