
function lg() {
    git add --all
    git commit --signoff -a -m "$*"
    git push
}

function gpa()
{
git remote  | xargs -L1 -I R git push R $*
}
function clipcopy () {
pbcopy < "${1:-/dev/stdin}"
}
# use to import variables from .env file in local shell
function srcenv(){
export $(grep -v '^#' "$*" | xargs)
}

fuzzy_search() {
  context_lines=${1:-5}
  input=$(cat)
  selected_line=$(echo "$input" | awk -v context_lines=$context_lines 'BEGIN{ORS="\n\n"}{print NR-1 ":", $0}' | fzf --preview "echo {}; awk -v line=$(echo {} | cut -d':' -f1) -v context_lines=$context_lines 'NR >= line-context_lines && NR <= line+context_lines {print \$0}'" | cut -d':' -f1)
  awk -v line=$selected_line -v context_lines=$context_lines 'NR >= line-context_lines && NR <= line+context_lines {print $0}' <<< "$input" | less
}

function dklocal() {
    docker run --rm -it -v "${PWD}:/usr/workdir" --workdir=/usr/workdir "$@"
}
