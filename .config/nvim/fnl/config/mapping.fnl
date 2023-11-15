(local map vim.keymap.set)

;; Does this need to be at the top?
(map "n" "<Space>" "<NOP>" {"noremap" true})

(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

;; TODO: Add D-V to make Command-V work

;; (map "t" "<Esc>" "<C-\\><C-n>")

;;; I forgot what the first keymap was for, but the rest is to make the command key ⌘ with pasting not output <D-v>

;; (map "n" "<Space>" "<NOP>" {"noremap" true
;;                             "silent" true})

(when vim.g.neovide
  (let [map (fn [mode rhs]
              (map mode "<D-v>" rhs {"noremap" true
                                     "silent" true}))]
    (map "" "+p<CR>")
    (let [m (fn [mode]
              (map mode "<C-R>+"))]
      (m "!")
      (m "t")
      (m "v"))))
