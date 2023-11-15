(local n (require :nfnl.core))
(local str (require :nfnl.string))
(local jdtls (require :jdtls))

(local path (str.trimr (vim.fn.system ["command" "-v" "jdtls"])))

(jdtls.start_or_attach {"cmd" [path]})
