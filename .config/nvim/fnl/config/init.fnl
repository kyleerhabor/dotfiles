(module config.init
  {autoload {a aniseed.core}
   require [config.core
            config.option
            config.autocmd
            config.keymap]})

(def mods
  ;; Interestingly, when the plugins are loaded before the colorscheme, the background color is not used. For Neovide,
  ;; it doesn't matter (since there's no background), but for others (iTerm, git commit in a terminal, etc.), it does.
  (if vim.g.neovide
    [:config.plugin :config.colorscheme]
    [:config.colorscheme :config.plugin]))

(a.run! require mods)
