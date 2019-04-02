-- Logger
local logger = hs.logger.new('eventtap', 'debug')

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
hs.hints.fontName="Source Code Pro Medium"
hs.hints.fontSize=20
hs.hotkey.bind({"cmd",}, 'space', function()
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

hs.hotkey.bind({"cmd", "alt",}, "f9", function()
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

hs.hotkey.bind({"cmd", "alt",}, "f10", function()
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

hs.hotkey.bind({"cmd", "alt",}, "f11", function()
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

hs.hotkey.bind({"cmd", "alt",}, "f12", function()
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
    if not (
            (frame.w < fullScreenFrame.w + 10 and frame.w >= fullScreenFrame.w - 10) or 
            (frame.h < fullScreenFrame.h + 10 and frame.h >= fullScreenFrame.h - 10) or 
            (frame.x == fullScreenFrame.x) or
            (frame.y == fullScreenFrame.y)
        )then
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

-- move a window to other screen
hs.hotkey.bind({"cmd", "alt",}, "left", function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenWest()
end) 
hs.hotkey.bind({"cmd", "alt",}, "right", function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenEast()
end) 

-- find the mouse
function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.get()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    mouseCircleTimer = hs.timer.doAfter(0.3, function() mouseCircle:delete() end)
end

-- move mouse though windows
eventtapOneClick = hs.eventtap.new({hs.eventtap.event.types.leftMouseDown}, function(e)
    -- logger.d(e:getProperty(hs.eventtap.event.properties["mouseEventClickState"]))
    b_fn = hs.eventtap.checkKeyboardModifiers()["fn"]
    if b_fn and e:getProperty(hs.eventtap.event.properties["mouseEventClickState"]) == 1 then
        local win = hs.window.focusedWindow()
        local frame = win:frame()

        local target = {}
        target.x = frame.x + frame.w / 2
        target.y = frame.y + frame.h / 2
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
hs.grid.setGrid('7x5', nil, nil)
hs.grid.setMargins({0, 0})
hs.hotkey.bind({"shift",}, 'space', function()
    hs.grid.show()
end)

