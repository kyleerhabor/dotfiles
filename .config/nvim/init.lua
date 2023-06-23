-- Based on https://github.com/Olical/dotfiles/blob/main/stowed/.config/nvim/init.lua
local fmt = string.format
local exec = vim.api.nvim_command

local function ensure(user, repo)
  local path = fmt(vim.fn.stdpath("data") .. "/site/pack/packer/start/%s", repo)
  local available = vim.fn.empty(vim.fn.glob(path)) > 0

  if available then
    exec(fmt("!git clone https://github.com/%s/%s %s", user, repo, path))
    exec(fmt("packadd %s", repo))
  end
end

ensure("wbthomason", "packer.nvim")
ensure("Olical", "aniseed")

vim.loader.enable()

vim.g["aniseed#env"] = {
  init = "config.init",
  output = "~/.config/nvim/lua/compiled"
}
