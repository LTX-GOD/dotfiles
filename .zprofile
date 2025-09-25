eval "$(/opt/homebrew/bin/brew shellenv)"
# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"

# Go
# 避免硬编码，让 brew 的 symlink 来管理 GOROOT
export GOROOT="$(brew --prefix go)/libexec"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin" 
# Rust (使用国内镜像)
export RUSTUP_DIST_SERVER='https://mirrors.ustc.edu.cn/rust-static'
export RUSTUP_UPDATE_ROOT='https://mirrors.ustc.edu.cn/rust-static/rustup'

# c#.net
export PATH="$PATH:/Users/zsm/.dotnet/tools"

# ==============================================================================
# PATH 管理 (集中处理，自动去重)
# ==============================================================================

# 使用 Zsh 的 typeset -U 来自动去重 path 数组
typeset -U path

# Homebrew (最先加载，确保 brew 命令可用)
# 只执行一次，并用引号保护
eval "$(/opt/homebrew/bin/brew shellenv)"

# 添加其他路径到 path 数组中
# 数组的顺序就是 PATH 的优先级顺序
path=(
  # Pyenv & Cargo 会由各自的 init 脚本处理，但可以预先加载以防万一
  "$HOME/.cargo/bin"

  # Go
  "$GOPATH/bin"
  "$GOROOT/bin"
  
  # Homebrew 安装的其他软件 (使用 opt 路径)
  "/opt/homebrew/opt/node@22/bin"
  "/opt/homebrew/opt/llvm/bin"
  "$(brew --prefix maven)/bin" # 使用 brew --prefix 自动获取路径

  # 系统自带路径
  "$JAVA_HOME/bin"
  "/Library/Frameworks/Python.framework/Versions/3.13/bin"

  # OrbStack
  "$HOME/.orbstack/shell/bin"
  
  # 必须保留在最后
  $path
)
# uv
. "$HOME/.local/bin/env"

# ==============================================================================
# Homebrew 镜像设置
# ==============================================================================
export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
export HOMEBREW_PIP_INDEX_URL="http://mirrors.aliyun.com/pypi/simple"



