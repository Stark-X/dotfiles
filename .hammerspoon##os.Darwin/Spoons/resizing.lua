_GUtils = require("./Spoons/gUtils")

-- buildFrameFn will receive current windows's frame to produce a new frame
function resizer(buildFrameFn)
    return function()
        local win = hs.window.focusedWindow()
        if not win then
            return
        end
        _GUtils.setFrame({ win = win, frame = buildFrameFn(win:screen():frame()) })
    end
end

return {
    init = function(bindings)
        -- Window resizing register
        for _, binding in ipairs(bindings) do
            hs.hotkey.bind(binding.modifiers, binding.key, resizer(binding.newFrameFn))
        end
    end,
}
