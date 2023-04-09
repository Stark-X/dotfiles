-- Logger
local logger = hs.logger.new("eventtap", "debug")

_GState = {
    tipsId = nil,
}

_GUtils = {
    tips = function(message)
        hs.alert.closeSpecific(_GState["tipsId"])
        _GState["tipsId"] = hs.alert.show(message, _, _, 1)
    end,
    setFrame = function(pointerStore)
        -- win:setFrame(targetFrame, 0)
        -- setFrame is broken for some app's windows
        -- related issue: https://github.com/Hammerspoon/hammerspoon/issues/3224
        local win = pointerStore["win"]
        local frame = pointerStore["frame"]
        win:setTopLeft(frame.x, frame.y)
        -- Waiting 0.2 seconds to make the two step transition work
        -- You might need to adjust this.
        hs.timer.usleep(0.2 * 1000 * 1000)
        win:setSize(frame.w, frame.h)
    end,
    cutCenterFrame = function(refRect)
        local w = refRect.w * 4 / 5
        local h = refRect.h * 4 / 5
        return {
            w = w,
            h = h,
            x = refRect.x + (refRect.w - w) / 2,
            y = refRect.y + (refRect.h - h) / 2,
        }
    end,
}

-- Auto reload config
function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles/hammerspoon/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config reloaded")

-- Hints
hs.hints.style = "vimperator"
hs.hints.fontName = "Source Code Pro Medium"
hs.hints.fontSize = 20
hs.hotkey.bind({ "cmd" }, "space", function()
    -- API: hs.hints.windowHints([windows, callback, allowNonStandard])
    hs.hints.windowHints(nil, nil, false)
end)

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

function bindResizing()
    local bindings = {
        {
            modifiers = { "cmd", "alt" },
            key = "h",
            newFrameFn = function(ref) return { x = ref.x, y = ref.y, w = ref.w / 2, h = ref.h } end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "l",
            newFrameFn = function(ref) return { x = ref.x + (ref.w / 2), y = ref.y, w = ref.w / 2, h = ref.h } end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "k",
            newFrameFn = function(ref) return { x = ref.x, y = ref.y, w = ref.w, h = ref.h / 2 } end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "j",
            newFrameFn = function(ref) return { x = ref.x, y = ref.y + ref.h / 2, w = ref.w, h = ref.h / 2 } end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "f9",
            newFrameFn = function(ref) return { x = ref.x, y = ref.y, w = ref.w * 2 / 3, h = ref.h } end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "f10",
            newFrameFn = function(ref)
                local width = ref.w * 2 / 3
                return { x = ref.x + (ref.w - width), y = ref.y, w = width, h = ref.h }
            end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "f11",
            newFrameFn = function(ref) return { x = ref.x, y = ref.y, w = ref.w / 3, h = ref.h } end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "f12",
            newFrameFn = function(ref)
                local width = ref.w / 3
                return { x = ref.x + (ref.w - width), y = ref.y, w = width, h = ref.h }
            end,
        },
        {
            modifiers = { "cmd", "alt" },
            key = "c",
            -- Toggle full screen between window-center
            newFrameFn = function(ref)
                local curFrame = hs.window.focusedWindow():frame()
                if
                    not (
                        (curFrame.w < ref.w + 10 and curFrame.w >= ref.w - 10)
                        or (curFrame.h < ref.h + 10 and curFrame.h >= ref.h - 10)
                        or (curFrame.x == ref.x)
                        or (curFrame.y == ref.y)
                    )
                then
                    _GUtils.tips("toggle to fullscreen", _, _, 1)
                    return ref
                else
                    _GUtils.tips("toggle to center", _, _, 1)
                    return _GUtils.cutCenterFrame(ref)
                end
            end,
        },
    }
    -- Window resizing register
    for _, binding in ipairs(bindings) do
        hs.hotkey.bind(binding.modifiers, binding.key, resizer(binding.newFrameFn))
    end
end
bindResizing()

-- move a window to other screen
hs.hotkey.bind({ "cmd", "alt" }, "left", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest()
end)
hs.hotkey.bind({ "cmd", "alt" }, "right", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast()
end)

-- find the mouse
function mouseHighlight()
    if not mouseCircle == nil then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.getRelativePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x - 40, mousepoint.y - 40, 80, 80))
    mouseCircle:setStrokeColor({ ["red"] = 1, ["blue"] = 0, ["green"] = 0, ["alpha"] = 1 })
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    mouseCircleTimer = hs.timer.doAfter(0.3, function() mouseCircle:delete() end)
end

-- move mouse though windows
eventtapOneClick = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function(e)
    -- logger.d(e:getProperty(hs.eventtap.event.properties["mouseEventClickState"]))
    b_fn = hs.eventtap.checkKeyboardModifiers()["fn"]
    if b_fn and e:getProperty(hs.eventtap.event.properties["mouseEventClickState"]) == 1 then
        local win = hs.window.focusedWindow()
        local frame = win:frame()

        local target = {
            x = frame.x + frame.w / 2,
            y = frame.y + frame.h / 2,
        }
        -- logger.d(target.x, target.y)
        -- logger.d(frame.x, frame.y)
        hs.mouse.setAbsolutePosition(target)

        mouseHighlight()
        return true
    else
        return false
    end
end)
eventtapOneClick:start()

-- interactive window resize
hs.grid.setGrid("7x5", nil, nil)
hs.grid.setMargins({ 0, 0 })
hs.hotkey.bind({ "shift" }, "space", function() hs.grid.show() end)

REPEAT_DELAY = 200

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

wf_vim = wf.new({ "MacVim", "iTerm2", "PhpStorm", "IntelliJ IDEA", "PyCharm", "WebStorm", "Code", "tmux", "neovide" })
wf_vim:subscribe(wf.windowFocused, disableBinds)
wf_vim:subscribe(wf.windowUnfocused, enableBinds)

wf_keep_awake = wf.new({ "谜底时钟" })
wf_keep_awake:subscribe(wf.windowFocused, function()
    _GUtils.tips("Start Caffeine")
    hs.caffeine.set("displayIdle", true)
end)
wf_keep_awake:subscribe(wf.windowUnfocused, function()
    _GUtils.tips("Stop Caffeine")
    hs.caffeine.set("displayIdle", false)
end)

-- TODO: Check-> Warning:   wfilter: No accessibility access to app GoldenDict (no watcher pid)
-- all_wf = wf.new(true)
-- all_wf:subscribe(wf.windowFocused, function(win, name, en) logger.d(win, name) end)

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

require("./Spoons/winDrag").init()
