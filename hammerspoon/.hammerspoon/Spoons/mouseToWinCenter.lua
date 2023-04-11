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
        hs.mouse.absolutePosition(target)

        mouseHighlight()
        return true
    else
        return false
    end
end)

return {
    init = function() eventtapOneClick:start() end,
}
