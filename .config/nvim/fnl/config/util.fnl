(local n (require "nfnl.core"))

(fn prefix [x table]
  (n.assoc table 1 x))

(local terms {"apple" "Apple_Terminal"})
(local colorschemes {"gruvbox-material" "gruvbox-material"
                     "oxocarbon" "oxocarbon"})

{: prefix
 : terms
 : colorschemes}
