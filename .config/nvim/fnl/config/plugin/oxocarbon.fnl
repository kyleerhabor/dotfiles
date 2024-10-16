(local {: colorscheme} (require "config.core"))

(local name "oxocarbon")

(when (= colorscheme name)
  (local {: oxocarbon} (require "oxocarbon"))

  (vim.cmd.colorscheme name)

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
