(local {: colorscheme
        : set-colorscheme} (require "config.colorscheme"))

(set vim.g.gruvbox_material_ui_contrast "low")
(set vim.g.gruvbox_material_transparent_background 2)
(set vim.g.gruvbox_material_better_performance 1)

(if (= colorscheme "gruvbox-material")
  (set-colorscheme))
