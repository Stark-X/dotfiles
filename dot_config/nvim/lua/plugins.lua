-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Lazy loading:
    -- Load on specific commands
    use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

    -- Load on an autocommand event
    use({ "andymass/vim-matchup", event = "VimEnter" })

    vim.g.ale_disable_lsp = 1
    -- Load on a combination of conditions: specific filetypes or commands
    -- Also run code after load (see the "config" key)
    use({
        "w0rp/ale",
        ft = { "sh", "zsh", "bash", "c", "cpp", "cmake", "html", "markdown", "racket", "vim", "tex" },
        cmd = "ALEEnable",
        config = "vim.cmd[[ALEEnable]]",
    })

    -- Use specific branch, dependency and run lua file after load
    -- use {
    -- 'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
    -- requires = {'kyazdani42/nvim-web-devicons'}
    -- }

    -- Use dependency and run lua function after load
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function() require("gitsigns").setup() end,
    })

    -- You can specify multiple plugins in a single call
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    use({ "fgheng/winbar.nvim" })
    require("winbar").setup({
        enabled = true,

        show_file_path = true,
        show_symbols = true,

        colors = {
            path = "", -- You can customize colors like #c946fd
            file_name = "",
            symbols = "",
        },

        icons = {
            file_icon_default = "",
            seperator = ">",
            editor_state = "●",
            lock_icon = "",
        },

        exclude_filetype = {
            "help",
            "startify",
            "dashboard",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "alpha",
            "lir",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "qf",
        },
    })

    -- replace nerdtree
    use({
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
    })
    require("nvim-tree").setup()
    vim.keymap.set("", "<F3>", "<Cmd> :NvimTreeToggle<CR>")

    -- hirechercy like pycharm
    use("simrat39/symbols-outline.nvim")
    require("symbols-outline").setup()

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
