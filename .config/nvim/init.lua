-- advise from NvimTree disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")

vim.cmd([[let &packpath = &runtimepath]])
vim.cmd([[source ~/.vimrc]])
-- use cyberdream in the packer section
-- vim.cmd([[colorscheme vim-monokai-tasty]])

vim.o.lazyredraw = true

-- mkdir -p ~/.config/uv/versions/
-- uv venv ~/.config/uv/versions/neovim --python 3.12
-- uv pip install pynvim neovim pip --python ~/.config/uv/versions/neovim/bin/python
vim.g.python3_host_prog = vim.env.HOME .. "/.config/uv/versions/neovim/bin/python"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    checker = {
        enabled = true,
        notify = false,
    },
    ui = {
        border = "rounded",
    },
    diff = {
        cmd = "diffview.nvim",
    }
})
require("neovide")
