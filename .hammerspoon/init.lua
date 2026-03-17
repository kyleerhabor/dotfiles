-- I'm not sure why we need to do this as of recently (2026-03-13).
package.path = package.path .. ";/usr/local/opt/fennel/share/lua/5.1/?.lua"
package.cpath = package.cpath .. ";/usr/local/opt/fennel/share/lua/5.1/?.so"
local fennel = require("fennel")

fennel.install().dofile("init.fnl")
