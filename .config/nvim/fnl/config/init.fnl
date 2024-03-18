(local n (require :nfnl.core))
(local core [:config.core
             :config.option
             :config.mapping
             :config.autocmd])

(local editor
  ;; [:config.plugin :config.colorscheme]
  ;; Interestingly, when the plugins are loaded before the colorscheme, the background color is not used. For Neovide,
  ;; it doesn't matter (since there's no background), but for others (iTerm, git commit in a terminal, etc.), it does.
  (if vim.g.neovide
    [:config.plugin :config.colorscheme]
    [:config.colorscheme :config.plugin]))

(n.run! require (n.concat core editor))
