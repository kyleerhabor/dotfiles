(local {: prefix} (require "config.util"))
(local pckr (require "pckr"))

(pckr.add [;; Neovim
           (prefix "neovim/nvim-lspconfig" {"requires" ["williamboman/mason-lspconfig.nvim"]
                                            "config" "config.plugin.lspconfig"})
           (prefix "nvim-treesitter/nvim-treesitter" {"run" ":TSUpdate"
                                                      "config" "config.plugin.treesitter"})

           ;; etc.
           (prefix "folke/which-key.nvim" {"config" "config.plugin.which-key"
                                           "requires" ["nvim-tree/nvim-web-devicons"]})
           (prefix "nvim-tree/nvim-web-devicons" {})
           (prefix "Olical/conjure" {"config" "config.plugin.conjure"})
           (prefix "sainnhe/gruvbox-material" {"config" "config.plugin.gruvbox-material"})
           (prefix "nvim-lualine/lualine.nvim" {"requires" ["sainnhe/gruvbox-material" "nyoom-engineering/oxocarbon.nvim"]
                                                "config" "config.plugin.lualine"})
           (prefix "romainl/vim-cool" {})
           (prefix "nyoom-engineering/oxocarbon.nvim" {"config" "config.plugin.oxocarbon"})
           (prefix "tpope/vim-eunuch" {})
           ;; (prefix "vimpostor/vim-lumen" {"requires" ["nyoom-engineering/oxocarbon.nvim"
           ;;                                            "sainnhe/gruvbox-material"]
           ;;                                "config" "config.plugin.lumen"})
           (prefix "williamboman/mason.nvim" {"config" "config.plugin.mason"})
           (prefix "williamboman/mason-lspconfig.nvim" {"requires" ["williamboman/mason.nvim"]
                                                        "config" "config.plugin.mason-lspconfig"})])
