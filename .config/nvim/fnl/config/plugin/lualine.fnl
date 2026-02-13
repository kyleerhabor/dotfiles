(local {: colorscheme
        : colorschemes} (require "config.colorscheme"))
(local {: prefix} (require "config.util"))
(local {: setup} (require "lualine"))

(local cscheme (. colorschemes colorscheme))

(setup {"options" {"theme" (cscheme.lualine_theme)
                   "icons_enabled" false
                   "globalstatus" true
		   "section_separators" {"left" "" "right" ""}}
        "sections" {"lualine_b" ["branch"
				 "diff"
				 (prefix "diagnostics" {"update_in_insert" true})]
	            "lualine_c" [(prefix "filename" {"path" 1})]
	            "lualine_x" ["filetype"]}})
