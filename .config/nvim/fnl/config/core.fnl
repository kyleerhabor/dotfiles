(module config.core
  {autoload {nvim aniseed.nvim}})

(set nvim.o.undofile true)
(set nvim.o.cursorline true)

;; Searching
(set nvim.o.smartcase true)

;; Tab line
(set nvim.o.showmode false)

;; ...
(set nvim.o.shiftwidth 2)

(defn alpha [n]
  (string.format "%x" (math.floor (* n 255))))

;;; Application

(set nvim.o.guifont "SF Mono Powerline:h14")
(set nvim.g.neovide_transparency 0)
(set nvim.g.neovide_background_color (.. "#131313" (alpha 0.75)))

(when nvim.g.neovide
  ;; Neovide already supports icons (it seems).
  (set nvim.o.guifont "SF Mono:h14")

  ;; Neovide starts in the root directory, which is annoying.
  (nvim.ex.cd "~")) 
