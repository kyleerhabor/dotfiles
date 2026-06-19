(vim.lsp.config "lua_ls" {"settings" {"Lua" {"diagnostics" {"globals" ["vim"]}}}})
(vim.lsp.config "fennel_ls" {"root_markers" [".nfnl.fnl"]
                             ;; https://git.sr.ht/~xerool/fennel-ls#default-settings
                             "init_options" {"fennel-ls" {"extra-globals" "vim"}}})

(vim.lsp.config "clangd" {})
(vim.lsp.enable "nixd")
