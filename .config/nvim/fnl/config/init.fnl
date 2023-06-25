(module config.init
  {require [config.core
            config.option
            config.autocmd
            config.keymap
            config.plugin
            ;; Interestingly, having this loaded before plugins causes the background to not be loaded. I'm using
            ;; Neovide, so it doesn't really matter; but it is *kind of* annoying for environments like iTerm.
            config.colorscheme]})
