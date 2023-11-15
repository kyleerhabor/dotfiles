(local {: setup} (require :nvim-treesitter.configs))

(setup {"ensure-installed" ["fennel" "lua"]
        "auto_install" false
        "highlight" {"enable" true}
        "incremental_selection" {"enable" true}
        "indent" {"enable" true}})
