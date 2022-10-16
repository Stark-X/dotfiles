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
                        -- File = { icon = "����", hl = "TSURI" },
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

        use({
            "neoclide/coc.nvim",
            branch = "release",
            config = function()
                -- Some servers have issues with backup files, see #649.
                vim.opt.backup = false
                vim.opt.writebackup = false
                -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
                -- delays and poor user experience.
                vim.opt.updatetime = 300

                -- Always show the signcolumn, otherwise it would shift the text each time
                -- diagnostics appear/become resolved.
                vim.opt.signcolumn = "yes"

                -- Auto complete
                function _G.check_back_space()
                    local col = vim.fn.col(".") - 1
                    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
                end

                vim.g.coc_global_extensions = {
                    "coc-stylua",
                    "coc-markdownlint",
                    "@yaegassy/coc-ansible",
                    "@yaegassy/coc-nginx",
                    "@yaegassy/coc-pylsp",
                    "@yaegassy/coc-volar",
                    "@yaegassy/coc-volar-tools",
                    "coc-css",
                    "coc-docker",
                    "coc-emmet",
                    "coc-dot-complete",
                    "coc-eslint",
                    "coc-explorer",
                    "coc-floaterm",
                    "coc-fzf-preview",
                    "coc-git",
                    "coc-groovy",
                    "coc-highlight",
                    "coc-html",
                    "coc-java",
                    "coc-json",
                    "coc-lightbulb",
                    "coc-lists",
                    "coc-markdown-preview-enhanced",
                    "coc-markdownlint",
                    "coc-markmap",
                    "coc-prettier",
                    "coc-pydocstring",
                    "coc-pyright",
                    "coc-sh",
                    "coc-snippets",
                    "coc-sql",
                    "coc-tabnine",
                    "coc-toml",
                    "coc-tsserver",
                    "coc-webview",
                    "coc-xml",
                    "coc-yaml",
                    "coc-yank",
                }

                local keyset = vim.keymap.set
                local api = vim.api

                -- for coc-css
                api.nvim_create_autocmd("FileType", { pattern = "css", command = "setlocal iskeyword+=-" })
                api.nvim_create_autocmd("FileType", { pattern = "scss", command = "setlocal iskeyword+=@-@" })

                api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "let b:coc_suggest_disable = 1" })

                keyset("", "<F4>", ":Format<CR>", { noremap = true })

                keyset("n", "<space>c", ":<C-u>CocFzfList commands<CR>", { noremap = true, silent = true })
                keyset("n", "<space>a", ":<C-u>CocFzfList actions<CR>", { noremap = true, silent = true })
                keyset("v", "<space>a", ":<C-u>CocAction<CR>", { noremap = true, silent = true })
                keyset("n", "<space>g", ":<C-u>CocList --normal gstatus<CR>", { noremap = true, silent = true })

                -- show chunkinfo like IDEA
                keyset("n", "d ", "<Plug>(coc-git-chunkinfo)")
                -- show signature when editing like IDEA
                keyset("i", "p ", "<C-r>=CocActionAsync('showSignatureHelp')<CR>", { noremap = true, silent = true })

                -- for jump to next placeholder
                vim.g.coc_snippet_next = "<c-b>"
                -- for jump to previous placeholder
                vim.g.coc_snippet_prev = "<c-z>"
                -- for convert visual selected code to snippet
                keyset("x", "<leader>x", "<Plug>(coc-convert-snippet)")
                -- for trigger snippet expand.
                keyset("i", "<tab>", "<Plug>(coc-snippets-expand)")

                -- GoTo code navigation.
                keyset("n", "<leader>jd", "<Plug>(coc-definition)", { silent = true })
                keyset("n", "<leader>jy", "<Plug>(coc-type-definition)", { silent = true })
                keyset("n", "<leader>ji", "<Plug>(coc-implementation)", { silent = true })
                keyset("n", "<leader>jr", "<Plug>(coc-references)", { silent = true })

                -- Use K to show documentation in preview window.
                function _G.show_docs()
                    local cw = vim.fn.expand("<cword>")
                    if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
                        api.nvim_command("h " .. cw)
                    elseif api.nvim_eval("coc#rpc#ready()") then
                        vim.fn.CocActionAsync("doHover")
                    else
                        api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
                    end
                end
                keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

                -- Highlight the symbol and its references when holding the cursor.
                api.nvim_create_augroup("CocGroup", {})
                api.nvim_create_autocmd("CursorHold", {
                    group = "CocGroup",
                    command = "silent call CocActionAsync('highlight')",
                    desc = "Highlight symbol under cursor on CursorHold",
                })

                -- Symbol renaming.
                keyset("n", "<leader>rn", "<Plug>(coc-rename)")

                -- Formatting selected code.
                -- xmap <leader>f  <Plug>(coc-format-selected)
                -- nmap <leader>f  <Plug>(coc-format-selected)

                -- Setup formatexpr specified filetype(s).
                api.nvim_create_autocmd("FileType", {
                    group = "CocGroup",
                    pattern = "typescript,json",
                    command = "setl formatexpr=CocAction('formatSelected')",
                    desc = "Setup formatexpr specified filetype(s).",
                }) -- Update signature help on jump placeholder.
                api.nvim_create_autocmd("User", {
                    group = "CocGroup",
                    pattern = "CocJumpPlaceholder",
                    command = "call CocActionAsync('showSignatureHelp')",
                    desc = "Update signature help on jump placeholder",
                })

                -- Applying codeAction to the selected region.
                -- Example: `<leader>aap` for current paragraph
                keyset({ "x", "n" }, "<leader>a", "<Plug>(coc-codeaction-selected)")

                -- Remap keys for applying codeAction to the current buffer.
                keyset("n", "<leader>ac", "<Plug>(coc-codeaction)")
                -- Apply AutoFix to problem on the current line.
                keyset("n", "<leader>qf", "<Plug>(coc-fix-current)")

                -- Run the Code Lens action on the current line.
                keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)")

                -- Remap <C-f> and <C-b> for scroll float windows/popups.
                keyset(
                    "n",
                    "<C-f>",
                    'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
                    { silent = true, nowait = true, expr = true }
                )
                keyset(
                    "n",
                    "<C-b>",
                    'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
                    { silent = true, nowait = true, expr = true }
                )
                keyset(
                    "i",
                    "<C-f>",
                    'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
                    { silent = true, nowait = true, expr = true }
                )
                keyset(
                    "i",
                    "<C-b>",
                    'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
                    { silent = true, nowait = true, expr = true }
                )
                keyset(
                    "v",
                    "<C-f>",
                    'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
                    { silent = true, nowait = true, expr = true }
                )
                keyset(
                    "v",
                    "<C-b>",
                    'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
                    { silent = true, nowait = true, expr = true }
                )

                -- Add `:Format` command to format current buffer.
                api.nvim_create_user_command("Format", "call CocAction('format')", {})

                -- " Add `:Fold` command to fold current buffer.
                api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

                -- Add `:OR` command for organize imports of the current buffer.
                api.nvim_create_user_command(
                    "OR",
                    "call CocActionAsync('runCommand', 'editor.action.organizeImport')",
                    {}
                )

                -- vim.g.airline#extensions#hunks#coc_git = 1
                -- vim.g.airline#extensions#tabline#enabled = 1

                -- Keymapping for grep word under cursor with interactive mode
                keyset(
                    "n",
                    "<Leader>cf",
                    ":exe 'CocList -I --input='.expand('<cword>').' grep'<CR>",
                    { noremap = true, silent = true }
                )
                keyset(
                    "n",
                    "<Leader>w",
                    ":exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>",
                    { noremap = true, silent = true }
                )

                keyset("n", "<space>y", ":<C-u>CocFzfList yank<cr>", { noremap = true, silent = true })
                -- Use <cr> to confirm completion
                keyset(
                    "i",
                    "<cr>",
                    [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
                    { noremap = true, silent = true, expr = true, replace_keycodes = false }
                )

                -- grep word under cursor
                function _G.GrepArgs(...)
                    return table.concat({
                        "-S",
                        "-smartcase",
                        "-i",
                        "-ignorecase",
                        "-w",
                        "-word",
                        "-e",
                        "-regex",
                        "-u",
                        "-skip-vcs-ignores",
                        "-t",
                        "-extension",
                    }, "\n")
                end

                api.nvim_create_user_command(
                    "Rg",
                    "exe 'CocList grep '.<q-args>",
                    { nargs = "+", complete = "custom,_G.GrepArgs" }
                )

                api.nvim_create_augroup("packer_user_config", { clear = true })
                api.nvim_create_autocmd("BufWritePost", {
                    pattern = "plugins.lua",
                    command = "source <afile> | PackerCompile",
                    group = "packer_user_config",
                })
            end,
        })

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        display = {
            open_fn = require("packer.util").float,
        },
    },
})
