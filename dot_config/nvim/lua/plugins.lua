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

    use({
        "fgheng/winbar.nvim",
        config = function()
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
        end,
    })

    -- replace nerdtree
    use({
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("", "<F3>", "<Cmd> :NvimTreeToggle<CR>")
        end,
    })

    -- hirechercy like pycharm
    use({
        "simrat39/symbols-outline.nvim",
        config = function()
            require("symbols-outline").setup({
                highlight_hovered_item = true,
                show_guides = true,
                auto_preview = false,
                position = "right",
                relative_width = true,
                width = 25,
                auto_close = false,
                show_numbers = false,
                show_relative_numbers = false,
                show_symbol_details = true,
                preview_bg_highlight = "Pmenu",
                autofold_depth = nil,
                auto_unfold_hover = true,
                fold_markers = { "", "" },
                wrap = false,
                keymaps = { -- These keymaps can be a string or a table for multiple keys
                    close = { "<Esc>", "q" },
                    goto_location = "<Cr>",
                    focus_location = "o",
                    hover_symbol = "<C-space>",
                    toggle_preview = "K",
                    rename_symbol = "r",
                    code_actions = "a",
                    fold = "h",
                    unfold = "l",
                    fold_all = "W",
                    unfold_all = "E",
                    fold_reset = "R",
                },
                lsp_blacklist = {},
                symbol_blacklist = {},
                symbols = {
                    File = { icon = "", hl = "TSURI" },
                    Module = { icon = "", hl = "TSNamespace" },
                    Namespace = { icon = "", hl = "TSNamespace" },
                    Package = { icon = "", hl = "TSNamespace" },
                    Class = { icon = "𝓒", hl = "TSType" },
                    Method = { icon = "ƒ", hl = "TSMethod" },
                    Property = { icon = "", hl = "TSMethod" },
                    Field = { icon = "", hl = "TSField" },
                    Constructor = { icon = "", hl = "TSConstructor" },
                    Enum = { icon = "ℰ", hl = "TSType" },
                    Interface = { icon = "ﰮ", hl = "TSType" },
                    Function = { icon = "", hl = "TSFunction" },
                    Variable = { icon = "", hl = "TSConstant" },
                    Constant = { icon = "", hl = "TSConstant" },
                    String = { icon = "𝓐", hl = "TSString" },
                    Number = { icon = "#", hl = "TSNumber" },
                    Boolean = { icon = "⊨", hl = "TSBoolean" },
                    Array = { icon = "", hl = "TSConstant" },
                    Object = { icon = "⦿", hl = "TSType" },
                    Key = { icon = "🔐", hl = "TSType" },
                    Null = { icon = "NULL", hl = "TSType" },
                    EnumMember = { icon = "", hl = "TSField" },
                    Struct = { icon = "𝓢", hl = "TSType" },
                    Event = { icon = "🗲", hl = "TSType" },
                    Operator = { icon = "+", hl = "TSOperator" },
                    TypeParameter = { icon = "𝙏", hl = "TSParameter" },
                },
            })
        end,
    })

    use("lewis6991/impatient.nvim")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
