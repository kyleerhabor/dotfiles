(local n (require "nfnl.core"))

(local colorscheme-names {"gruvbox-material" "gruvbox-material"
                          "oxocarbon" "oxocarbon"})

(fn set-colorscheme-gruvbox-material []
  (vim.cmd.colorscheme colorscheme-names.gruvbox-material))

(fn set-colorscheme-oxocarbon []
  (local {: oxocarbon} (require "oxocarbon"))

  (vim.cmd.colorscheme (colorscheme-names.oxocarbon))

  ;; TODO: Figure out how to make the status line background transparent.
  (vim.api.nvim_set_hl 0 "Normal" {"bg" oxocarbon.none})
  (vim.api.nvim_set_hl 0 "NormalFloat" {"bg" oxocarbon.none})
  (vim.api.nvim_set_hl 0 "SignColumn" {"bg" oxocarbon.none})
  (vim.api.nvim_set_hl 0 "LineNr" {"bg" oxocarbon.none})

  ;; https://github.com/nyoom-engineering/oxocarbon.nvim/pull/83
  (vim.api.nvim_set_hl 0 "WinSeparator" {"fg" oxocarbon.base04
                                         "bg" oxocarbon.none})

  ;; https://github.com/nyoom-engineering/oxocarbon.nvim/pull/85
  (vim.api.nvim_set_hl 0 "NormalNC" {"bg" oxocarbon.none}))

(fn lualine-theme-oxocarbon []
  (local {: oxocarbon} (require "oxocarbon"))

  (n.assoc-in (require "lualine.themes.oxocarbon") ["normal" "c" "bg"] oxocarbon.none))

(local colorschemes {"gruvbox-material" {"set" set-colorscheme-gruvbox-material
                                         "lualine_theme" (n.constantly "auto")}
                     "oxocarbon" {"set" set-colorscheme-oxocarbon
                                  "lualine_theme" lualine-theme-oxocarbon}})

;; Should the program identifier and colorscheme identifier be separated?
(local colorscheme "gruvbox-material")

(fn set-colorscheme []
  (let [cscheme (. colorschemes colorscheme)]
    (cscheme.set)))

{: colorscheme
 : colorschemes
 : set-colorscheme}
