;; Hide diagnostics from the sign column.
(tset vim "lsp" "handlers" "textDocument/publishDiagnostics"
  (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
    {"signs" false}))