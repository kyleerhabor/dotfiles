-- Based on https://github.com/Olical/dotfiles/blob/main/stowed/.config/nvim/init.lua
local root = vim.fn.stdpath("data") .. "/site/pack/packer/start"

local function path(dir)
  return root .. "/" .. dir
end

local function exists(path)
  return vim.loop.fs_stat(path)
end

local function repository(user, repo)
  return string.format("https://github.com/%s/%s", user, repo)
end

local function ensure(user, repo)
  local path = path(repo)

  if not exists(path) then
    vim.fn.system {
      "git", "clone", repository(user, repo),
      path
    }

    vim.api.nvim_command(string.format("packadd %s", repo))
  end
end

ensure("wbthomason", "packer.nvim")
ensure("Olical", "nfnl")

vim.loader.enable()

require("nfnl")["compile-all-files"]()

require("config/init")
