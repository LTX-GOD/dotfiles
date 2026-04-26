
# ======================================================================
# Homebrew
# ======================================================================
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ======================================================================
# Environment
# ======================================================================
export GOROOT="/opt/homebrew/opt/go/libexec"
export GOPATH="$HOME/go"

export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"

export DOTNET_ROOT="$HOME/.dotnet"

# 自动探测 JAVA_HOME，避免空值污染 PATH
if [[ -z "$JAVA_HOME" && -x /usr/libexec/java_home ]]; then
  export JAVA_HOME="$("/usr/libexec/java_home" 2>/dev/null)"
fi

# ======================================================================
# PATH
# ======================================================================
typeset -U path PATH

path=(
  "$HOME/.cargo/bin"
  "$GOPATH/bin"
  "$GOROOT/bin"
  "$DOTNET_ROOT/tools"
  "/opt/metasploit-framework/bin"
  "/opt/homebrew/opt/llvm/bin"
  "/opt/homebrew/opt/maven/bin"
  "/Library/Frameworks/Python.framework/Versions/3.13/bin"
  "$HOME/.orbstack/shell/bin"
  $path
)

if [[ -n "$JAVA_HOME" ]]; then
  path=("$JAVA_HOME/bin" $path)
fi

export PATH

# ======================================================================
# uv
# ======================================================================
if [[ -r "$HOME/.local/bin/env" ]]; then
  . "$HOME/.local/bin/env"
fi

# ==============================================================================
# Homebrew mirrors
# ==============================================================================
# export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles/api"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
# export HOMEBREW_PIP_INDEX_URL="http://mirrors.aliyun.com/pypi/simple"
