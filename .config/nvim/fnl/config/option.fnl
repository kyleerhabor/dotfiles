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

(def indent 2)

(set opt.expandtab true)
(set opt.shiftwidth indent)
(set opt.wrap false)

;;; Window / Buffer

(set opt.cursorline true)
(set opt.listchars "trail:.,extends:→") ; For some reason, the paired table form doesn't work.
(set opt.number true)
(set opt.numberwidth 5)
(set opt.relativenumber true)
(set opt.scrolloff 1)
(set opt.signcolumn "no") ; This is really just not useful. Virtual text keeps up the tradition of overlay!
(set opt.splitright true)
(set opt.undofile true)
