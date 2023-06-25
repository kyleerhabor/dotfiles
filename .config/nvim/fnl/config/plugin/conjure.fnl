(module config.plugin.conjure
  {autoload {c config.core}})

;; NOTE: I don't like how conjure#eval#inline#highlight uses comment as its highlight group, since I personally don't
;; interpret it like one.

augroup

(set vim.g.conjure#client#clojure#nrepl#connection#auto_repl#enabled false)
(set vim.g.conjure#eval#inline#highlight "InlineEvaluationResult")
(set vim.g.conjure#highlight#enabled true)
(set vim.g.conjure#highlight#timeout c.highlight-duration)
(set vim.g.conjure#log#hud#enabled false)
(set vim.g.conjure#log#hud#border "rounded")
(set vim.g.conjure#log#strip_ansi_escape_sequences_line_limit 0)
