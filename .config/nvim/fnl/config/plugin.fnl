(local {: prefix} (require "config.util"))
(local pckr (require "pckr"))

(pckr.add [(prefix "neovim/nvim-lspconfig" {"requires" ["williamboman/mason-lspconfig.nvim"]
                                            "config" "config.plugin.lspconfig"})
           (prefix "nvim-treesitter/nvim-treesitter" {"run" ":TSUpdate"
                                                      "config" "config.plugin.treesitter"})
           
           (prefix "Olical/conjure" {"config" "config.plugin.conjure"})
           (prefix "folke/which-key.nvim" {"config" "config.plugin.which-key"})
           (prefix "sainnhe/gruvbox-material" {"config" "config.plugin.gruvbox-material"})
           (prefix "nvim-lualine/lualine.nvim" {"config" "config.plugin.lualine"})
           (prefix "romainl/vim-cool" {})
           
           (prefix "williamboman/mason.nvim" {"config" "config.plugin.mason"})
           (prefix "williamboman/mason-lspconfig.nvim" {"requires" ["williamboman/mason.nvim"]
                                                        "config" "config.plugin.mason-lspconfig"})])
