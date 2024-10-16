(local lspconfig (require "lspconfig"))

(lspconfig.lua_ls.setup {"settings" {"Lua" {"diagnostics" {"globals" ["vim"]}}}})
(lspconfig.fennel_ls.setup {"root_dir" (lspconfig.util.root_pattern ".nfnl.fnl")
                            ;; https://git.sr.ht/~xerool/fennel-ls#default-settings
                            "init_options" {"fennel-ls" {"extra-globals" "vim"}}})

(lspconfig.clangd.setup {})
