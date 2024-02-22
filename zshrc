
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


### End of Zinit's installer chunk
#ZSH_THEME="agnoster" # (this is one of the fancy ones)
# style for fzf-tab
# # disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'


# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

## Zinit Setting
# Must Load OMZ Git library
# zinit snippet OMZL::git.zsh

# Load Git plugin from OMZ
zinit snippet OMZP::git
# zinit cdclear -q # <- forget completions provided up to this moment

autoload -Uz compinit
compinit

##setup history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY


zinit light junegunn/fzf
zinit light Aloxaf/fzf-tab
zinit for \
zdharma-continuum/fast-syntax-highlighting \
               # zdharma-continuum/history-search-multi-word \
               # marlonrichert/zsh-autocomplete 
   # light-mode zsh-users/zsh-autosuggestions  \

zinit load Dbz/kube-aliases
#zinit load ahmetb/kubectx
zinit load atuinsh/atuin
#source<(atuin gen-completions --shell zsh)


zinit from'gh-r' as'program' for \
    id-as'kubectx' bpick'kubectx*' ahmetb/kubectx \
    id-as'kubens' bpick'kubens*' ahmetb/kubectx \


#zinit ice depth=1
#zinit light jeffreytse/zsh-vi-mode

#setopt promptsubst

# Load Prompt
#zinit snippet OMZT::agnoster
###### PLUGINS ######
#zinit light spaceship-prompt/spaceship-prompt

#bindkey '^[[1;5C' forward-word 
#bindkey '^[[1;5D' backward-kill-word
#bindkey '^[^[[C' forward-word   #control left
#bindkey '^[^[[D' backward-kill-word

#aliases and functions
alias kb="kubectl"
alias res="source ~/.zshrc"
alias ls="exa"
alias htop="bpytop"
alias ping="gping"
alias du="dua"
alias dig="dog"
alias cat="bat"
alias rm="rip"
alias dklocal="docker run --rm -it -v ${PWD}:/usr/workdir --workdir=/usr/workdir"
alias python="python3"
eval $(thefuck --alias)
alias vim="nvim"
VAULT_ADDR=https://vault.smart-building.inovex.io
VAULT_TOKEN=s.tOn5oFLq6NGRwvGJcJS4oKWh
QI_SDK_PREFIX=~/tools/naoqi

# autojump
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS system
  [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
elif [[ -e /etc/os-release ]]; then
  # Source os-release to check for Arch Linux
  . /etc/os-release
  if [[ "$ID" == "arch" ]]; then
    # Arch Linux system
    [[ -s /etc/profile.d/autojump.zsh ]] && source /etc/profile.d/autojump.zsh
  fi
fi
source <(kubectl completion zsh)

if [[ "$(uname)" == "Darwin" ]]; then
    ssh-add --apple-use-keychain ~/.ssh/id_rsa 
elif [[ "$(uname)" == "Linux" ]]; then
    echo "This is a Linux system."
else
    echo "This is neither Mac nor Linux."
fi



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


# export PATH="/opt/homebrew/anaconda3/bin:$PATH"  # commented out by conda initialize
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


eval "$(starship init zsh)"

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
export PATH=$PATH:$HOME/.rustup
export PATH=$PATH:$HOME/.cargo
export PATH=$PATH:$HOME/.cargo/bin


export PATH=$PATH:$HOME/Tools
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export K9S_EDITOR=nvim
export EDITOR=nvim
export PICO_SDK_PATH="$HOME/Private/Development/embedded/pico-sdk"

eval "$(atuin init zsh)"
