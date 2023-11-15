(local n (require :nfnl.core))

(when (not= "Apple_Terminal" vim.env.TERM_PROGRAM)
  (set vim.opt.termguicolors true))

(vim.cmd "colorscheme gruvbox-material")

(vim.api.nvim_set_hl 0 "InlineEvaluationResult"
  (n.assoc (vim.api.nvim_get_hl 0 {"name" "Comment"})
    "bold" true
    "italic" false))
