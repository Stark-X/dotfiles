-- Auto reload config
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
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
hs.hints.style="vimperator"
hs.hotkey.bind({"cmd",}, 'escape', function()
    -- API: hs.hints.windowHints([windows, callback, allowNonStandard])
    hs.hints.windowHints(nil, nil, false)
end)

-- Window resizing
hs.hotkey.bind({"cmd", "alt",}, "h", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt",}, "l", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt",}, "k", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt",}, "j", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + max.h / 2
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt",}, "y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w * 2 / 3
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt",}, "u", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local width = max.w * 2 / 3
  f.x = max.x + (max.w - width)
  f.y = max.y
  f.w = width
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt",}, "b", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 3
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt",}, "n", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local width = max.w / 3
  f.x = max.x + (max.w - width)
  f.y = max.y
  f.w = width
  f.h = max.h
  win:setFrame(f)
end)

function getFullscreenFrame(currentWin)
    return currentWin:screen():frame()
end

function getCenterFrame(currentWin)
    local centerFrame = currentWin:frame()

    local fullscreenFrame = getFullscreenFrame(currentWin)
    centerFrame.w = fullscreenFrame.w * 4 / 5
    centerFrame.h = fullscreenFrame.h * 4 / 5
    centerFrame.x = fullscreenFrame.x + (fullscreenFrame.w - centerFrame.w) / 2
    centerFrame.y = fullscreenFrame.y + (fullscreenFrame.h - centerFrame.h) / 2
    return centerFrame
end

function toggleFullAndCenter(currentWin)
    local frame = currentWin:frame()
    local fullScreenFrame = getFullscreenFrame(currentWin)
    if frame.w ~= fullScreenFrame.w or frame.h ~= fullScreenFrame.h or frame.x ~= fullScreenFrame.x or frame.y ~= fullScreenFrame.y then
        return getFullscreenFrame(currentWin)
    else
        return getCenterFrame(currentWin)
    end
end

-- Toggle full screen between window-center
hs.hotkey.bind({"cmd", "alt",}, "c", function()
  local win = hs.window.focusedWindow()
  win:setFrame(toggleFullAndCenter(win))
end)

