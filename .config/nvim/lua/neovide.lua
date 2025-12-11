if not vim.g.neovide then
    return
end


if vim.fn.has("macos") == 1 then
    -- vim.g.neovide_input_macos_alt_is_meta = false
    -- cmd-c, cmd-v
    vim.keymap.set("i", "<D-v>", "<c-r>+", { noremap = true })
    vim.keymap.set("v", "<D-c>", '"+y', { noremap = true })

    vim.g.neovide_input_macos_alt_is_meta = true

    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    vim.g.neovide_transparency = 0.0
    vim.g.transparency = 0.8
    vim.g.neovide_background_color = "#0f1117" .. vim.fn.printf("%x", vim.fn.float2nr(255 * vim.g.transparency))
else
  -- insert mode
  vim.keymap.set("i", "<M-v>", "<c-r>+", { noremap = true })
  -- command mode
  vim.keymap.set("c", "<M-v>", "<c-r>+", { noremap = true })
  -- normal mode
  vim.keymap.set("n", "<M-v>", "<c-r>+", { noremap = true })
  vim.keymap.set("v", "<M-c>", '"+y', { noremap = true })
end

vim.g.neovide_cursor_vfx_mode = "pixiedust"


vim.g.neovide_opacity = 0.8
vim.g.neovide_normal_opacity = 0.8

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

-- for 100Hz monitor
vim.g.neovide_refresh_rate = 100

vim.g.neovide_remember_window_size = true

-- catppuccin-mocha color scheme in terminal
vim.g.terminal_color_0 = "#45475a"
vim.g.terminal_color_1 = "#f38ba8"
vim.g.terminal_color_2 = "#a6e3a1"
vim.g.terminal_color_3 = "#f9e2af"
vim.g.terminal_color_4 = "#89b4fa"
vim.g.terminal_color_5 = "#f5c2e7"
vim.g.terminal_color_6 = "#94e2d5"
vim.g.terminal_color_7 = "#bac2de"
vim.g.terminal_color_8 = "#585b70"
vim.g.terminal_color_9 = "#f38ba8"
vim.g.terminal_color_10 = "#a6e3a1"
vim.g.terminal_color_11 = "#f9e2af"
vim.g.terminal_color_12 = "#89b4fa"
vim.g.terminal_color_13 = "#f5c2e7"
vim.g.terminal_color_14 = "#94e2d5"
vim.g.terminal_color_15 = "#a6adc8"
