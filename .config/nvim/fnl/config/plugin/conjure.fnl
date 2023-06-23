(module config.plugin.conjure
  {autoload {nvim aniseed.nvim}})

(set nvim.g.conjure#highlight#enabled true)
(set nvim.g.conjure#log#hud#border "rounded")
; (set nvim.g.conjure#client#clojure#nrepl#connection#auto_repl#hidden true)
(set nvim.g.conjure#client#clojure#nrepl#connection#auto_repl#enabled false)
(set nvim.g.conjure#log#strip_ansi_escape_sequences_line_limit 0)
