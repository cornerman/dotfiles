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
fa() {
  fzf | while read -r line; do $@ "$line"; done
}

# start vms
fvm() {
    vboxmanage list vms | awk '{ print $1 }' | tr -d '"' | fa vboxmanage startvm
}

# ftstate - show terraform state
# example usage: ftstate
ftstate() {
  local state
  state=$(terraform state list | fzf --tac +s +m -e --ansi --reverse)
  if [ -n "$state" ]; then
    terraform state show "$state"
  fi
}

# fni - install nix package
# example usage: fni <pkg>
fni() {
  local package
  local file
  #TODO https://github.com/NixOS/nix/issues/5642
  package=$(nix-env --meta --json -qa $1 | jq -r '[ keys[] as $k | [$k, .[$k].version, .[$k].meta.description] | @tsv ] | join("\n")' | column -ts $'\t' | fzf | cut -d' ' -f1)

  if [ -n "$package" ]; then
     nix-env -iA "$package"
  fi
}

# aws functions

fawslogs() {
  local group
  group=$(awslogs groups | fzf)
  if [ -n "$group" ]; then
      awslogs get $group --no-group --no-stream $@
  fi
}

fawsinstance() {
  local instance
  aws ec2 describe-instances --query "Reservations[*].Instances[*].{InstanceId:InstanceId,Name:Tags[?Key=='Name']|[0].Value,Environment:Tags[?Key=='environment']|[0].Value,Status:State.Name}" | jq -r '[ flatten[] | select(.Status=="running") ] | map([.InstanceId,.Name,.Environment] | @csv)[]' | sed 's/,,/,"",/g' | sed s/,/\\t/g | column -t | tr -d '"' | fzf | cut -d' ' -f1
}

fawsssh() {
  local instance
  instance=$(fawsinstance)
  if [ -n "$instance" ]; then
      ssh $instance
  fi
}

fawssecrets() {
    aws secretsmanager list-secrets | jq -r ".SecretList[] | [.Name,.Description] | @tsv" | fzf | cut -f 1 | xargs -I{} aws secretsmanager get-secret-value --secret-id {} --query "SecretString" | jq 'fromjson'
}


fawspassword() {
    fawssecrets | jq -r ".password" | head -n 1 | xclip
}

fpr() {
    gh pr checkout $(GH_FORCE_TTY='50%' gh pr list | fzf --ansi --header-lines 3 --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh pr view {1}; GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh pr checks {1}' | awk '{print $1}')
}

insertFileFromCurrentDir () {
  export DIR=$(mktemp)
  echo "." > "$DIR"

  files="$(\
  \ls -tr --color=always "$(cat "$DIR")" |
  fzf --tac --height 90% --reverse \
    --preview 'cat "$DIR" && echo "" && pistol "$(cat "$DIR")"/{} $FZF_PREVIEW_COLUMNS $FZF_PREVIEW_LINES' \
    --bind 'ctrl-d:preview-page-down' \
    --bind 'ctrl-a:select-all' \
    --bind 'ctrl-r:reload(\ls -tr --color=always "$(cat "$DIR")")'\
    --bind 'ctrl-g:execute(realpath "$(cat "$DIR")"/.. > "$DIR")+reload(\ls -tr --color=always "$(cat "$DIR")")+clear-query+deselect-all+first'\
    --bind 'ctrl-n:execute(realpath "$(cat "$DIR")"/{} > "$DIR")+reload(\ls -tr --color=always "$(cat "$DIR")")+clear-query+deselect-all+first' |
  awk '{system("realpath --relative-to=. \"$(cat \"'$DIR'\")/"$0"\"")}' |
  sed -e 's/\(.*\)/"\1"/' |
  tr '\n' ' ')"

  [[ -z "$files" ]] && return 0
  LBUFFER+="$files"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N insertFileFromCurrentDir

insertCommitHash () {
  gitlog=$(git log --color=always --pretty=format:'%Cred%h %C(reset)%C(dim)%ad%Creset %C(blue)%an%Creset %s%C(yellow)%d%C(reset) %Cgreen(%ar)%Creset' --abbrev-commit --date-order --date="format:%F %R")
  commits="$(echo -E $gitlog | fzf --no-sort --ansi --height 90% --reverse --preview "git show --color-words \$(echo {} | cut -d ' ' -f1)" | cut -d ' ' -f1 | tr '\n' ' ')"
  [[ -z "$commits" ]] && return 0
  LBUFFER+="$commits"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N insertCommitHash
