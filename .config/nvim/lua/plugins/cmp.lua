return {
    -----------------------------------------------------------------------------
    -- blink.cmp
    -----------------------------------------------------------------------------
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            { "L3MON4D3/LuaSnip", version = "v2.*" },
            "Kaiser-Yang/blink-cmp-avante",
            "fang2hou/blink-copilot",
            "AndreM222/copilot-lualine",
        },
        opts = {
            keymap = {
                preset = "enter",

                -- Enter 接受菜单项
                ["<CR>"] = {
                    function(cmp)
                        -- 1) blink 菜单开着：回车就接受菜单项
                        if cmp.is_menu_visible() then
                            return cmp.accept()
                        end

                        -- 2) 菜单没开：走 auto-pairs 的换行缩进逻辑（但不走它那条 <SNR> buffer-map）
                        if vim.fn.exists("*AutoPairsReturn") == 1 then
                            local keys = vim.api.nvim_replace_termcodes(
                                "<C-g>u<CR><C-r>=AutoPairsReturn()<CR>",
                                true,
                                false,
                                true
                            )
                            vim.api.nvim_feedkeys(keys, "n", true)
                            return true
                        end

                        -- 3) 没有 auto-pairs：就正常回车
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
                        return true
                    end,
                },

                -- Tab 留给 Copilot ghost /（Normal 下给 NES）
                ["<Tab>"] = false,
                ["<S-Tab>"] = false,

                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
            },

            snippets = { preset = "luasnip" },

            completion = {
                -- 关键：不要自动弹出菜单（否则你如果做了“菜单打开就隐藏 ghost”的逻辑，会导致 ghost 常被隐藏）
                menu = { auto_show = false },
                documentation = { auto_show = true },
            },

            sources = {
                -- 默认不把 copilot 放菜单（你之前也是这么想的）
                default = { "avante", "lsp", "path", "snippets", "buffer" },

                providers = {
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {
                            -- 你的 avante 配置放这里（如需）
                        },
                    },

                    -- 你加回 blink-copilot 插件，但默认不启用进菜单：
                    -- 如果你某天想把 Copilot 也塞进菜单，把上面的 default 加上 "copilot"
                    -- 并把下面这段取消注释即可。
                    -- copilot = {
                    --   name = "copilot",
                    --   module = "blink-copilot",
                    --   score_offset = 100,
                    --   async = true,
                    -- },
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },

    -----------------------------------------------------------------------------
    -- copilot-lsp 负责 NES
    -----------------------------------------------------------------------------
    {
        "copilotlsp-nvim/copilot-lsp",
        event = { "BufReadPre", "BufNewFile" },
        init = function() vim.g.copilot_nes_debounce = 500 end,
        config = function()
            require("copilot-lsp").setup({
                nes = {
                    move_count_threshold = 3,
                },
            })

            -- 启用 copilot_ls（需要 copilot-language-server 在 PATH）
            if vim.lsp and vim.lsp.enable then
                vim.lsp.enable("copilot_ls")
            end

            -- Normal 模式：Tab 接受 NES（方案 A）
            -- 注意：只映射 <Tab>，fallback 返回 <C-i>；不要再同时映射 <C-i>，否则容易回环/覆盖。
            vim.keymap.set("n", "<Tab>", function()
                local bufnr = vim.api.nvim_get_current_buf()
                if vim.b[bufnr].nes_state then
                    local nes = require("copilot-lsp.nes")
                    local _ = nes.walk_cursor_start_edit() or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
                    return nil
                end
                return "<C-i>"
            end, { expr = true, desc = "Accept Copilot NES (Normal mode)" })

            -- 可选：清理 NES
            vim.keymap.set(
                "n",
                "<Esc>",
                function() require("copilot-lsp.nes").clear() end,
                { desc = "Clear Copilot NES" }
            )
        end,
    },

    -----------------------------------------------------------------------------
    -- copilot.lua 负责 ghost text（虚拟字符）
    -----------------------------------------------------------------------------
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = { enabled = false },

                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    hide_during_completion = true,
                    keymap = {
                        accept = false, -- 我们下面自己用 <Tab> 接受
                    },
                },

                -- 建议：这里先不要让 copilot.lua 自己也启用 NES，
                -- NES 交给 copilot-lsp 独占，减少 DocumentNotFound / cancel request 的概率
                nes = { enabled = false },
            })

            -- Insert 模式：Tab 优先接受 ghost text，否则 fallback 为普通 Tab
            local function t(keys) return vim.api.nvim_replace_termcodes(keys, true, true, true) end

            vim.keymap.set("i", "<Tab>", function()
                local ok, sug = pcall(require, "copilot.suggestion")
                if ok and sug.is_visible() then
                    sug.accept()
                    return ""
                end
                return t("<Tab>")
            end, { expr = true, desc = "Tab: accept Copilot ghost text or fallback" })
        end,
    },
}
