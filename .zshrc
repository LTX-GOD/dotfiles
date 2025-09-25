# ==============================================================================
# Zinit 插件管理器
# ==============================================================================
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

### End of Zinit's installer chunk

# ==============================================================================
# 语言环境初始化 (交互式部分)
# ==============================================================================

# Rust
source "$HOME/.cargo/env"

# OrbStack
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

# ==============================================================================
# 别名和函数 (ALIASES & FUNCTIONS)
# ==============================================================================
export EDITOR=nvim
# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ==============================================================================
# Shell 外观和历史记录
# ==============================================================================
# ls高亮
source /Users/zsm/.config/color.sh

# Starship Prompt
eval "$(starship init zsh)"

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
setopt appendhistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups


# tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# nvim->vim
alias vim='nvim'

# CTF 工具
alias cyber='open -a "Safari" /Users/zsm/CTF/tool/CyberChef_v10/CyberChef_v10.19.4.html'
alias pycdc='/Users/zsm/CTF/tool/pycdc/build/pycdc'

# 使用 gls (coreutils)
alias ls='gls --color=auto'

# uv
. "$HOME/.local/bin/env"
export PATH="$HOME/.cargo/bin:$PATH"

autoload -Uz compinit
compinit
eval "$(uv generate-shell-completion zsh)"
