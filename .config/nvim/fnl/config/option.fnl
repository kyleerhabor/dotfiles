(module config.option
  {import-macros [[{: autocmd} :aniseed.macros.autocmds]]})

(def opt vim.opt)

;;; Files

(set opt.autowriteall true)

;;; Mouse

(set opt.mouse "a")

;;; Screen
;;;
;;; NOTE: I tried a cmdheight of 0, which kind of worked, but sometimes flashed with lualine and created more prompts (hit / enter).

(set opt.showcmd false) ; I don't see this ever being useful.
(set opt.showmode false)

;;; Search

(set opt.gdefault true) ; This is deprecated, but I don't care.
(set opt.ignorecase true)
(set opt.smartcase true)

;;; Text
;;;
;;; NOTE: I don't understand what 'shiftround' does.

(set opt.expandtab true)
(set opt.guifont "SF Mono Powerline:h14")
(set opt.shiftwidth 2)
(set opt.wrap false)

;;; Window / Buffer

(set opt.cursorline true)
(set opt.listchars "trail:.,extends:→")
(set opt.number true)
(set opt.numberwidth 5)
(set opt.relativenumber true)
(set opt.scrolloff 1)
(set opt.signcolumn "no") ; They're really just not useful. Virtual text keeps up the tradition of overlay.
(set opt.splitright true)
(set opt.undofile true)

;; This enables list mode when in normal mode (since it's annoying to get the trailing indicators in insert mode, and
;; likely won't be useful for other modes, like visual block)
;;
;; TODO: Figure out how to replace existing autocmds on evaluation.
(autocmd ["ModeChanged"]
  {"callback"
   (fn [{:match modes}]
     (let [mode (string.sub modes -1)]
       (set opt.list (and
                       (= "n" mode)
                       ;; In buffers that aren't modifiable (vimdoc/help, dependencies, etc.) it's annoying for list to
                       ;; to be enabled on e.g. navigation (especially when tabs are used, since you get ^I, which righyfully
                       ;; looks ugly).
                       ;;
                       ;; NOTE: Maybe buftype suffices?
                       (opt.modifiable:get)))))})
