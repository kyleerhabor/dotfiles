(local {: colorscheme} (require "config.core"))

(local name "gruvbox-material")

(when (= colorscheme name)
  (vim.cmd.colorscheme name))
