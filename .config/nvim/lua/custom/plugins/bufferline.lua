return {
	'akinsho/bufferline.nvim',
	event = 'VeryLazy',
	keys = {
		{ '[b',         '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
		{ ']b',         '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
		{ '<leader>bp', '<cmd>BufferLinePick<cr>',      desc = 'Pick buffer' },
		{ '<leader>bD', '<cmd>BufferLinePickClose<cr>', desc = 'Pick buffer to close' },
	},
	config = function()
		require('bufferline').setup {
			options = {
				mode = 'buffers',
				icon_pinned = '󰐃',
				offsets = {
					{
						filetype = 'neo-tree',
						text = 'File Explorer',
						highlight = 'Directory',
						text_align = 'left',
					},
				},
				diagnostics = 'nvim_lsp',
				diagnostics_indicator = function(_, _, diag)
					local icons = { error = ' ', warning = ' ' }
					local s = ''
					for level, icon in pairs(icons) do
						if diag[level] and diag[level] > 0 then
							s = s .. icon .. diag[level]
						end
					end
					return s
				end,
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = 'thin',
			},
		}
	end,
}
