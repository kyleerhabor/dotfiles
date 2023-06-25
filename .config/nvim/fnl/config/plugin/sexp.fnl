(module config.plugin.sexp
  {autoload {str aniseed.string}})

(set vim.g.sexp_filetypes (str.join "," ["clojure" "fennel"]))
