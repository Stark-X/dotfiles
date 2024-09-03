return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                github = {
                    ---@since 1.0.0
                    -- The template URL to use when downloading assets from GitHub.
                    -- The placeholders are the following (in order):
                    -- 1. The repository (e.g. "rust-lang/rust-analyzer")
                    -- 2. The release version (e.g. "v0.3.0")
                    -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
                    download_url_template = "https://mirror.ghproxy.com/https://github.com/%s/releases/download/%s/%s",
                },
                ui = {
                    border = "rounded",
                },
            })
        end,
    },
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            { "ray-x/guihua.lua", build = "cd lua/fzy && make", opts = { border = "rounded" } },
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").gofmt() -- gofmt only
                    require("go.format").goimports() -- goimports + gofmt
                end,
                group = format_sync_grp,
            })
            require("go").setup({
                lsp_cfg = false,
                -- disable lsp keymaps, if true, the lspsaga keymaps will be ignored
                lsp_keymaps = false,
                lsp_inlay_hints = {
                    enable = false, -- disable go.nvim inlay as it is currently buggy. use vim.lsp.inlay_hint instead(bind to <leader>i)
                },
            })
            vim.lsp.inlay_hint.enable() --- enable inlay hints by lsp instead of go.nvim, toggle with <leader>i
            local cfg = require("go.lsp").config() -- config() return the go.nvim gopls setup

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            cfg["capabilities"] = capabilities
            require("lspconfig").gopls.setup(cfg)
        end,
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },
    { "mfussenegger/nvim-jdtls", ft = { "java" } },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "typos_lsp",
                    "ansiblels",
                    "bashls",
                    "astro",
                    "cmake",
                    "cssls",
                    "dockerls",
                    "eslint",
                    "gopls",
                    "groovyls",
                    "graphql",
                    "helm_ls",
                    "jdtls",
                    "jsonls",
                    "tsserver",
                    "autotools_ls",
                    "mesonlsp",
                    "ruff_lsp",
                    "jedi_language_server",
                    "volar",
                    "yamlls",
                },
                automatic_installation = true,
                handlers = {
                    -- The first entry (without a key) will be the default handler
                    -- and will be called for each installed server that doesn't have
                    -- a dedicated handler.
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                    -- disable jdtls config, just use the mason to ensure the jdtls is installed
                    jdtls = function() end,
                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup({
                            on_init = function(client)
                                local path = client.workspace_folders[1].name
                                if
                                    vim.loop.fs_stat(path .. "/.luarc.json")
                                    or vim.loop.fs_stat(path .. "/.luarc.jsonc")
                                then
                                    return
                                end

                                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                                    runtime = {
                                        -- Tell the language server which version of Lua you're using
                                        -- (most likely LuaJIT in the case of Neovim)
                                        version = "LuaJIT",
                                    },
                                    -- Make the server aware of Neovim runtime files
                                    workspace = {
                                        checkThirdParty = false,
                                        library = {
                                            vim.env.VIMRUNTIME,
                                            -- Depending on the usage, you might want to add additional paths here.
                                            -- "${3rd}/luv/library"
                                            -- "${3rd}/busted/library",
                                        },
                                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                        -- library = vim.api.nvim_get_runtime_file("", true)
                                    },
                                })
                            end,
                            settings = {
                                Lua = {
                                    format = {
                                        -- use stylua by guard.nvim instead
                                        enable = false,
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
        dependencies = { "williamboman/mason.nvim" },
    },
    {
        "MunifTanjim/prettier.nvim",
        config = function()
            local prettier = require("prettier")
            prettier.setup({
                bin = "prettier", -- or `'prettierd'` (v0.23.3+)
                filetypes = {
                    "css",
                    "graphql",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "less",
                    "markdown",
                    "scss",
                    "typescript",
                    "typescriptreact",
                    "yaml",
                },
            })
        end,
    },
    {
        -- a formatter that replace the null-ls
        "nvimdev/guard.nvim",
        -- Builtin configuration, optional
        dependencies = {
            "nvimdev/guard-collection",
        },
        config = function()
            local ft = require("guard.filetype")

            -- Assuming you have guard-collection
            -- ft('lang'):fmt('format-tool-1')
            -- :append('format-tool-2')
            -- :env(env_table)
            -- :lint('lint-tool-1')
            -- :extra(extra_args)

            ft("lua"):fmt("stylua")

            -- Call setup() LAST!
            require("guard").setup({
                -- Choose to format on every write to a buffer
                fmt_on_save = true,
                -- Use lsp if no formatter was defined for this filetype
                lsp_as_default_formatter = true,
                -- By default, Guard writes the buffer on every format
                -- You can disable this by setting:
                -- save_on_fmt = false,
            })
            vim.keymap.set("n", "<F4>", "<cmd> GuardFmt<CR>", { silent = true, noremap = true })
        end,
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = function() require("nvim-dap-virtual-text").setup() end,
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "onsails/lspkind.nvim",

            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol", -- show only symbol annotations
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- can also be a function to dynamically calculate max width such as
                        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

                        symbol_map = { Copilot = "" },

                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        before = function(entry, vim_item) return vim_item end,
                    }),
                },
            })
            -- Use buffer source for `/` and `?`.
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':'.
            cmp.setup.cmdline(":", {
                completion = { autocomplete = false },
                mapping = cmp.mapping.preset.cmdline(), -- do not delete this line
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            local luasnip = require("luasnip")
            local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end
            local get_sugg_funcs = function()
                local sug_available
                local sug_accept
                if require("lazy.core.config").plugins["copilot.lua"] ~= nil then
                    sug_available = require("copilot.suggestion").is_visible
                    sug_accept = require("copilot.suggestion").accept
                else
                    sug_available = require("tabnine.keymaps").has_suggestion
                    sug_accept = require("tabnine.keymaps").accept_suggestion
                end
                return { available = sug_available, accept = sug_accept }
            end
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources({
                    -- Copilot Source
                    -- { name = "copilot" },
                    { name = "luasnip" }, -- For luasnip users.
                    { name = "nvim_lsp" },
                }, { { name = "buffer" } }),
                mapping = {
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() ~= nil then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        local sugg_funcs = get_sugg_funcs()
                        local sugg_available = sugg_funcs.available
                        local sugg_accept = sugg_funcs.accept
                        if sugg_available() then
                            sugg_accept()
                        elseif cmp.visible() then
                            -- acts like IDEA
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            end
                            cmp.confirm()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<Down>"] = cmp.mapping(
                        cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i" }
                    ),
                    ["<Up>"] = cmp.mapping(
                        cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i" }
                    ),
                    ["<C-n>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                fallback()
                            end
                        end,
                    }),
                    ["<C-p>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                fallback()
                            end
                        end,
                    }),
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
        -- lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
        event = "VeryLazy",
        config = function()
            vim.keymap.set(
                "n",
                "<leader>i",
                "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
                { silent = true, noremap = true }
            )
        end,
    },
    {
        -- maybe I can use ray-x/navigator.lua as replacement
        "nvimdev/lspsaga.nvim",
        config = function()
            vim.diagnostic.config({
                virtual_text = false, -- disable default diagnostic virtual text
            })
            require("lspsaga").setup({
                code_action = {
                    extend_gitsigns = true,
                },
                definition = {
                    keys = {
                        edit = "<C-o>",
                        vsplit = "<C-v>",
                        split = "<C-s>",
                        tabe = "<C-t>",
                    },
                },
                diagnostic = {
                    diagnostic_only_current = true,
                },
                finder = {
                    default = "tyd+ref+imp+def",
                    silent = true,
                    keys = {
                        vsplit = "<c-v>",
                        split = "<c-s>",
                        toggle_or_open = "<enter>",
                    },
                },
                lightbulb = {
                    sign = false,
                },
                outline = {
                    layout = "float",
                    keys = {
                        jump = "<enter>",
                    },
                },
            })
        end,
        init = function()
            local km = vim.keymap.set
            local opt = { silent = true, noremap = true }
            -- rename
            -- km("n", "<leader>r", ":lua vim.lsp.buf.rename<CR>", opt)
            km("n", "<leader>r", "<cmd>Lspsaga rename<CR>", opt)
            -- code action
            --[[ km("n", "<space>a", ":lua vim.lsp.buf.code_action()<CR>", opt) ]]
            km("n", "<space>a", "<cmd>Lspsaga code_action<CR>", opt)
            -- go to definition
            -- km("n", "<leader>jd", ":lua vim.lsp.buf.definition()<CR>", opt)
            km("n", "<leader>jd", "<cmd>Lspsaga goto_definition<CR>", opt)
            -- find references
            km("n", "<leader>jr", "<cmd>Lspsaga finder def+ref<CR>", opt)
            -- peek definition
            km("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", opt)
            -- find all usages of the symbol
            km("n", "<M-C-F7>", "<cmd>Lspsaga finder<CR>", opt)
            -- show hover
            -- km("n", "K", ":lua vim.lsp.buf.hover()<CR>", opt)
            km("n", "K", "<cmd>Lspsaga hover_doc<CR>", opt)
            -- format
            -- km("n", "<F4>", ":lua vim.lsp.buf.format { async = true }<CR>", opt)
            -- show tag / outline, F60 == alt + F12
            km("n", "<F60>", "<cmd>Lspsaga outline<CR>", opt)
            km(
                { "n" },
                "<M-p>",
                function() vim.lsp.buf.signature_help() end,
                { silent = true, noremap = true, desc = "toggle signature" }
            )
        end,
        event = "LspAttach",
        dependencies = {
            "nvim-treesitter/nvim-treesitter", -- optional
            "nvim-tree/nvim-web-devicons", -- optional
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            handler_opts = {
                border = "rounded",
            },
            toggle_key = "<M-p>", -- toggle signature on and off in insert mode
            floating_window_off_x = 5, -- adjust float windows x position.
            floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
                local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
                local pumheight = vim.o.pumheight
                local winline = vim.fn.winline() -- line number in the window
                local winheight = vim.fn.winheight(0)

                -- window top
                if winline - 1 < pumheight then
                    return pumheight
                end

                -- window bottom
                if winheight - winline < pumheight then
                    return -pumheight
                end
                return 0
            end,
        },
        config = function(_, opts)
            -- require("lsp_signature").setup(opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
                        return
                    end
                    require("lsp_signature").on_attach(opts, bufnr)
                end,
            })
        end,
    },
}
