local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
local pckr_url = "https://github.com/lewis6991/pckr.nvim.git"

if not vim.loop.fs_stat(pckr_path) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    pckr_url,
    pckr_path
  }
end

vim.opt.rtp:prepend(pckr_path)

local nfnl = {
  "Olical/nfnl",
  config = "config/init"
}

local pckr = require("pckr")

pckr.setup {
  autoremove = true
}

pckr.add { nfnl }
