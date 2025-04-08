-- vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
-- vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

return {
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        config = function()
            local header = {
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡖⠁⠀⠀⠀⠀⠀⠀⠈⢲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
                "⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀ ",
                "⠀⠀⠀⠀⠀⠀⠀⣸⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀ ",
                "⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⢀⣀⣤⣤⣤⣤⣀⡀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀ ",
                "⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣔⢿⡿⠟⠛⠛⠻⢿⡿⣢⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀ ",
                "⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣷⣤⣀⡀⢀⣀⣤⣾⣿⣿⣿⣷⣶⣤⡀⠀⠀⠀⠀ ",
                "⠀⠀⢠⣾⣿⡿⠿⠿⠿⣿⣿⣿⣿⡿⠏⠻⢿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣷⡀⠀⠀ ",
                "⠀⢠⡿⠋⠁⠀⠀⢸⣿⡇⠉⠻⣿⠇⠀⠀⠸⣿⡿⠋⢰⣿⡇⠀⠀⠈⠙⢿⡄⠀ ",
                "⠀⡿⠁⠀⠀⠀⠀⠘⣿⣷⡀⠀⠰⣿⣶⣶⣿⡎⠀⢀⣾⣿⠇⠀⠀⠀⠀⠈⢿⠀ ",
                "⠀⡇⠀⠀⠀⠀⠀⠀⠹⣿⣷⣄⠀⣿⣿⣿⣿⠀⣠⣾⣿⠏⠀⠀⠀⠀⠀⠀⢸⠀ ",
                "⠀⠁⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⢇⣿⣿⣿⣿⡸⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀ ",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
                "⠀⠀⠀⠐⢤⣀⣀⢀⣀⣠⣴⣿⣿⠿⠋⠙⠿⣿⣿⣦⣄⣀⠀⠀⣀⡠⠂⠀⠀⠀ ",
                "⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠉⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠋⠁⠀⠀⠀⠀⠀ ",
            }
            require("dashboard").setup({
                config = {
                    disable_move = true,
                    header = header,
                    week_header = {
                        enable = false,
                    },
                    theme = "hyper",
                    shortcut = {
                        { desc = " New", group = "@property", action = "enew", key = "n" },
                        { desc = " Update", group = "@property", action = "Lazy update", key = "u" },
                        { desc = " Profile", group = "@property", action = "Lazy profile", key = "p" },
                        { desc = " Open", group = "@property", action = "Files", key = "o" },
                        { desc = " LeetCode", group = "@property", action = "Leet", key = "c" },
                    },
                },
            })
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },
    {
        "danymat/neogen",
        event = "VeryLazy",
        config = function()
            local opts = { noremap = true, silent = true }
            vim.api.nvim_set_keymap("n", "<leader>nf", ":lua require('neogen').generate({type='func'})<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>nc", ":lua require('neogen').generate({type='class'})<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>nt", ":lua require('neogen').generate({type='type'})<CR>", opts)
        end,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Using ufo provider need remap `zR` and `zM`.
            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
            require("ufo").setup()
        end,
    },
    "rhysd/conflict-marker.vim",
    -- load later and are not important for the initial UI
    { "stevearc/dressing.nvim", event = "VeryLazy" },
    {
        "scottmckendry/cyberdream.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("cyberdream").setup({
                -- Enable transparent background
                transparent = true, -- Default: false
                -- Enable italics comments
                italic_comments = true, -- Default: false
                -- Replace all fillchars with ' ' for the ultimate clean look
                hide_fillchars = true, -- Default: false
                -- Set terminal colors used in `:terminal`
                terminal_colors = true, -- Default: true
                -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
                cache = true,
            })
            vim.cmd([[colorscheme cyberdream]])
        end,
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({ timeout = 500, render = "compact", background_colour = "#9b5a10" })
        end,
    },

    {
        "wuelnerdotexe/vim-astro",
        ft = { "astro" },
        config = function() vim.g.astro_typescript = "enable" end,
    },
    {
        "codota/tabnine-nvim",
        build = "./dl_binaries.sh",
        event = "VeryLazy",
        config = function()
            require("tabnine").setup({
                disable_auto_comment = true,
                accept_keymap = "<Tab>",
                dismiss_keymap = "<C-]>",
                debounce_ms = 800,
                suggestion_color = { gui = "#808080", cterm = 244 },
                exclude_filetypes = { "TelescopePrompt", "NvimTree", "neo-tree" },
                -- log_file_path = "/tmp/tabnine.log", -- absolute path to Tabnine log file
                log_file_path = nil, -- absolute path to Tabnine log file
            })
            --- falling back to inserting tab if neither has a completion
            vim.keymap.set("i", "<tab>", function()
                if require("tabnine.keymaps").has_suggestion() then
                    return require("tabnine.keymaps").accept_suggestion()
                else
                    return "<tab>"
                end
            end, { expr = true })
            require("notify")("Using TabNine", "info")
        end,
    },

    "ryanoasis/vim-devicons",
    "psliwka/vim-smoothie",
    { "tweekmonster/startuptime.vim", lazy = true, cmd = { "StartupTime" } },
    "tpope/vim-fugitive",
    -- Comment with one Space
    {
        "scrooloose/nerdcommenter",
        config = function() vim.g.NERDSpaceDelims = 1 end,
    },
    "terryma/vim-multiple-cursors",
    { "tpope/vim-surround", event = "InsertEnter" },
    { "tpope/vim-repeat", event = "InsertEnter" },
    { "leafgarland/typescript-vim", ft = { "typescript" } },
    { "posva/vim-vue", ft = { "vue" } },
    {
        "junegunn/vim-easy-align",
        config = function()
            -- Start interactive EasyAlign in visual mode (e.g. vipga)
            -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
            vim.keymap.set({ "x", "n" }, "ga", "<Plug>(EasyAlign)")
        end,
    },
    -- { "patstockwell/vim-monokai-tasty", config = function() vim.g.vim_monokai_tasty_italic = 1 end },
    {
        "nvimdev/indentmini.nvim",
        config = function()
            require("indentmini").setup({ exclude = { "markdown" } })
            vim.cmd.highlight("IndentLine guifg=#5d626b")
            -- Current indent line highlight
            vim.cmd.highlight("IndentLineCurrent guifg=#f1ff5e")
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    },
    -- select and press gr
    "vim-scripts/ReplaceWithRegister",
    -- Execute linux cmd in vim :SudoWrite, :SudoEdit, :Mkdirr etc.
    {
        "tpope/vim-eunuch",
        cmd = {
            "Remove",
            "Delete",
            "Move",
            "Rename",
            "Chmod",
            "Mkdir",
            "Cfind",
            "Clocate",
            "Lfind",
            "Llocate",
            "Wall",
            "SudoWrite",
            "SudoEdit",
        },
    },
    --  ']' and '[' mappings
    --  '[e', ']e' exchange lines, '[<space>', ']<space>' add blank lines, etc.
    --  '[l', ']l' jump between warnings generated by lint tools
    "tpope/vim-unimpaired",
    --  Automatically clears search highlight when cursor is moved
    --  Improved star-search (visual-mode, highlighting without moving)
    "junegunn/vim-slash",
    "godlygeek/tabular",
    -- calculate programming time
    "wakatime/vim-wakatime",
    -- cx{range} to swap two text-obj, X for select mode
    "tommcdo/vim-exchange",
    "machakann/vim-highlightedyank",
    "vim-scripts/argtextobj.vim",
    -- toggle quickfix list with <learder>q and toggle location list with <leader>l
    "Valloric/ListToggle",
    -- + expand_region_expand
    -- _ expand_region_shrink
    "terryma/vim-expand-region",
    -- Browsing the files
    "justinmk/vim-dirvish",
    -- lots of languages syntax highlighting support
    { "sheerun/vim-polyglot", event = "VeryLazy", dependencies = "filetype.nvim" },
    {
        "mattn/emmet-vim",
        ft = { "vue", "html", "xml" },
        init = function() vim.g.user_emmet_leader_key = "<C-j>" end,
    },
    {
        "jiangmiao/auto-pairs",
        config = function()
            vim.g.AutoPairsShortcutToggle = ""
            vim.g.AutoPairsFlyMode = 0
        end,
    },
    {
        "dyng/ctrlsf.vim",
        cmd = "CtrlSF",
        config = function()
            -- **search** word under cursor in the **project** folder
            vim.keymap.set("n", "<leader>sp", ":CtrlSF<cr>", { noremap = true })
            vim.g.ctrlsf_auto_focus = { at = "start" }
        end,
    },
    -- distraction-free mode (:ZenMode)
    { "folke/zen-mode.nvim", cmd = "ZenMode" },

    {
        "junegunn/fzf",
        build = ":call fzf#install()",
        config = function()
            local km = vim.keymap.set
            km("n", "<leader><tab>", "<plug>(fzf-maps-n)")
            km("x", "<leader><tab>", "<plug>(fzf-maps-x)")
            km("o", "<leader><tab>", "<plug>(fzf-maps-o)")
            -- 设置命令映射 MapsI 执行 <plug>(fzf-maps-i) `<c-o>:call fzf#vim#maps('i', 0)<cr>`
            vim.api.nvim_create_user_command("MapsI", ":call fzf#vim#maps('i', 0)", {})

            km("n", "<C-p>", ":Files<CR>")
            km("n", "<C-h>", ":History<CR>")
            km("n", "<C-t>", ":Buffers<CR>")
            local fzfActions = {}
            fzfActions["ctrl-s"] = "split"
            fzfActions["ctrl-t"] = "tabnew"
            fzfActions["ctrl-v"] = "vsplit"
            vim.g.fzf_action = fzfActions
        end,
    },
    { "junegunn/fzf.vim", dependencies = "junegunn/fzf" },
    {
        "gfanto/fzf-lsp.nvim",
        config = function() require("fzf_lsp").setup({ override_ui_select = true }) end,
        dependencies = "junegunn/fzf.vim",
    },
    { "voldikss/fzf-floaterm", dependencies = "junegunn/fzf" },
    {
        "voldikss/vim-floaterm",
        cmd = "Floaterms",
        keys = { "<F8>", "<F9>", "<F10>" },
        init = function()
            vim.g.floaterm_keymap_prev = "<F8>"
            vim.g.floaterm_keymap_next = "<F9>"
            vim.g.floaterm_keymap_toggle = "<F10>"
            vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
        end,
        config = function()
            vim.api.nvim_create_autocmd("Filetype", {
                pattern = "python",
                callback = function()
                    vim.keymap.set("", "<leader>tt", ":FloatermNew pytest<CR>")
                    vim.keymap.set("", "<leader>ts", ":FloatermNew pytest -sv<CR>")
                    vim.keymap.set("", "<leader>tp", ":FloatermNew pytest -v --pdb<CR>")
                end,
            })
        end,
    },

    {
        "skywind3000/asyncrun.vim",
        dependencies = { "voldikss/vim-floaterm", "skywind3000/asynctasks.vim" },
        cmd = { "AsyncRun", "AsyncStop", "AsyncTask" },
        keys = { "<F5>", "<F6>" },
        config = function()
            vim.keymap.set("n", "<F5>", ":AsyncTask file-run<cr>", { noremap = true, silent = true })
            vim.keymap.set("n", "<F6>", ":AsyncTask file-build<cr>", { noremap = true, silent = true })
            vim.g.asyncrun_open = 6
            vim.g.asyncrun_rootmarks = { ".git", ".svn", ".root", ".project", ".hg" }
            vim.g.asynctasks_term_pos = "floaterm"
            -- global config file located in ~/.config/nvim/tasks.ini
        end,
    },

    {
        "vim-scripts/groovy.vim",
        dependencies = { "vim-scripts/groovyindent-unix" },
        ft = { "groovy" },
        config = function() vim.api.nvim_create_autocmd("Filetype", { pattern = "groovy", command = "setlocal sw=2" }) end,
    },
    {
        "plasticboy/vim-markdown",
        ft = { "markdown" },
        config = function()
            vim.g.vim_markdown_new_list_item_indent = 2
            vim.g.vim_markdown_toc_autofit = 1
            --  Show the link url explicitly
            vim.g.vim_markdown_conceal = 0
            --  Show the code block symbol explicitly
            vim.g.vim_markdown_conceal_code_blocks = 0
            -- markdown-setting: YAML
            vim.g.vim_markdown_frontmatter = 1
            -- disable incorrect autofold
            vim.g.vim_markdown_folding_disabled = 1
        end,
    },

    -- replace the filetype.vim for speeding up
    -- Do not source the default filetype.vim
    {
        "nathom/filetype.nvim",
        init = function() vim.g.did_load_filetypes = 1 end,
    },

    {
        "andymass/vim-matchup",
        config = function() vim.g.matchup_surround_enabled = 1 end,
    },

    -- local installedFt = { "lua", "cmake", "vim", "bash", "toml", "yaml" }
    -- You can specify multiple plugins in a single call
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            -- % jump between begin and end of a word, jump between pairs when cursor in the block
            {
                "yorickpeterse/nvim-tree-pairs",
                config = function() require("tree-pairs").setup() end,
            },
            -- add rainbow delimiters
            "HiPhish/rainbow-delimiters.nvim",
            "nvim-treesitter/nvim-treesitter-refactor",
        },
        build = ":TSUpdate",
        cmd = { "TSUpdate", "TSInstall", "TSToggle" },
        ft = { "lua", "cmake", "vim", "bash", "toml", "yaml" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "cmake",
                    "just",
                    "vim",
                    "bash",
                    "toml",
                    "yaml",
                    "vimdoc",
                    "go",
                    "markdown_inline",
                    "markdown",
                },
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
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        node_decremental = "<BS>",
                        scope_incremental = "<TAB>",
                    },
                },
                -- provided by "nvim-treesitter/nvim-treesitter-refactor"
                refactor = {
                    navigation = {
                        enable = true,
                        -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
                        keymaps = {
                            goto_definition = false,
                            list_definitions = false,
                            list_definitions_toc = false,
                            goto_next_usage = "]h",
                            goto_previous_usage = "[h",
                        },
                    },
                    highlight_definitions = {
                        enable = true,
                        -- Set to false if you have an `updatetime` of ~100.
                        clear_on_cursor_move = true,
                    },
                },
            })

            vim.o.foldmethod = "expr"
            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        keys = { "<F3>", "<F49>" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
            {
                "s1n7ax/nvim-window-picker",
                name = "window-picker",
                event = "VeryLazy",
                version = "2.*",
                config = function() require("window-picker").setup() end,
            },
        },
        config = function()
            vim.keymap.set("", "<F3>", "<Cmd> :Neotree toggle<CR>")
            -- equlas to alt+F1
            vim.keymap.set("", "<F49>", "<Cmd> :Neotree reveal<CR>")
        end,
    },

    -- hirechercy like pycharm
    {
        "simrat39/symbols-outline.nvim",
        cmd = { "SymbolsOutlineOpen", "SymbolsOutline" },
        config = function() require("symbols-outline").setup() end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function() require("todo-comments").setup() end,
    },

    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        cmd = { "Trouble", "TroubleToggle" },
        config = function() require("trouble").setup() end,
    },

    {
        "dense-analysis/ale",
        init = function()
            local g = vim.g
            -- :help ale-fix (<C-]> to jump tag, <C-t> to come back)
            -- NOTE: check the help document for some tools installation
            -- :ALEFixSuggest to get the suggest the supported fixers
            g.ale_fixers = {
                ["*"] = { "trim_whitespace", "remove_trailing_lines" },
                javascript = { "eslint" },
                typescript = { "prettier" },
                python = { "ruff", "isort" },
                yaml = { "trim_whitespace" },
                vue = { "eslint" },
            }
            -- Run both javascript and vue linters for vue files.
            g.ale_linter_aliases = { vue = { "vue", "javascript" } }
            g.ale_linters = {
                lua = { "stylua" },
                javascript = { "eslint" },
                typescript = { "tslint" },
                python = { "pyright", "pydocstyle" },
                yaml = { "yamllint", "prettier" },
                vue = { "eslint", "vls" },
                markdown = {},
            }

            g.ale_disable_lsp = 1
            g.ale_use_neovim_diagnostics_api = 1
        end,
        config = function()
            local km = vim.keymap
            km.set("n", "<leader>f", ":ALEFix<cr>", { noremap = true, silent = true })
            km.set("n", "]a", ":ALENextWrap<cr>", { silent = true })
            km.set("n", "[a", ":ALEPreviousWrap<cr>", { silent = true })
            -- equals to <C-F1>. insert mode, then press <c-k><ctrl><f1>, it'll print <F25>. (WSL neovim)
            km.set("n", "<F25>", ":ALEDetail<cr>", { silent = true })

            local g = vim.g
            g.ale_floating_preview = 1
            -- Fix files when they are saved.
            g.ale_fix_on_save = 0

            g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
            g.ale_echo_msg_error_str = ""
            g.ale_sign_error = ""
            g.ale_echo_msg_warning_str = ""
            g.ale_sign_warning = ""
            g.ale_floating_window_border = { "│", "─", "╭", "╮", "╯", "╰", "│", "─" }
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "junegunn/fzf" },
        config = function()
            require("lualine").setup({
                -- options = { globalstatus = true, theme = "horizon" },
                options = { globalstatus = true, theme = "cyberdream" },
                extensions = { "fzf", "neo-tree", "symbols-outline", "fugitive" },
                tabline = {
                    lualine_a = { "filename" },
                    lualine_b = {},
                    lualine_c = { "tabs" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "buffers" },
                },
                sections = {
                    lualine_b = {
                        "branch",
                        "diff",
                        {
                            "diagnostics",
                            -- Table of diagnostic sources, available sources are:
                            --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
                            -- or a function that returns a table as such:
                            --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
                            sources = { "nvim_lsp", "nvim_diagnostic", "ale" },
                        },
                    },
                    lualine_c = { "windows" },
                    -- lualine_x has default setting
                    lualine_y = {
                        "tabnine",
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = { fg = "#ff9e64" },
                        },
                    },
                    lualine_z = { "searchcount", "location" },
                },
            })
        end,
    },
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",

            -- 可选
            "nvim-treesitter/nvim-treesitter",
            "rcarriga/nvim-notify",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "leetcode.nvim" },
        cmd = { "Leet" },
        opts = {
            -- 配置放在这里
            cn = {
                enabled = true,
            },
            lang = "golang",
            injector = {
                ["golang"] = {
                    before = "package main",
                },
            },
        },
    },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
        opts = {
            -- add any opts here
            ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
            provider = "openai", -- Recommend using Claude
            auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
            openai = {
                endpoint = "https://one-ai.xjztest.com:5002/v1",
                model = "deepseek-chat",
                temperature = 0,
                max_tokens = 4096,
            },
            windows = {
                ask = {
                    floating = true,
                },
            },
            behaviour = {
                auto_suggestions = false, -- Experimental stage
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
                minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },
}
