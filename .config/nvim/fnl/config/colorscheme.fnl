(module config.colorscheme
  {autoload {a aniseed.core
             nvim aniseed.nvim}})

(when (not= "Apple_Terminal" vim.env.TERM_PROGRAM)
  (set vim.opt.termguicolors true))

(nvim.set_hl 0 "InlineEvaluationResult"
  (a.assoc (nvim.get_hl 0 {"name" "Comment"})
    "bold" true
    "italic" false))

;; TODO: Find an alternative theme 
(vim.cmd "colorscheme gruvbox-material")
