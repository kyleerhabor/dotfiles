;;;; This module is for anything "central" to the application running Neovim (e.g. Neovide configuration).

(local neovide? vim.g.neovide)

(fn alpha [n]
  (string.format "%x" (math.floor (* n 255))))

(set vim.opt.guifont (if neovide?
                       ;; Neovide already supports icons (and looks better with normal mono).
                       "SF Mono:h14"
                       "SF Mono Powerline:h14"))

(set vim.g.neovide_theme "dark")

;; The color is from Oxocarbon's background blend (https://github.com/nyoom-engineering/oxocarbon.nvim).
;;
;; NOTE: This gives off a "burn" feeling for some wallpapers.
(set vim.g.neovide_background_color (.. "#131313" (alpha 0.75)))

(when neovide?
  ;; In Neovide, it's easy for me to tell which line I'm on with just the line number column highlighted. On other
  ;; clients (like Neovim for Mac; https://github.com/JaySandhu/neovim-mac), it's not so easy.
  (set vim.o.cursorlineopt "number")

  (vim.api.nvim_command "cd ~"))

;; This should probably be moved to some constants file.
{"highlight" 500}
