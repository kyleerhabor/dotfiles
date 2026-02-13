(local lspconfig (require "lspconfig"))

(vim.lsp.config "lua_ls" {"settings" {"Lua" {"diagnostics" {"globals" ["vim"]}}}})
(vim.lsp.config "fennel_ls" {"root_dir" (lspconfig.util.root_pattern ".nfnl.fnl")
                             ;; https://git.sr.ht/~xerool/fennel-ls#default-settings
                             "init_options" {"fennel-ls" {"extra-globals" "vim"}}})

(vim.lsp.config "clangd" {})
