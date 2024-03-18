(module local
  {autoload {coro coroutine
             : jeejah}})

;;; Set the path for the loader to find JeeJah and LuaSocket.

(local home (os.getenv "HOME"))

(set package.path (.. package.path ";" home "/.luarocks/share/lua/5.1/?.lua"))
(set package.cpath (.. package.cpath ";" home "/.luarocks/lib/lua/5.1/?.so"))

;; JeeJah already has a default port.
(jeejah.start 54321 {})
