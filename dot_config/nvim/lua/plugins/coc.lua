function is_loaded(plugin_name) return vim.tbl_get(require("lazy.core.config"), "plugins", plugin_name, "_", "loaded") end

return {
    "neoclide/coc.nvim",
    branch = "release",
    event = "VeryLazy",
    config = function()
        local function try_to_use_latest_node_by_nvm()
            -- Execute 'nvm which 18' and trim the result
            local handle = io.popen("bash -c 'n which 18 --offline -q'")
            local result = handle:read("*a"):gsub("^%s*(.-)%s*$", "%1")
            handle:close()

            -- Check if 'nvm which 18' succeeded
            if result ~= "" and result ~= nil then
                vim.g.coc_node_path = result
            else
                error("Command 'n which 18' failed.")
            end
        end

        try_to_use_latest_node_by_nvm()

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

        function _G.smoothie_scrool(key)
            local smoothie_mapping = {
                ["f"] = function() vim.cmd([[call smoothie#do("\<C-F>")]]) end,
                ["b"] = function() vim.cmd([[call smoothie#do("\<C-B>")]]) end,
            }
            local original_mapping = {
                ["f"] = function() vim.cmd([[ exe "norm! \<c-f>" ]]) end,
                ["b"] = function() vim.cmd([[ exe "norm! \<c-b>" ]]) end,
            }

            if is_loaded("vim-smoothie") then
                smoothie_mapping[key]()
            else
                original_mapping[key]()
            end
        end

        vim.g.coc_global_extensions = {
            "coc-symbol-line",
            -- need to create dir ~/.config/coc/extensions/coc-stylua-data/ if stylua bin not found error occured
            "coc-stylua",
            "coc-markdownlint",
            "@yaegassy/coc-astro",
            "@yaegassy/coc-ansible",
            "@yaegassy/coc-nginx",
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
            "coc-toml",
            "coc-tsserver",
            "coc-webview",
            "coc-xml",
            "coc-yaml",
            "coc-yank",
            "coc-tasks",
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
        keyset("n", "d", "<Plug>(coc-git-chunkinfo)")
        -- show signature when editing like IDEA
        keyset("i", "p", "<C-r>=CocActionAsync('showSignatureHelp')<CR>", { noremap = true, silent = true })

        -- for jump to next placeholder
        vim.g.coc_snippet_next = "<c-b>"
        -- for jump to previous placeholder
        vim.g.coc_snippet_prev = "<c-z>"
        -- for convert visual selected code to snippet
        keyset("x", "<leader>x", "<Plug>(coc-convert-snippet)")
        -- for trigger snippet expand. <tab> not works as expected
        keyset("i", "<C-j>", "<Plug>(coc-snippets-expand)")

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
            'coc#float#has_scroll() ? coc#float#scroll(1) : ":lua _G.smoothie_scrool(\\"f\\")<CR>"',
            { silent = true, nowait = true, expr = true }
        )
        keyset(
            "n",
            "<C-b>",
            'coc#float#has_scroll() ? coc#float#scroll(0) :":lua _G.smoothie_scrool(\\"b\\")<CR>"',
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

        function _format_notify()
            vim.cmd([[call CocAction('format')]])

            if is_loaded("nvim-notify") then
                require("notify")("Formatted", "info", { title = "Coc" })
            end
        end

        -- Add `:Format` command to format current buffer.
        api.nvim_create_user_command("Format", ":lua _format_notify()<CR>", {})

        -- " Add `:Fold` command to fold current buffer.
        api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

        -- Add `:OR` command for organize imports of the current buffer.
        api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

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
            "exe 'FloatermNew --width=0.8 --height=0.8 rg '.<q-args>",
            { nargs = "+", complete = "custom,_G.GrepArgs" }
        )

        -- coc-symbol-line https://github.com/xiyaowong/coc-symbol-line
        function _G.symbol_line()
            local curwin = vim.g.statusline_winid or 0
            local curbuf = vim.api.nvim_win_get_buf(curwin)
            local ok, line = pcall(vim.api.nvim_buf_get_var, curbuf, "coc_symbol_line")
            return ok and line or ""
        end

        vim.o.winbar = "%!v:lua.symbol_line()"
    end,
}
