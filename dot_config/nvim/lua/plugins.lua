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

    use({ "tweekmonster/startuptime.vim", opt = true, cmd = { "StartupTime" } })

    --replace the filetype.vim for speeding up
    use({
        "nathom/filetype.nvim",
        config = function()
            -- Do not source the default filetype.vim
            vim.g.did_load_filetypes = 1
        end,
    })

    -- Lazy loading:
    -- Load on specific commands
    use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

    -- Load on an autocommand event
    use({ "andymass/vim-matchup", event = "VimEnter" })

    -- Use dependency and run lua function after load
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                -- disable due to not work with coc, using coc-git blame line instead
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    delay = 500,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function() gs.next_hunk() end)
                        return "<Ignore>"
                    end, { expr = true })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function() gs.prev_hunk() end)
                        return "<Ignore>"
                    end, { expr = true })

                    -- Actions
                    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
                    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
                    map("n", "<leader>hS", gs.stage_buffer)
                    map("n", "<leader>hu", gs.undo_stage_hunk)
                    map("n", "<leader>hR", gs.reset_buffer)
                    map("n", "<leader>hp", gs.preview_hunk)
                    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end)
                    map("n", "<leader>tb", gs.toggle_current_line_blame)
                    map("n", "<leader>hd", gs.diffthis)
                    map("n", "<leader>hD", function() gs.diffthis("~") end)
                    map("n", "<leader>td", gs.toggle_deleted)

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
                end,
            })
        end,
    })

    -- You can specify multiple plugins in a single call
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "cmake", "vim", "bash", "toml", "yaml" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        node_decremental = "<BS>",
                        scope_incremental = "<TAB>",
                    },
                },
            })

            vim.o.foldmethod = "expr"
            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
        end,
    })

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
                    File = { icon = "����", hl = "TSURI" },
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

    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function() require("todo-comments").setup() end,
    })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require("trouble").setup() end,
    })

    use({ "lewis6991/impatient.nvim", config = function() require("impatient") end })
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
