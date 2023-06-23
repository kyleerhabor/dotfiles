(module config.plugin
  {autoload {: packer}
   require {{: prefix} config.util}})

(defn relative [s]
  (.. *module-name* "." s))

(defn load [ps]
  (packer.startup
    (fn [use]
      (each [name opts (pairs ps)]
        (-?> opts.mod require)
        (use (prefix name opts))))))

;; For some reason, I can't use the config parameter.
(def plugins {;; From init.lua
              "wbthomason/packer.nvim" {}
              "Olical/aniseed" {}
              ;; The rest
              "andweeb/presence.nvim" {"mod" (relative "presence")}
              "clojure-vim/vim-jack-in" {}
              "ellisonleao/glow.nvim" {"mod" (relative "glow")}
              ;; "eraserhd/parinfer-rust" {"run" "cargo build --release"} ; I can't figure out how to use sexp effectively.
              "ii14/lsp-command" {}
              "jghauser/mkdir.nvim" {}
              "levouh/tint.nvim" {"mod" (relative "tint")}
              ;; I tried oxocarbon, but it:
              ;; - had no configuration
              ;; - had no lualine support
              ;; - had comments set too dark
              ;; - only partially works with tint on vimdoc
              "sainnhe/gruvbox-material" {"mod" (relative "gruvbox-material")}
              "nvim-treesitter/nvim-treesitter" {"run" ":TSUpdate"
                                                 "mod" (relative "treesitter")}
              "luochen1990/rainbow" {"mod" (relative "rainbow")} ; mrjones2014/nvim-ts-rainbow produces wrong colors sometimes.
              "m00qek/baleia.nvim" {"mod" (relative "baleia")}
              "neovim/nvim-lspconfig" {"mod" (relative "lsp")}
              "Olical/conjure" {"mod" (relative "conjure")}
              "radenling/vim-dispatch-neovim" {}
              ;; Maybe tpope/vim-endwise?
              "tpope/vim-characterize" {}
              "tpope/vim-commentary" {}
              "tpope/vim-dispatch" {}
              "tpope/vim-eunuch" {}
              "tpope/vim-fugitive" {}
              "tpope/vim-repeat" {}
              "tpope/vim-sleuth" {}
              "tpope/vim-surround" {}
              "tpope/vim-vinegar" {}
              "folke/which-key.nvim" {"mod" (relative "which-key")} ; For some reason, I need to click "g" before localleader (,) works.
              ;; I don't really like this (or status lines in general).
              "nvim-lualine/lualine.nvim" {"requires" [(prefix "kyazdani42/nvim-web-devicons" {"opt" true})]
                                           "mod" (relative "lualine")}})             

(load plugins)
