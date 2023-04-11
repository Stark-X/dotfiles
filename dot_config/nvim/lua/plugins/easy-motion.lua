return function()
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
end
