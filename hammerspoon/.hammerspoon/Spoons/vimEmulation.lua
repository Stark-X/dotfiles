-- Map ctrl + [ to escape
fn_escape = function() hs.eventtap.keyStroke(nil, "escape") end
bn_esc = hs.hotkey.bind('{"ctrl",}', "[", fn_escape, nil, fn_escape)

-- simulate vim mode
fn_left = function() hs.eventtap.keyStroke(nil, "left", REPEAT_DELAY) end
bn_left = hs.hotkey.bind('{"ctrl",}', "h", fn_left, nil, fn_left)

fn_down = function() hs.eventtap.keyStroke(nil, "down", REPEAT_DELAY) end
bn_down = hs.hotkey.bind('{"ctrl",}', "j", fn_down, nil, fn_down)

fn_up = function() hs.eventtap.keyStroke(nil, "up", REPEAT_DELAY) end
bn_up = hs.hotkey.bind('{"ctrl",}', "k", fn_up, nil, fn_up)

fn_right = function() hs.eventtap.keyStroke(nil, "right", REPEAT_DELAY) end
bn_right = hs.hotkey.bind('{"ctrl",}', "l", fn_right, nil, fn_right)

-- Delete a word before the cursor
fn_delete_a_word = function() hs.eventtap.keyStroke('{"alt", }', "delete", REPEAT_DELAY) end
bn_delete_a_word = hs.hotkey.bind('{"ctrl",}', "w", fn_delete_a_word, nil, fn_delete_a_word)

function enableBinds()
    bn_delete_a_word:enable()
    bn_up:enable()
    bn_down:enable()
    bn_left:enable()
    bn_right:enable()
    bn_esc:enable()
end
function disableBinds()
    bn_delete_a_word:disable()
    bn_up:disable()
    bn_down:disable()
    bn_left:disable()
    bn_right:disable()
    bn_esc:disable()
end

local wf = hs.window.filter

return {
    init = function(disableWindows)
        wf_vim = wf.new(disableWindows)
        wf_vim:subscribe(wf.windowFocused, disableBinds)
        wf_vim:subscribe(wf.windowUnfocused, enableBinds)
    end,
}
