(local {: setup} (require :lualine))
(local {: prefix} (require :config.util))

(setup {"options" {"theme" "gruvbox-material"
        "globalstatus" true
        "icons_enabled" true}
        "sections" {"lualine_b" ["branch"
                                 "diff"
                                 (prefix "diagnostics" {"update_in_insert" true})]
        "lualine_c" [(prefix "filename" {"path" 1})]
        "lualine_x" ["filetype"]}
        "tabline" {"lualine_z" [(prefix "tabs" {;; Only display tabs when there are multiple.
                                                "cond" #(< 1 (vim.fn.tabpagenr "$"))})]}})
