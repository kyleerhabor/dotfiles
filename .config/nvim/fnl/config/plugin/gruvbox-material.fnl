(local {: colorscheme} (require "config/core"))

(when (= "gruvbox-material" colorscheme)
  (vim.cmd "colorscheme gruvbox-material"))
