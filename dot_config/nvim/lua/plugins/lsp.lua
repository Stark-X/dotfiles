return {
    {
        "williamboman/mason.nvim",
        init = function()
            local km = vim.keymap.set
            -- rename
            km("n", "<leader>r", ":lua vim.lsp.buf.rename<CR>")
            -- code action
            km("n", "<space>ca", ":lua vim.lsp.buf.code_action()<CR>")
            -- go to definition
            km("n", "<leader>jd", ":lua vim.lsp.buf.definition()<CR>")
            -- show hover
            km("n", "K", ":lua vim.lsp.buf.hover()<CR>")
            -- format
            km("n", "<leader>=", ":lua vim.lsp.buf.format { async = true }<CR>")
        end,
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
        config = function()
            require("go").setup()
            require("go.format").gofmt() -- gofmt only
            require("go.format").goimports() -- goimports + gofmt
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },
    {
        "williamboman/mason-lspconfig.nvim",
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

            require("lspconfig").lua_ls.setup({})
            require("lspconfig").lua_ls.setup({})
            require("lspconfig").typos_lsp.setup({})
            require("lspconfig").ansiblels.setup({})
            require("lspconfig").bashls.setup({})
            require("lspconfig").astro.setup({})
            require("lspconfig").cmake.setup({})
            require("lspconfig").cssls.setup({})
            require("lspconfig").dockerls.setup({})
            require("lspconfig").eslint.setup({})

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
    "nvimtools/none-ls.nvim",
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    "neovim/nvim-lspconfig",
}
