(local n (require "nfnl.core"))

(local mods ["config.option" "config.auto"
             "config.lsp"
             "config.plugin"]) ; ...

(n.run! require mods)
