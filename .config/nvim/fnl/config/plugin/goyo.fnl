(module config.plugin.goyo
  {autoload {nvim aniseed.nvim
             : lualine}})

(nvim.create_autocmd "User" {"pattern" "GoyoEnter"
                             "callback" (fn [_]
                                          (lualine.hide))
                             "nested" true})

(nvim.create_autocmd "User" {"pattern" "GoyoLeave"
                             "callback" (fn [_]
                                          (lualine.hide {"unhide" true}))
                             "nested" true})
