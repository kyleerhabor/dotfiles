(local n (require :nfnl.core))
(local packer (require :packer))
(local {: prefix} (require :config.util))

(fn relative [s]
  (.. "config.plugin." s))

(fn plugin [spec]
  (if (= "table" (type spec))
    (prefix (n.first spec) (n.second spec))
    [spec]))

(fn load [plugins]
  (packer.startup
    (fn [use]
      (n.run!
        (fn [plug]
          (let [p (plugin plug)
                mod p.mod]
            (if mod
              (let [(ok err) (pcall require mod)]
                (if (not ok)
                  (print
                    (.. "Error requiring plugin module \"" (n.first p) "\":")
                    err))))
            (use p)))
        plugins))))

(local plugins ["wbthomason/packer.nvim"
                "Olical/nfnl"
                ["ggandor/leap.nvim" {"mod" (relative "leap")}]
                "romainl/vim-cool"
                ["guns/vim-sexp" {"mod" (relative "sexp")}]
                ["folke/which-key.nvim" {"mod" (relative "which-key")}]
                "clojure-vim/vim-jack-in"
                ["ellisonleao/glow.nvim" {"mod" (relative "glow")}]
                "ii14/lsp-command"
                "jghauser/mkdir.nvim"
                ["levouh/tint.nvim" {"mod" (relative "tint")}]
                ["sainnhe/gruvbox-material" {"mod" (relative "gruvbox-material")}]
                ["nvim-treesitter/nvim-treesitter" {"run" ":TSUpdate"
                                                    "mod" (relative "treesitter")}]
                ["m00qek/baleia.nvim" {"mod" (relative "baleia")}]
                "mvllow/modes.nvim"
                ["neovim/nvim-lspconfig" {"mod" (relative "lsp")}]
                ["Olical/conjure" {"mod" (relative "conjure")}]
                "radenling/vim-dispatch-neovim"
                "tpope/vim-characterize"
                "tpope/vim-commentary"
                "tpope/vim-dispatch"
                "tpope/vim-eunuch"
                "tpope/vim-fugitive"
                "tpope/vim-repeat"
                "tpope/vim-surround"
                "tpope/vim-vinegar"
                ["nvim-lualine/lualine.nvim" {"mod" (relative "lualine")}]
                "mfussenegger/nvim-jdtls"])

(load plugins)
