(module config.util
  {autoload {a aniseed.core}})

(defn prefix [x table]
  (a.assoc table 1 x))
