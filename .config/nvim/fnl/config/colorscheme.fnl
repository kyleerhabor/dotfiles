(module config.colorscheme)

(if (not= "Apple_Terminal" vim.env.TERM_PROGRAM)
  (set vim.opt.termguicolors true))

(vim.cmd "colorscheme gruvbox-material")
