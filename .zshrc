# ---------- Zinit ----------
if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  print -P "%F{33}%F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-
continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" &&
  command chmod g-rwX "$HOME/.local/share/zinit" &&
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" &&
  print -P "%F{33}%F{34}Installation successful.%f%b" ||
  print -P "%F{160}The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/history-search-multi-word

zinit light zdharma-continuum/null

# ---------- Env ----------
export EDITOR="nvim"
export UVWEB_DIR="$HOME/CTF/tool/uv-web"
export OSU_MODELS_DIR="/Volumes/AI/osaurus"
eval "$(fnm env --use-on-cd --shell zsh)"
# PATH 去重
typeset -U path PATH

[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
[[ -r "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"
[[ -r "/Users/zsm/.config/color.sh" ]] && source "/Users/zsm/.config/color.sh"

path=(
  "$HOME/.cargo/bin"
  "$BUN_INSTALL/bin"
  "$HOME/.gem/ruby/2.6.0/bin"
  "/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john"
  "/Users/zsm/CTF/tool/pycdc/build"
  "/Users/zsm/CTF/tool/SMScan"
  "/Users/zsm/CTF/tool/wabt-1.0.39"
  $path
)
export PATH

# ---------- Prompt ----------
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# ---------- History ----------
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# ---------- Completion ----------
autoload -Uz compinit
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

if (( $+commands[uv] )); then
  _uv_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/uv"
  _uv_comp_file="$_uv_cache_dir/completion.zsh"
  mkdir -p "$_uv_cache_dir"
  [[ -s "$_uv_comp_file" ]] || uv generate-shell-completion zsh >| "$_uv_comp_file"
  source "$_uv_comp_file"
fi

# ---------- Functions ----------
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return 1
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

uvweb() {
  (
    cd "$UVWEB_DIR" || return 1
    uv run "$@"
  )
}

proxy() {
  export http_proxy="http://127.0.0.1:7897"
  export https_proxy="http://127.0.0.1:7897"
  export all_proxy="socks5://127.0.0.1:7897"
}

unproxy() {
  unset http_proxy
  unset https_proxy
  unset all_proxy
}

# ---------- Aliases ----------
alias vim='nvim'
alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'

(( $+commands[gls] )) && alias ls='gls --color=auto'
(( $+commands[kitten] )) && alias ssh='kitten ssh'

alias java8='/Users/zsm/CTF/tool/jdk8/bin/java'
alias java11='/Users/zsm/CTF/tool/jdk11/bin/java'
alias fscan='/Users/zsm/CTF/tool/main'

alias oneforall='uvweb OneForAll/oneforall.py'
alias onebrute='uvweb OneForAll/brute.py'
alias onetake='uvweb OneForAll/takeover.py'
alias oneexport='uvweb OneForAll/export.py'
alias githack='uvweb GitHack/GitHack.py'
alias pyglimmer='uvweb PyGlimmer/PyGlimmer.py'
alias fscm='uvweb flask-session-cookie-manager/flask_session_cookie_manager3.py'
alias fscm2='uvweb flask-session-cookie-manager/flask_session_cookie_manager2.py'
alias jjs='uvweb jjjjjjjjjjjjjs/jjjjjjjjjjjjjs.py'
alias burp='cd "/Applications/Burp Suite Professional.app/Contents/Resources/app" && "/Applications/Burp Suite Professional.app/Contents/Resources/jre.bundle/Contents/Home/bin/java" -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+IgnoreUnrecognizedVMOptions -javaagent:BurpKeygenCN.jar=hanzify --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED -Dfile.encoding=UTF-8 -noverify --enable-native-access=ALL-UNNAMED -jar burpsuite_pro.jar'
alias ghidra='/opt/homebrew/opt/ghidra/bin/ghidraRun'


# pnpm
export PNPM_HOME="/Users/zsm/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;; # 注意这里增加了 /bin
  *) export PATH="$PNPM_HOME/bin:$PATH" ;; # 确保 bin 目录在最前面
esac
# pnpm end
