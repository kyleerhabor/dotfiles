(module config.plugin.baleia
  {autoload {nvim aniseed.nvim
             : baleia}})

(let [b (baleia.setup {"line_starts_at" 3})]
  (nvim.create_autocmd "BufWinEnter" {"pattern" "conjure-log-*"
                                      "callback" (fn [_]
                                                   (b.automatically (nvim.fn.bufnr "%")))}))
