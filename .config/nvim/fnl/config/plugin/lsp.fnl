(local lsp (require :lspconfig))

(lsp.lua_ls.setup {"settings" {"Lua" {"runtime" {"version" "LuaJIT"}
                                      "diagnostics" {"globals" ["vim"]}
                                      "workspace" {"library" (vim.api.nvim_get_runtime_file "" false)}
                                      "telementry" {"enable" false}}}})

(lsp.clojure_lsp.setup {})
(lsp.sourcekit.setup {"root_dir" #(vim.fn.getcwd)})
