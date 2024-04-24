(local n (require "nfnl.core"))

(fn prefix [x table]
  (n.assoc table 1 x))

{: prefix}
