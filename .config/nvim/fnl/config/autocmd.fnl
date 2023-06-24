(module config.autocmd
  {import-macros [[{: augroup} "aniseed.macros.autocmds"]]})

(def opt vim.opt)

(augroup "CommentaryLisp"
  [["FileType"] {"pattern" "clojure,fennel" ; Maybe just include every known lisp?
                 "callback" #(set opt.commentstring ";; %s")}])

(augroup "Completion"
  [["CompleteDone"] {"command" "pclose"}])

;; This enables list mode when in normal mode (since it's annoying to get the trailing indicators in insert mode, and
;; likely won't be useful for other modes, like visual block)
(augroup "ListMode"
  [["ModeChanged"]
   {"callback"
    (fn [{:match modes}]
      (let [mode (string.sub modes -1)]
        (set opt.list (and
                        (= "n" mode)
                        ;; In buffers that aren't modifiable (vimdoc/help, dependencies, etc.) it's annoying for list to
                        ;; to be enabled on e.g. navigation (especially when tabs are used, since you get ^I, which
                        ;; righyfully looks ugly).
                        ;;
                        ;; NOTE: Maybe buftype suffices?
                        (opt.modifiable:get)))))}])
