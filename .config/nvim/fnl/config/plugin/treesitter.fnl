(local ts (require "nvim-treesitter.configs"))

(ts.setup {"ensure_installed" ["vim" "vimdoc" "lua" "fennel"]
	   "highlight" {"enable" true}})
