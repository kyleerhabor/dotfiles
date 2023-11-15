(local n (require :nfnl.core))
(local str (require :nfnl.string))
(local {: highlight} (require :config.core))
(local {: list} (require :config.util))
(local opt vim.opt)

(fn group [name]
  (vim.api.nvim_create_augroup name {}))

(fn command [name gr options]
  (vim.api.nvim_create_autocmd name
    (n.merge {"group" (group gr)}
      options)))

;; When completion via <C-x><X-o> finishes, close the buffer.
(vim.api.nvim_create_autocmd "CompleteDone" {"group" (group "Completion")
                                             "command" "pclose"})

;; This enables list mode when in normal mode (since it's annoying to get the trailing indicators in insert mode, and
;; likely won't be useful for other modes, like visual block)
(vim.api.nvim_create_autocmd "ModeChanged"
  {"group" (group "ListMode")
   "callback" (fn [aucmd]
                (let [mode (n.second (str.split aucmd.match ":"))]
                  (set opt.list (and
                                  (= "n" mode)
                                  ;; In buffers that aren't modifiable (vimdoc/help, dependencies, etc.) it's annoying
                                  ;; for list to be enabled on e.g. navigation (especially when tabs are used, since you
                                  ;; get ^I, which righyfully looks ugly).
                                  (opt.modifiable:get)))))})

(vim.api.nvim_create_autocmd "TextYankPost"
                             {"group" (group "HighlightYank")
                              ;; I'd prefer yanks that happen in "true visual mode" to not be highlighted, but there
                              ;; doesn't seem to be a way to get the mode before the yank.
                              "callback" #(vim.highlight.on_yank {"timeout" highlight})})

;; By default, Commentary uses one colon. I prefer two.
;;
;; TODO: Move this into a ftplugin.
(vim.api.nvim_create_autocmd "FileType"
                             {"group" (group "CommentaryLisp")
                              "pattern" (list ["clojure" "fennel"])
                              "callback" #(set opt.commentstring ";; %s")})

{:command command}
