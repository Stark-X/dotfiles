local _GState = {
    tipsId = nil,
}

return {
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
