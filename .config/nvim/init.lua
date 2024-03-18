-- Based on https://github.com/Olical/dotfiles/blob/main/stowed/.config/nvim/init.lua
local root_path = vim.fn.stdpath("data") .. "/site/pack/packer/start"

local function path_from_root(dir)
  return root_path .. "/" .. dir
end

local function exists(path)
  return vim.loop.fs_stat(path)
end

local function repo_url(user, repo)
  return string.format("https://github.com/%s/%s", user, repo)
end

local function ensure(user, repo)
  local path = path_from_root(repo)

  if exists(path) then
    return
  end

  vim.fn.system {
    "git", "clone", repo_url(user, repo),
    path
  }

  vim.api.nvim_command(string.format("packadd %s", repo))
end

ensure("wbthomason", "packer.nvim")
ensure("Olical", "nfnl")

vim.loader.enable()

require("config/init")
