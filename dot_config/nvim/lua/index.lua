require("plugins")

-- mark filetype as 'text' by default to avoiding match-up not work issue
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.o.filetype == "" then
            vim.opt_local.filetype = "text"
        end
    end,
})
vim.o.lazyredraw = true
