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

return require("packer").startup({
    function(use)
        -- Packer can manage itself
        use("wbthomason/packer.nvim")

        use({ "tweekmonster/startuptime.vim", opt = true, cmd = { "StartupTime" } })
        use("tpope/vim-fugitive")
        -- Comment with one Space
        use({ "scrooloose/nerdcommenter", config = function() vim.g.NERDSpaceDelims = 1 end })
        use("terryma/vim-multiple-cursors")
        use("tpope/vim-surround")
        use("tpope/vim-repeat")
        use({ "leafgarland/typescript-vim", opt = true, ft = { "typescript" } })
        use({ "posva/vim-vue", opt = true, ft = { "vue" } })
        use({
            "junegunn/vim-easy-align",
            config = function()
                -- Start interactive EasyAlign in visual mode (e.g. vipga)
                -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
                vim.keymap.set({ "x", "n" }, "ga", "<Plug>(EasyAlign)")
            end,
        })
        use({ "patstockwell/vim-monokai-tasty", config = function() vim.g.vim_monokai_tasty_italic = 1 end })
        use({ "Yggdroot/indentLine", config = function() vim.g.indentLine_char = "⎸" end })
        -- select and press gr
        use("vim-scripts/ReplaceWithRegister")
        -- Execute linux cmd in vim :SudoWrite, :SudoEdit, :Mkdirr etc.
        use({
            "tpope/vim-eunuch",
            opt = true,
            cmd = {
                "Remove",
                "Delete",
                "Move",
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
        })
        --  ']' and '[' mappings
        --  '[e', ']e' exchange lines, '[<space>', ']<space>' add blank lines, etc.
        --  '[l', ']l' jump between warnings generated by lint tools
        use("tpope/vim-unimpaired")
        --  Automatically clears search highlight when cursor is moved
        --  Improved star-search (visual-mode, highlighting without moving)
        use("junegunn/vim-slash")
        use("godlygeek/tabular")
        -- calcuate programming time
        use("wakatime/vim-wakatime")
        -- cx{range} to swap two text-obj, X for select mode
        use("tommcdo/vim-exchange")
        use("machakann/vim-highlightedyank")
        use("vim-scripts/argtextobj.vim")
        -- toggle quickfix list with <learder>q and toggle location list with <leader>l
        use("Valloric/ListToggle")
        -- + expand_region_expand
        -- _ expand_region_shrink
        use("terryma/vim-expand-region")
        -- Browsing the files
        use("justinmk/vim-dirvish")
        -- lots of languages syntax highlighting support
        use("sheerun/vim-polyglot")
        use({
            "vim-scripts/taglist.vim",
            opt = true,
            keys = { "<F2>" },
            config = function() vim.keymap.set("", "<F2>", ":TlistToggle<CR>", { noremap = true }) end,
        })
        use({
            "honza/vim-snippets",
            {
                "SirVer/ultisnips",
                config = function()
                    vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
                    vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"
                end,
            },
        })
        use({
            "mattn/emmet-vim",
            opt = true,
            ft = { "vue", "html", "xml" },
            setup = function() vim.g.user_emmet_leader_key = "<C-j>" end,
        })
        use({
            "jiangmiao/auto-pairs",
            config = function()
                vim.g.AutoPairsShortcutToggle = ""
                vim.g.AutoPairsFlyMode = 0
            end,
        })
        use({
            "dyng/ctrlsf.vim",
            cmd = "CtrlSF",
            config = function()
                -- **search** word under cursor in the **project** folder
                vim.keymap.set("n", "<leader>sp", ":CtrlSF<cr>", { noremap = true })
                vim.g.ctrlsf_auto_focus = { at = "start" }
            end,
        })
        -- distraction-free mode (:Goyo , :Goyo! )
        use({ "junegunn/goyo.vim", cmd = "Goyo", config = function() vim.g.goyo_width = "50%" end })

        use({
            "fatih/vim-go",
            ft = "go",
            run = ":GoUpdateBinaries",
            config = function()
                vim.g.go_doc_popup_window = 1
                vim.api.nvim_create_autocmd(
                    "FileType",
                    { pattern = "go", callback = function() vim.opt_local.tabstop = 4 end }
                )
            end,
        })

        use({
            {
                "junegunn/fzf",
                run = ":call fzf#install()",
                config = function()
                    local km = vim.keymap
                    km.set("n", "<leader><tab>", "<plug>(fzf-maps-n)")
                    km.set("x", "<leader><tab>", "<plug>(fzf-maps-x)")
                    km.set("o", "<leader><tab>", "<plug>(fzf-maps-o)")

                    km.set("n", "<C-p>", ":Files<CR>")
                    km.set("n", "<C-h>", ":History<CR>")
                    km.set("n", "<C-t>", ":Buffers<CR>")
                    local fzfActions = {}
                    fzfActions["ctrl-s"] = "split"
                    fzfActions["ctrl-t"] = "tabnew"
                    fzfActions["ctrl-v"] = "vsplit"
                    vim.g.fzf_action = fzfActions
                end,
            },
            { "junegunn/fzf.vim", requires = "junegunn/fzf" },
            { "voldikss/fzf-floaterm", requires = "junegunn/fzf" },
            {
                -- :CocFzfList xxx
                "antoinemadec/coc-fzf",
                requires = { "junegunn/fzf", "neoclide/coc.nvim" },
                config = function() vim.g.coc_fzf_preview = "right:50%" end,
            },
        })

        use({
            "voldikss/vim-floaterm",
            cmd = "Floaterm*",
            keys = { "<F8>", "<F9>", "<F10>" },
            setup = function()
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
        })
        use({
            "skywind3000/asyncrun.vim",
            requires = { "skywind3000/asyncrun.extra", "skywind3000/asynctasks.vim" },
            cmd = "Async*",
            keys = "<F5>",
            config = function()
                vim.keymap.set("n", "<F5>", ":AsyncTask file-run<cr>", { noremap = true, silent = true })
                vim.g.asyncrun_open = 6
                vim.g.asynctasks_term_pos = "floaterm_reuse"
            end,
        })

        use({
            "vim-scripts/groovy.vim",
            requires = { "vim-scripts/groovyindent-unix" },
            opt = true,
            ft = { "groovy" },
            config = function() vim.api.nvim_create_autocmd("Filetype", { pattern = "groovy", command = "setlocal sw=2" }) end,
        })
        use({
            "easymotion/vim-easymotion",
            config = function()
                vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings
                -- <space>s{char}{char} to move to {char}{char}
                vim.keymap.set("n", "<space>s", "<Plug>(easymotion-overwin-f2)")
                -- <space>f{char} to move to {char}
                vim.keymap.set({ "", "n" }, "<space>f", "<Plug>(easymotion-overwin-f)")
                -- Move to line
                vim.keymap.set({ "", "n" }, "<space>L", "<Plug>(easymotion-overwin-line)")
                -- Move to word
                vim.keymap.set({ "", "n" }, "<space>w", "<Plug>(easymotion-overwin-w)")
                -- Turn on case insensitive feature
                vim.g.EasyMotion_smartcase = 1
                -- JK motions: Line motions
                vim.keymap.set("", "<space>j", "<Plug>(easymotion-j)")
                vim.keymap.set("", "<space>k", "<Plug>(easymotion-k)")
            end,
        })
        use({
            "plasticboy/vim-markdown",
            opt = true,
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
            end,
        })

        -- replace the filetype.vim for speeding up
        -- Do not source the default filetype.vim
        use({ "nathom/filetype.nvim", config = function() vim.g.did_load_filetypes = 1 end })

        -- Lazy loading:
        -- Load on specific commands
        use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

        -- Load on an autocommand event
        use({ "andymass/vim-matchup", config = function() vim.g.matchup_surround_enabled = 1 end })

        -- Use dependency and run lua function after load
        use({
            "lewis6991/gitsigns.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function() require("gitsigns").setup(require("plugins.gitsigns")) end,
        })

        local installedFt = { "lua", "cmake", "vim", "bash", "toml", "yaml" }
        -- You can specify multiple plugins in a single call
        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            opt = true,
            cmd = "TS*",
            ft = installedFt,
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = installedFt,
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
                })

                vim.o.foldmethod = "expr"
                vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            end,
        })

        -- replace nerdtree
        use({
            "nvim-tree/nvim-tree.lua",
            requires = { "nvim-tree/nvim-web-devicons" },
            opt = true,
            cmd = { "NvimTreeToggle" },
            keys = { "<F3>" },
            tag = "nightly", -- optional, updated every week. (see issue #1193)
            config = function()
                require("nvim-tree").setup({ update_focused_file = { enable = true } })
                vim.keymap.set("", "<F3>", "<Cmd> :NvimTreeToggle<CR>")
            end,
        })

        -- hirechercy like pycharm
        use({
            "geekifan/symbols-outline.nvim",
            -- "simrat39/symbols-outline.nvim",
            opt = true,
            cmd = { "SymbolsOutlineOpen", "SymbolsOutline" },
            config = function() require("symbols-outline").setup() end,
        })

        use({
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function() require("todo-comments").setup() end,
        })

        use({
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            opt = true,
            cmd = { "Trouble", "TroubleToggle" },
            config = function() require("trouble").setup() end,
        })

        use({ "lewis6991/impatient.nvim", config = function() require("impatient") end })

        use({ "neoclide/coc.nvim", branch = "release", config = function() require("plugins.coc") end })

        use({
            "dense-analysis/ale",
            config = function()
                local g = vim.g
                local km = vim.keymap
                km.set("n", "<leader>f", ":ALEFix<cr>", { noremap = true, silent = true })
                km.set("n", "]a", ":ALENextWrap<cr>", { silent = true })
                km.set("n", "[a", ":ALEPreviousWrap<cr>", { silent = true })
                km.set("n", "<C-k>", "<Plug>(ale_previous_wrap)", { silent = true })
                km.set("n", "<C-j>", "<Plug>(ale_next_wrap)", { silent = true })

                -- use coc.nvim lsp insteadg.ale_disable_lsp = 1
                -- Fix files when they are saved.
                g.ale_fix_on_save = 0
                -- :help ale-fix (<C-]> to jump tag, <C-t> to come back)
                -- NOTE: check the help document for some tools installation
                -- :ALEFixSuggest to get the suggest the supported fixers
                g.ale_fixers = {
                    ["*"] = { "trim_whitespace" },
                    javascript = { "eslint" },
                    typescript = { "prettier" },
                    python = { "isort", "black", "autopep8" },
                    yaml = { "trim_whitespace" },
                    vue = { "eslint" },
                }
                -- Run both javascript and vue linters for vue files.
                g.ale_linter_aliases = { vue = { "vue", "javascript" } }
                g.ale_linters = {
                    lua = { "stylua" },
                    javascript = { "eslint" },
                    typescript = { "tslint" },
                    python = { "pylint" },
                    yaml = { "yamllint", "prettier" },
                    vue = { "eslint", "vls" },
                }

                g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
                g.syntastic_python_pylint_post_args = "--max-line-length=120"
                g.ale_floating_window_border = { "│", "─", "╭", "╮", "╯", "╰", "│", "─" }
            end,
        })
        use({
            "nvim-lualine/lualine.nvim",
            requires = { { "kyazdani42/nvim-web-devicons", opt = true }, "junegunn/fzf" },
            config = function()
                require("lualine").setup({
                    options = { globalstatus = true, theme = "horizon" },
                    extensions = { "fzf", "nvim-tree", "symbols-outline", "fugitive" },
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
                                sources = { "nvim_diagnostic", "ale", "coc" },
                            },
                        },
                        lualine_c = { "windows" },
                        lualine_z = { "searchcount", "location" },
                    },
                })
            end,
        })

        vim.api.nvim_create_augroup("packer_auto_compile", {})
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = "packer_auto_compile",
            command = "source <afile> | PackerCompile",
            pattern = "*/nvim/lua/plugins/*.lua",
        })

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        display = {
            open_fn = function()
                local result, win, buf = require("packer.util").float({
                    border = "rounded",
                })
                vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:Normal")
                return result, win, buf
            end,
        },
    },
})
