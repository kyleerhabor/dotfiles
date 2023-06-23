(module config.plugin.treesitter
  {autoload {a aniseed.core
             nvim aniseed.nvim
             ts nvim-treesitter.configs
             p nvim-treesitter.parsers}})

(nvim.set_hl 0 "@punctuation.bracket" {"link" ""}) ; Required for rainbow brackets.

(ts.setup {"ensure-installed" ["fennel" "lua"]
           "auto_install" false
           "highlight" {"enable" true
                        ;; This makes rainbow brackets work.
                        "additional_vim_regex_highlighting" true}
           "incremental_selection" {"enable" true}
           "indent" {"enable" true}})
           
           
