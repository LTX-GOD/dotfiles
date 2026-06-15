return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'Avante' },
    config = function()
      require 'custom.config.render-markdown'
    end,
  },
  {
    'bullets-vim/bullets.vim',
    ft = { 'markdown' },
  },
  {
    'HakonHarnes/img-clip.nvim',
    ft = { 'markdown' },
    opts = {
      default = {
        dir_path = './attachments',
        use_absolute_path = false,
        copy_images = true,
        prompt_for_file_name = false,
        file_name = '%y%m%d-%H%M%S',
        extension = 'webp',
        process_cmd = 'magick png:- -quality 80 webp:-',
      },
      filetypes = {
        markdown = {
          template = '![image$CURSOR]($FILE_PATH)',
        },
        tex = {
          dir_path = './figs',
          extension = 'png',
          process_cmd = '',
          template = [[
    \begin{figure}[h]
      \centering
      \includegraphics[width=0.8\textwidth]{$FILE_PATH}
    \end{figure}
        ]],
        },
        typst = {
          dir_path = './figs',
          extension = 'png',
          process_cmd = 'magick convert - -density 300 png:-',
          template = [[
          #align(center)[#image("$FILE_PATH", height: auto)]
          ]],
        },
      },
    },
    keys = {
      {
        '<leader>P',
        '<cmd>PasteImage<cr>',
        desc = 'Paste image from system clipboard',
      },
    },
  },
}
