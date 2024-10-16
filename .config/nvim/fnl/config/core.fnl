(local {: term-apple} (require "config.util"))
(local n (require "nfnl.core"))

(local colorscheme
  (if (= term-apple vim.env.TERM_PROGRAM)
    "gruvbox-material"
    ;; Despite what the README says, oxocarbon requires termguicolors to function well.
    "oxocarbon"))

(fn oxocarbon-lualine-theme []
  (local {: oxocarbon} (require "oxocarbon"))

  (n.assoc-in (require "lualine.themes.oxocarbon") ["normal" "c" "bg"] oxocarbon.none))

{"colorscheme" colorscheme
 "colorschemes" {"gruvbox-material" {"lualine_theme" (n.constantly "auto")}
                 "oxocarbon" {"lualine_theme" oxocarbon-lualine-theme}}
 "highlight" 500}
