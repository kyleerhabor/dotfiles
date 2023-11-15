(local {: setup} (require :baleia))
(local {: command} (require :config.autocmd))
(local b (setup {"line_starts_at" 3}))

(command "BufWinEnter" "Baleia" {"callback" #(b.automatically (vim.fn.bufnr "%"))})
