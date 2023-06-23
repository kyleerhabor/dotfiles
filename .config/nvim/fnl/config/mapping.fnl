(module config.mapping
  {autoload {nvim aniseed.nvim}})

(nvim.set_keymap "n" "<Space>" "<NOP>" {"noremap" true
                                        "silent" true})

(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")

(when nvim.g.neovide
  (let [map (fn [mode rhs]
              (nvim.set_keymap mode "<D-v>" rhs {"noremap" true
                                                 "silent" true}))]
    (map "" "+p<CR>")
    (let [m (fn [mode]
              (map mode "<C-R>+"))]
      (m "!")
      (m "t")
      (m "v"))))
