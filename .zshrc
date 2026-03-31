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
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Zsh 插件
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/history-search-multi-word

# The Fuck (按需加载)
zinit ice lucid wait'0' atinit'eval "$(thefuck --alias)"'
zinit light "zdharma-continuum/null"

# Rust
source "$HOME/.cargo/env"

# OrbStack
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

export EDITOR=nvim
# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

source /Users/zsm/.config/color.sh

# Starship Prompt
eval "$(starship init zsh)"

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
setopt appendhistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups

# uv
. "$HOME/.local/bin/env"
export PATH="$HOME/.cargo/bin:$PATH"

autoload -Uz compinit
compinit
eval "$(uv generate-shell-completion zsh)"

# tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# nvim->vim
alias vim='nvim'

# 使用 gls (coreutils)
alias ls='gls --color=auto'

# jvav
alias jvav='java'

# ssh
alias ssh='kitten ssh'

# john
export PATH="$PATH:/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/"

# flask-session-cookie-manager
flask_session_cookie_manager(){
  uv run ~/CTF/tool/uv-web/flask-session-cookie-manager/.venv/bin/python3 ~/CTF/tool/uv-web/flask-session-cookie-manager/flask_session_cookie_manager3.py "$@"
} 

# ghauri
ghauri() {
  uv run ~/CTF/tool/uv-web/ghauri/.venv/bin/ghauri "$@"
}

# GitHack
Githack() {
  uv run ~/CTF/tool/uv-web/GitHack/.venv/bin/python3 ~/CTF/tool/uv-web/GitHack/GitHack.py "$@"
}

# PyGlimmer
PyGlimmer() {
  uv run ~/CTF/tool/uv-web/PyGlimmer/.venv/bin/python3 ~/CTF/tool/uv-web/PyGlimmer/PyGlimmer.py "$@"
}

# pycdc
export PATH="/Users/zsm/CTF/tool/pycdc/build:$PATH"

# SMScan
export PATH="/Users/zsm/CTF/tool/SMScan:$PATH"

# WASM反编译
export PATH="/Users/zsm/CTF/tool/wabt-1.0.39:$PATH"

# java8
alias java8="/Users/zsm/CTF/tool/jdk8/bin/java"

# java11
alias java11="/Users/zsm/CTF/tool/jdk11/bin/java"

# 代理
proxy() { 
  export http_proxy="http://127.0.0.1:7897"; export https_proxy="http://127.0.0.1:7897"; export all_proxy="socks5://127.0.0.1:7897"; 
} 
unproxy() { 
  unset http_proxy; unset https_proxy; unset all_proxy; 
}

# bun completions
[ -s "/Users/zsm/.bun/_bun" ] && source "/Users/zsm/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export OSU_MODELS_DIR="/Volumes/AI/osaurus"
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"

