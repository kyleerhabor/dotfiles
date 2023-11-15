(local n (require :nfnl.core))
(local str (require :nfnl.string))

(fn prefix [x table]
  (n.assoc table 1 x))

(fn list [table]
  (str.join "," table))

{:prefix prefix
 :list list}
