(module config.mapping
  {autoload {nvim aniseed.nvim}})

(def keymap vim.keymap)

(keymap.set "n" "<Space>" "<NOP>" {"noremap" true})

(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")


;; (keymap.set "t" "<Esc>" "<C-\\><C-n>")

;;; I forgot what the first keymap was for, but the rest is to make the command key ⌘ with pasting not output <D-v>

;; (keymap.set "n" "<Space>" "<NOP>" {"noremap" true
;;                                    "silent" true})
;;
(when vim.g.neovide
  (let [map (fn [mode rhs]
              (nvim.set_keymap mode "<D-v>" rhs {"noremap" true
                                                 "silent" true}))]
    (map "" "+p<CR>")
    (let [m (fn [mode]
              (map mode "<C-R>+"))]
      (m "!")
      (m "t")
      (m "v"))))
