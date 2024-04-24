(local n (require "nfnl.core"))

(local highlight 500)

(fn group [name]
  (vim.api.nvim_create_augroup name {}))

(fn command [name group options]
  (vim.api.nvim_create_autocmd name
    (n.merge {"group" group}
      options)))

(command "TextYankPost" (group "HighlightYank")
  {"callback" #(vim.highlight.on_yank {"timeout" highlight})})

;; (command "ModeChanged" (group "ListMode")
;;   {"callback" (fn [autocmd]
;;                 )})

(command "LspAttach" (group "Lsp")
  {"callback" #(vim.keymap.set "n" "<LocalLeader>pr" vim.lsp.buf.rename {"buffer" $.buf})})

;; (vim.api.nvim_create_autocmd "ModeChanged"
;;   {"group" (group "ListMode")
;;    "callback" (fn [aucmd]
;;                 (let [mode (n.second (str.split aucmd.match ":"))]
;;                   (set opt.list (and
;;                                   (= "n" mode)
;;                                   ;; In buffers that aren't modifiable (vimdoc/help, dependencies, etc.) it's annoying
;;                                   ;; for list to be enabled on e.g. navigation (especially when tabs are used, since you
;;                                   ;; get ^I, which righyfully looks ugly).
;;                                   (opt.modifiable:get)))))})
