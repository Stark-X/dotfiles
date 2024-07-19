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
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function() require("go").setup() end,
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "LspAttach",
        config = function()
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
                    "tsserver",
                    "autotools_ls",
                    "mesonlsp",
                    "ruff_lsp",
                    "jedi_language_server",
                    "volar",
                    "yamlls",
                },
                automatic_installation = true,
            })

            require("lspconfig").lua_ls.setup({
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
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
            require("lspconfig").typos_lsp.setup({})
            require("lspconfig").ansiblels.setup({})
            require("lspconfig").bashls.setup({})
            require("lspconfig").astro.setup({})
            require("lspconfig").cmake.setup({})
            require("lspconfig").cssls.setup({})
            require("lspconfig").dockerls.setup({})
            require("lspconfig").eslint.setup({})

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
            })
            local cfg = require("go.lsp").config() -- config() return the go.nvim gopls setup
            require("lspconfig").gopls.setup(cfg)

            require("lspconfig").groovyls.setup({})
            require("lspconfig").graphql.setup({})
            require("lspconfig").helm_ls.setup({})
            require("lspconfig").jdtls.setup({})
            require("lspconfig").tsserver.setup({})
            require("lspconfig").autotools_ls.setup({})
            require("lspconfig").mesonlsp.setup({})
            require("lspconfig").ruff_lsp.setup({})
            require("lspconfig").jedi_language_server.setup({})
            require("lspconfig").volar.setup({})
            require("lspconfig").yamlls.setup({})
        end,
        dependencies = { "williamboman/mason.nvim" },
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
        end,
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    { "theHamsta/nvim-dap-virtual-text", config = function() require("nvim-dap-virtual-text").setup() end },
    "neovim/nvim-lspconfig",
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
                findler = {
                    default = "tyd+ref+imp+def",
                    silent = true,
                    keys = {
                        vsplit = "<c-v>",
                        split = "<c-s>",
                    },
                },
                lightbulb = {
                    virtual_text = false,
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
            -- peek definition
            km("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", opt)
            -- find all usages of the symbol
            km("n", "<M-C-F7>", "<cmd>Lspsaga finder<CR>", opt)
            -- show hover
            -- km("n", "K", ":lua vim.lsp.buf.hover()<CR>", opt)
            km("n", "K", "<cmd>Lspsaga hover_doc<CR>", opt)
            -- format
            km("n", "<F4>", ":lua vim.lsp.buf.format { async = true }<CR>", opt)
            -- show tag / outline, F60 == alt + F12
            km("n", "<F60>", "<cmd>Lspsaga outline<CR>", opt)
            km(
                { "n" },
                "p",
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
            toggle_key = "p", -- toggle signature on and off in insert mode
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
