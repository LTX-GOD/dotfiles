return {
  close_if_last_window = false, -- 如果neo-tree是最后一个窗口，不要关闭
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- 在这些缓冲区类型中打开文件时，不要使用neo-tree窗口
  sort_case_insensitive = false, -- 用于排序文件和目录
  sort_function = nil, -- 使用简单的字母排序
  default_component_configs = {
    container = {
      enable_character_fade = true
    },
    indent = {
      indent_size = 2,
      padding = 1, -- 额外的填充在缩进级别之间
      -- 缩进指南
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- 展开器配置，控制文件夹图标
      with_expanders = nil, -- 如果为nil且file_nesting启用，将启用展开器
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "󰜌",
      -- 下一个设置仅在您有lspkind安装时有效
      -- https://github.com/onsails/lspkind-nvim
      default = "*",
      highlight = "NeoTreeFileIcon"
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- 更改类型
        added     = "", -- 或"✚"，但这是多余的信息，如果您使用git_status_colors在名称上
        modified  = "", -- 或""，但这是多余的信息，如果您使用git_status_colors在名称上
        deleted   = "✖",-- 这只能用于已删除的文件，而不是文件夹。Git不跟踪文件夹。
        renamed   = "󰁕",-- 这只能用于已删除的文件，而不是文件夹。Git不跟踪文件夹。
        -- 状态类型
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
      }
    },
    -- 如果您不想使用这些列，可以将`enabled`设置为false
    file_size = {
      enabled = true,
      required_width = 64, -- 最小窗口宽度以显示此列
    },
    type = {
      enabled = true,
      required_width = 122, -- 最小窗口宽度以显示此列
    },
    last_modified = {
      enabled = true,
      required_width = 88, -- 最小窗口宽度以显示此列
    },
    created = {
      enabled = true,
      required_width = 110, -- 最小窗口宽度以显示此列
    },
    symlink_target = {
      enabled = false,
    },
  },
  -- 全局自定义命令，可以在任何源中运行（如果不被覆盖）
  commands = {},
  window = {
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = { 
          "toggle_node", 
          nowait = false, -- 禁用`nowait`，如果您有现有的组合键以这个键开头
      },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["<esc>"] = "cancel", -- 关闭预览或浮动neo-tree窗口
      ["<Tab>"] = function() vim.cmd("wincmd w") end, -- 切换到下一个窗口
      ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
      -- 阅读`# Preview Mode`了解更多信息
      ["l"] = "focus_preview",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      -- ["S"] = "split_with_window_picker",
      -- ["s"] = "vsplit_with_window_picker",
      ["t"] = "open_tabnew",
      -- ["<cr>"] = "open_drop",
      -- ["t"] = "open_tab_drop",
      ["w"] = "open_with_window_picker",
      --["P"] = "toggle_preview", -- 进入预览模式，显示当前节点的预览
      ["C"] = "close_node",
      -- ['C'] = 'close_all_subnodes',
      ["z"] = "close_all_nodes",
      --["Z"] = "expand_all_nodes",
      ["a"] = { 
        "add",
        -- 这个命令支持BASH样式的大括号展开：
        -- 1. 创建多个文件：touch {a,b,c}.txt
        -- 2. 创建嵌套目录：mkdir -p some/{nested,dirs}
        -- 3. 运行多个命令：git add . && git commit
        config = {
          show_path = "none" -- "none", "relative", "absolute"
        }
      },
      ["A"] = "add_directory", -- 也接受可选配置。
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- 接受可选配置。
      ["m"] = "move", -- 接受可选配置。
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
      ["i"] = "show_file_details",
    }
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = true, -- 当为true时，它们只是变暗而不是隐藏
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true, -- 仅在Windows上工作
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- 使用glob样式模式
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- 即使其他设置会隐藏它们，也保持这些文件可见
        --".gitignored",
      },
      never_show = { -- 即使visible为true，也保持这些文件隐藏
        --".DS_Store",
        --"thumbs.db"
      },
      never_show_by_pattern = { -- 使用glob样式模式
        --".null-ls_*",
      },
    },
    follow_current_file = {
      enabled = false, -- 这将找到并聚焦当前文件在neo-tree中，每当
                      -- 当前文件更改时。
      leave_dirs_open = false, -- `false`关闭自动展开的目录，如`true`保持打开
    },
    group_empty_dirs = false, -- 当为true时，空文件夹将被分组在一起
    hijack_netrw_behavior = "open_default", -- netrw禁用，打开默认目录，open_current，disabled
    use_libuv_file_watcher = false, -- 这将使用OS级别的文件观察器来检测更改
                                    -- 而不是依赖lsp文件观察器。
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- 模糊排序使用fzf算法
        -- ["D"] = "fuzzy_sorter_directory",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["og"] = { "order_by_git_status", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
      fuzzy_finder_mappings = { -- 定义在模糊查找器中使用的键
        ["<down>"] = "move_cursor_down",
        ["<C-n>"] = "move_cursor_down",
        ["<up>"] = "move_cursor_up",
        ["<C-p>"] = "move_cursor_up",
      },
    },

    commands = {} -- 添加自定义命令表，将在文件系统源中可用
  },
  -- 禁用 buffers 源，因为使用 bento.nvim 进行管理
  source_selector = {
    winbar = false,
    statusline = false,
    sources = {
        { source = "filesystem" },
        { source = "git_status" },
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"]  = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
        ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      }
    }
  }
}
