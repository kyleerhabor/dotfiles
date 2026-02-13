(local {: terms} (require "config.util"))

;; Don't show command sequences (bottom trailing edge)
;;
;; Neovim shows the internal representation of commands, resulting in sequences like "<80>ü^D". I don't need to see
;; that.
(set vim.opt.showcmd false)

;; Dedicate one column for the sign column.
;;
;; This will later be useful for repreesnting modified lines in git.
(set vim.opt.signcolumn "yes:1")

;; Perform case-insensitive searching.
(set vim.opt.ignorecase true)

;; Continue comments on new lines
(vim.opt.formatoptions:append "r")
(vim.opt.formatoptions:append "b") ; ?

;; Evaluate trusted local files.
(set vim.opt.exrc true)

;; Split windows in the trailing direction.
(set vim.opt.splitright true)

;;; Needs update

(set vim.opt.autowriteall true)
(set vim.opt.showmode false)
(set vim.opt.shiftwidth 2)
(set vim.opt.expandtab true)
(set vim.opt.wrap false)

(set vim.opt.timeout true)
(set vim.opt.timeoutlen 400)

(set vim.opt.number true)
(set vim.opt.numberwidth 5)
(set vim.opt.relativenumber true)
(set vim.opt.listchars "trail:.,extends:→")
(set vim.opt.undofile true)

(local leader ",")

(set vim.g.mapleader leader)
(set vim.g.maplocalleader leader)

;;; Colorscheme

(set vim.opt.termguicolors (not= vim.env.TERM_PROGRAM terms.apple))
