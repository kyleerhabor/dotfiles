(module config.autocmd
  {autoload {c config.core
             a aniseed.core
             str aniseed.string}
   import-macros [[{: augroup} :aniseed.macros.autocmds]]})

(def opt vim.opt)

;; By default, Commentary uses one colon. I prefer two.
(augroup "CommentaryLisp"
  [["FileType"] {"pattern" "clojure,fennel" ; Maybe just include every known lisp?
                 "callback" #(set opt.commentstring ";; %s")}])

(augroup "Completion"
  [["CompleteDone"] {"command" "pclose"}])

(defn on-mode-changed [name opts f]
  (augroup name
    [["ModeChanged"]
     (a.merge
       {"callback"
        (fn [aucmd]
          (set aucmd.modes (str.split aucmd.match ":"))
          (f aucmd))}
       opts)]))

;; This enables list mode when in normal mode (since it's annoying to get the trailing indicators in insert mode, and
;; likely won't be useful for other modes, like visual block)
(on-mode-changed "ListMode" {}
  (fn [{"modes" [_ mode]}]
    (set opt.list (and
                    (= "n" mode)
                    ;; In buffers that aren't modifiable (vimdoc/help, dependencies, etc.) it's annoying for list to be
                    ;; enabled on e.g. navigation (especially when tabs are used, since you get ^I, which righyfully
                    ;; looks ugly).
                    (opt.modifiable:get)))))

(augroup "HighlightYank"
  [["TextYankPost"] {"callback" #(vim.highlight.on_yank {"timeout" c.highlight-duration})}])
