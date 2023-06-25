(module config.keymap)

(def keymap vim.keymap)

;; "Oh, but what if some program depends on esc and it isn't registered as a result!?" Too bad. :)
(keymap.set "t" "<Esc>" "<C-\\><C-n>")

(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")

(keymap.set "n" "<Leader>hs" ":set hlsearch!<Enter>" {"silent" true})

;;; I forgot what the first keymap was for, but the rest is to make the command key ⌘ with pasting not output <D-v>

;; (nvim.set_keymap "n" "<Space>" "<NOP>" {"noremap" true
;;                                         "silent" true})
;;
;; (when nvim.g.neovide
;;   (let [map (fn [mode rhs]
;;               (nvim.set_keymap mode "<D-v>" rhs {"noremap" true
;;                                                  "silent" true}))]
;;     (map "" "+p<CR>")
;;     (let [m (fn [mode]
;;               (map mode "<C-R>+"))]
;;       (m "!")
;;       (m "t")
;;       (m "v"))))
