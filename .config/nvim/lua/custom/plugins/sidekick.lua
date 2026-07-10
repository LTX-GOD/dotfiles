return {
	'folke/sidekick.nvim',
	keys = {
		{ '<leader>ac', function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end, desc = 'Sidekick: Toggle Claude' },
		{ '<leader>ax', function() require('sidekick.cli').toggle({ name = 'pi', focus = true }) end,     desc = 'Sidekick: Toggle pi' },

		{ '<leader>ap', function() require('sidekick.cli').prompt() end,                                  desc = 'Sidekick: Prompt library' },
		{ '<leader>av', function() require('sidekick.cli').prompt({ selection = true }) end,              mode = 'v',                       desc = 'Sidekick: Send selection' },
	},
	config = function()
		require('sidekick').setup {
			nes = { enabled = false }, -- 不用 Copilot NES
			cli = {
				picker = 'snacks',
				watch = true,
				tools = {
					claude = { cmd = { 'claude' } },
				},
				prompts = {
					audit   = 'Review {file} for security vulnerabilities. Focus on injection, deserialization, path traversal, and authentication issues. List each finding with severity and line number.',
					sink    = 'Analyze {this} as a potential sink. Is user-controlled data reaching it unsanitized? Trace the data flow and identify the source.',
					deser   = 'Check {this} for Java deserialization vulnerabilities. Look for ObjectInputStream, readObject, XMLDecoder, XStream, or similar. Is the input trusted?',
					sqli    = 'Check {this} for SQL injection. Is the query built with string concatenation? Is user input properly parameterized?',
					explain = 'Explain what {this} does in plain terms. Include the purpose, inputs, outputs, and any side effects.',
					trace   = 'Trace the data flow of user-controlled input in {file}. Where does it enter, how is it processed, and where does it exit or get used?',
				},
				win = {
					layout = 'right',
				},
				mux = { enabled = false },
			},
		}
	end,
}
