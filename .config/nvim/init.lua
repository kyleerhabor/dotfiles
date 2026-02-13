local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
local pckr_url = "https://github.com/lewis6991/pckr.nvim.git"

if not vim.uv.fs_stat(pckr_path) then
  -- TODO: Add error handling.
  local command = vim.system { "git", "clone", "--filter=blob:none", pckr_url, pckr_path }
  local result = command:wait()
  local code = result.code

  if code ~= 0 then
    vim.api.nvim_err_writeln("Failed to clone pckr.nvim (exited with code " .. code .. ")\nPress any key to exit...")
    vim.fn.getchar()
    os.exit(1)
  end
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
