
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

##setup history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY

zinit for \
    light-mode zsh-users/zsh-autosuggestions  \
zdharma-continuum/fast-syntax-highlighting \
                zdharma-continuum/history-search-multi-word \
                marlonrichert/zsh-autocomplete 

zinit light junegunn/fzf
zinit load Dbz/kube-aliases
#zinit load ahmetb/kubectx


zinit from'gh-r' as'program' for \
    id-as'kubectx' bpick'kubectx*' ahmetb/kubectx \
    id-as'kubens' bpick'kubens*' ahmetb/kubectx \

#ZSH_THEME="agnoster" # (this is one of the fancy ones)



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
#zinit snippet OMZL::git.zsh

# Load Git plugin from OMZ
#zinit snippet OMZP::git
#zinit cdclear -q # <- forget completions provided up to this moment

#setopt promptsubst

# Load Prompt
#zinit snippet OMZT::agnoster
###### PLUGINS ######
#zinit light spaceship-prompt/spaceship-prompt

bindkey '^[[1;5C' forward-word 
bindkey '^[[1;5D' backward-kill-word
bindkey '^[^[[C' forward-word   #control left
bindkey '^[^[[D' backward-kill-word


#aliases and functions
alias kb="kubectl"
alias res="source ~/.zshrc"
alias ls="lsd -A"
# alias cat="batcat"
alias dklocal="docker run --rm -it -v ${PWD}:/usr/workdir --workdir=/usr/workdir"

K9S_EDITOR=nano
VAULT_ADDR=https://vault.smart-building.inovex.io
VAULT_TOKEN=s.tOn5oFLq6NGRwvGJcJS4oKWh
QI_SDK_PREFIX=~/tools/naoqi

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
source <(kubectl completion zsh)


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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/burban/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/burban/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/burban/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/burban/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


eval "$(starship init zsh)"

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
