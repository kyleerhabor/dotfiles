(module config.plugin.which-key
  {autoload {nvim aniseed.nvim
             : which-key}})

(set nvim.o.timeout true)
(set nvim.o.timeoutlen 0)

(which-key.setup {})
