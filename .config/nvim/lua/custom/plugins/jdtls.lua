return {
	'mfussenegger/nvim-jdtls',
	ft = 'java',
	config = function()
		local function start_jdtls()
			local mason_pkg = vim.fn.stdpath('data') .. '/mason/packages'
			-- jdtls 通过 brew 安装，绕过 Eclipse 下载服务器被墙问题
			local jdtls_path = '/opt/homebrew/opt/jdtls/libexec'
			local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
			local os_cfg = vim.fn.has('mac') == 1 and 'config_mac'
				or vim.fn.has('win32') == 1 and 'config_win'
				or 'config_linux'

			-- 用完整路径生成 workspace 名，避免同名目录的项目共享 workspace 互相污染
			local project_name = vim.fn.getcwd():gsub('[/\\:]', '_')
			local workspace = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

			local bundles = vim.split(
				vim.fn.glob(
					mason_pkg .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar',
					true
				),
				'\n',
				{ trimempty = true }
			)

			-- java-test bundle：让 jdtls 支持运行/调试单个测试方法与测试类
			vim.list_extend(
				bundles,
				vim.split(
					vim.fn.glob(mason_pkg .. '/java-test/extension/server/*.jar', true),
					'\n',
					{ trimempty = true }
				)
			)

			local capabilities = require('blink.cmp').get_lsp_capabilities()

			require('jdtls').start_or_attach {
				cmd = {
					'java',
					'-Declipse.application=org.eclipse.jdt.ls.core.id1',
					'-Dosgi.bundles.defaultStartLevel=4',
					'-Declipse.product=org.eclipse.jdt.ls.core.product',
					'-Dlog.protocol=true',
					'-Dlog.level=ALL',
					'-Xmx1g',
					'--add-modules=ALL-SYSTEM',
					'--add-opens', 'java.base/java.util=ALL-UNNAMED',
					'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
					'-jar', launcher,
					'-configuration', jdtls_path .. '/' .. os_cfg,
					'-data', workspace,
				},
				root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					-- nvim-dap / dap-ui 是懒加载的，此处强制加载，否则 setup_dap 会静默失败
					-- （nvim-jdtls 的 setup_dap 内部用 pcall 保护 require('dap')），
					-- 且 dap-ui 的自动开关监听器需要其 config 运行后才存在
					require('custom.pack').load('nvim-dap')
					require('custom.pack').load('nvim-dap-ui')
					require('jdtls').setup_dap { hotcodereplace = 'auto' }

					local map = function(keys, fn, desc)
						vim.keymap.set('n', keys, fn, { buffer = bufnr, desc = desc })
					end

					-- 发现主类并启动调试（带反馈与重试）
					local function refresh_and_debug(attempt)
						attempt = attempt or 1
						require('jdtls.dap').setup_dap_main_class_configs {
							verbose = true,
							on_ready = function()
								local configs = require('dap').configurations.java or {}
								if #configs > 0 then
									vim.notify('找到 ' .. #configs .. ' 个主类，启动调试', vim.log.levels.INFO)
									require('dap').continue()
								elseif attempt < 5 then
									-- jdtls 还在导入项目，稍后重试
									vim.notify('jdtls 仍在导入项目，重试 ' .. attempt .. '/5…', vim.log.levels.WARN)
									vim.defer_fn(function() refresh_and_debug(attempt + 1) end, 2000)
								else
									vim.notify(
										'未发现主类。确认：1) 类有 main 方法 2) 已 mvn compile 3) jdtls 完成项目导入',
										vim.log.levels.ERROR
									)
								end
							end,
						}
					end

					-- 启动后首次自动发现主类
					vim.defer_fn(function()
						require('jdtls.dap').setup_dap_main_class_configs()
					end, 3000)

					-- 刷新主类配置后启动调试
					map('<leader>dJ', function()
						refresh_and_debug()
					end, 'Java: 刷新主类并启动调试')

					-- Java buffer 内 <F5> 也走主类刷新逻辑（仅当配置为空时）
					map('<F5>', function()
						local configs = require('dap').configurations.java or {}
						if #configs > 0 then
							require('dap').continue()
						else
							refresh_and_debug()
						end
					end, 'DAP: Continue (Java)')

					-- 运行光标所在的单个测试方法
					map('<leader>jt', function()
						require('jdtls').test_nearest_method()
					end, 'Java: 测试光标处方法')

					-- 运行当前文件的整个测试类
					map('<leader>jT', function()
						require('jdtls').test_class()
					end, 'Java: 测试当前类')

					-- 运行 Spring Boot 项目
					map('<leader>jr', function()
						local root = vim.fs.root(0, { 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' })
						if not root then
							vim.notify('未找到 Spring Boot 项目根目录', vim.log.levels.ERROR)
							return
						end
						local cmd
						if vim.uv.fs_stat(root .. '/mvnw') then
							cmd = 'chmod +x mvnw && ./mvnw spring-boot:run'
						elseif vim.uv.fs_stat(root .. '/gradlew') then
							cmd = 'chmod +x gradlew && ./gradlew bootRun'
						elseif vim.uv.fs_stat(root .. '/pom.xml') then
							cmd = 'mvn spring-boot:run'
						else
							cmd = 'gradle bootRun'
						end
						require('snacks').terminal(cmd, { cwd = root })
					end, 'Java: 运行 Spring Boot')
				end,
				settings = {
					java = {
						format = { enabled = true },
						saveActions = { organizeImports = true },
					},
				},
				init_options = { bundles = bundles },
			}
		end

		vim.api.nvim_create_autocmd('FileType', {
			pattern = 'java',
			callback = start_jdtls,
		})

		-- config 由第一个 java buffer 的 FileType 事件触发，此时事件已结束，
		-- 需直接调用一次以启动当前 buffer 的 jdtls
		if vim.bo.filetype == 'java' then
			start_jdtls()
		end
	end,
}
