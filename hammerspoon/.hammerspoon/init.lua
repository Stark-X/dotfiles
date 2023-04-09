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

-- interactive window resize
hs.grid.setGrid("7x5", nil, nil)
hs.grid.setMargins({ 0, 0 })
hs.hotkey.bind({ "shift" }, "space", function() hs.grid.show() end)

REPEAT_DELAY = 200

local wf = hs.window.filter
wf_keep_awake = wf.new({ "谜底时钟" })
wf_keep_awake:subscribe(wf.windowFocused, function()
    _GUtils.tips("Start Caffeine")
    hs.caffeine.set("displayIdle", true)
end)
wf_keep_awake:subscribe(wf.windowUnfocused, function()
    _GUtils.tips("Stop Caffeine")
    hs.caffeine.set("displayIdle", false)
end)

require("./Spoons/mouseToWinCenter").init()
require("./Spoons/winDrag").init()
require("./Spoons/vimEmulation").init({
    "MacVim",
    "iTerm2",
    "PhpStorm",
    "IntelliJ IDEA",
    "PyCharm",
    "WebStorm",
    "Code",
    "tmux",
    "neovide",
})
