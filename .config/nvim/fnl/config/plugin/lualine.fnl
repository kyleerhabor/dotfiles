(module config.plugin.lualine
  {autoload {: lualine}
   require {{: prefix} config.util}})

(lualine.setup {"options" {"theme" "gruvbox-material"
                           "globalstatus" true}
                "sections" {"lualine_b" ["branch"
                                         "diff"
                                         (prefix "diagnostics" {"update_in_insert" true})]
                            "lualine_c" [(prefix "filename" {"path" 1})]
                            "lualine_x" ["filetype"]}
                "tabline" {}})
