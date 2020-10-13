# -----------------------------
# Lang
# -----------------------------
#export LANG=ja_JP.UTF-8
#export LESSCHARSET=utf-8
# -----------------------------
# General
# -----------------------------
autoload -Uz colors ; colors

export EDITOR=code
setopt auto_pushd
setopt pushd_ignore_dups
setopt no_flow_control
setopt extended_glob
setopt auto_cd
#setopt auto_param_key
setopt auto_cd
setopt print_exit_value
setopt mark_dirs
setopt correct
setopt no_clobber
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
clear
echo "†Laminne's Parsonal Computer†\n"

PROMPT='%F{cyan}{%n} ♥ [%m]%f
%~ #>>'

# -----------------------------
# Completion
# -----------------------------
autoload -Uz compinit ; compinit

#setopt complete_in_word

setopt correct

zstyle ':completion:*' menu select

setopt list_packed

#setopt list_types

export LSCOLORS=Exfxcxdxbxegedabagacad

# 補完時の色設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

zstyle ':completion::complete:*' use-cache true

autoload -U colors ; colors ; zstyle ':completion:*' list-colors "${LS_COLORS}"
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*:manuals' separate-sections true

setopt magic_equal_subst

# -----------------------------
# History
# -----------------------------
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

setopt histignorealldups

setopt share_history

setopt hist_ignore_all_dups

alias h='fc -lt '%F %T' 1'

setopt hist_reduce_blanks

setopt inc_append_history

setopt hist_verify

#setopt hist_reduce_blanks

#setopt hist_save_no_dups

# -----------------------------
# Alias
# -----------------------------
alias -g grep='| grep'
alias -g gri='| grep -ri'

alias cnt='ls -ltr --color=auto'
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'

alias df="df -h"
alias root="su - "
alias so='source'
alias vi='vim'
alias zshrc='code ~/.zshrc'
alias c='cdr'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='c ../'
alias back='pushd'
alias diff='diff -U1'

# -----------------------------
# Plugin
# -----------------------------
#if [ $UID = 0 ]; then
#  unset HISTFILE
#  SAVEHIST=0
#fi

#function h {
#  history
#}

#function g() {
#  egrep -r "$1" .
#}



# # -----------------------------
# # Plugin
# # -----------------------------
# if [[ ! -d ~/.zplug ]];then
#   git clone https://github.com/zplug/zplug ~/.zplug
# fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/enhancd", use:init.sh
#zplug "junegunn/fzf-bin", as:command, from:gh-r, file:fzf

# if ! zplug check --verbose; then
#   printf "Install? [y/N]: "
#   if read -q; then
#       echo; zplug install
#   fi
# fi

 zplug load --verbose

# -----------------------------
# PATH
# -----------------------------
case "${OSTYPE}" in
  darwin*)
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH
  ;;
esac

# -----------------------------
# Python
# -----------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
alias pipallupgrade="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"

# -----------------------------
# Golang
# -----------------------------
if which go > /dev/null 2>&1  ; then
  export CGO_ENABLED=1
  export GOPATH=$HOME/dev/go
  export PATH=$PATH:$(go env GOROOT)/bin:$GOPATH/bin
fi

# -----------------------------
# Git
# -----------------------------
function gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -200'
}

function gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

function gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}