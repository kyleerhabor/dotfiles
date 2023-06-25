(module config.plugin.treesitter
  {autoload {ts nvim-treesitter.configs}})

(ts.setup {"ensure-installed" ["fennel" "lua"]
           "auto_install" false
           "highlight" {"enable" true}
           "incremental_selection" {"enable" true}
           "indent" {"enable" true}})
