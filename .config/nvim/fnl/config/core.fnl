(module config.core
  {autoload {nvim aniseed.nvim}})

;;;; This module is for anything "central" to the application running Neovim (e.g. Neovide configuration).

(defn alpha [n]
  (string.format "%x" (math.floor (* n 255))))

(set vim.g.neovide_transparency 0)

;; The color is from Oxocarbon's background blend (https://github.com/nyoom-engineering/oxocarbon.nvim).
(set vim.g.neovide_background_color (.. "#131313" (alpha 0.775)))

(when vim.g.neovide
  ;; Neovide already supports icons (it seems).
  (set vim.o.guifont "SF Mono:h14")

  ;; In Neovide, it's easy for me to tell which line I'm on with just the line number column highlighted. On other
  ;; clients (like Neovim for Mac; https://github.com/JaySandhu/neovim-mac), it's not so easy.
  (set vim.o.cursorlineopt "number")

  ;; Neovide starts in the root directory, which is annoying.
  (nvim.command "cd ~"))
