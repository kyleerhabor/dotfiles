(local ts (require "nvim-treesitter.configs"))

(ts.setup {"ensure_installed" ["python" "vim" "vimdoc" "lua" "fennel" "comment"]
           "highlight" {"enable" true}})
