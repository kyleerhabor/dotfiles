(module config.autocmd
  {autoload {c config.core
             o config.option
             a aniseed.core
             str aniseed.string}
   import-macros [[{: augroup} :aniseed.macros.autocmds]]})

(def opt vim.opt)

;; When completion via <C-x><X-o> finishes, close the buffer.
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
  ;; I'd like yanks that happen in "true visual mode" to not be counted, but there doesn't seem to be a way to get the
  ;; mode before the yank.
  [["TextYankPost"] {"callback" #(vim.highlight.on_yank {"timeout" c.highlight-duration})}])

;; By default, Commentary uses one colon. I prefer two.
;;
;; TODO: Move this to a ftplugin.
(augroup "CommentaryLisp"
  [["FileType"] {"pattern" "clojure,fennel" ; Maybe just include every known lisp?
                 "callback" #(set opt.commentstring ";; %s")}])
