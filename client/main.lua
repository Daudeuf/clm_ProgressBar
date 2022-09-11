local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local textJustification = {
    center = 0,
    left = 1,
    right = 2
}

function generateRandomString(length)
    local result = ""
    local length = length or 8

    for i=1, length, 1 do
        local I = math.random(#characters)
        result = result .. string.sub(characters, I, I)
    end

    return result
end

function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function hideHudComponents()
    HideHudComponentThisFrame(6) -- HUD_VEHICLE_NAME
    HideHudComponentThisFrame(7) -- HUD_AREA_NAME
    HideHudComponentThisFrame(8) -- HUD_VEHICLE_CLASS
    HideHudComponentThisFrame(9) -- HUD_STREET_NAME
end

function getColorFromValue(value)
    if type(value) == "table" then
        return value
    else
        local r, g, b, a = getHudColour(value, 0, 0, 0, 0)
        return {r, g, b, a}
    end
end

function drawTextLabel(label, position, options)
    local font = options.font or 0
    local color = options.color or {240, 240, 240, 255}
    local scale = options.scale or 0.5
    local justification = options.justification or textJustification.center
    local wrap = options.wrap or nil
    local shadow = options.shadow or nil
    local outline = options.outline or nil

    SetTextFont(font)
    SetTextScale(0.0, scale)
    SetTextColour(color[1], color[2], color[3], color[4]) -- red, green, blue, alpha
    SetTextJustification(justification)

    if wrap then
        SetTextWrap(0.0, wrap)
    end

    if shadow then
        SetTextDropShadow()
    end

    if outline then
        SetTextOutline()
    end

    BeginTextCommandDisplayText(label)
    EndTextCommandDisplayText(position[1], position[2])
end

function GetCoordsAndSizes()
    return {
        gfxAlignWidth = 0.952,
        gfxAlignHeight = 0.949,
    
        initialX = 0.795,
        initialY = 0.923,
        initialBusySpinnerY = 0.887,
    
        bgBaseX = 0.874,
        progressBaseX = 0.913,
        checkpointBaseX = 0.9445,
    
        bgOffset = 0.008,
        bgThinOffset = 0.012,
        textOffset = -0.011,
        playerTitleOffset = -0.005,
        barOffset = 0.012,
        checkpointOffsetX = 0.0094,
        checkpointOffsetY = 0.012,
    
        timerBarWidth = 0.165,
        timerBarHeight = 0.035,
        timerBarThinHeight = 0.028,
        timerBarMargin = 0.0399,
        timerBarThinMargin = 0.0319,
    
        progressWidth = 0.069,
        progressHeight = 0.011,
    
        checkpointWidth = 0.012,
        checkpointHeight = 0.023,
    
        titleScale = 0.288,
        titleWrap = 0.867,
        textScale = 0.494,
        textWrap = 0.95,
        playerTitleScale = 0.447,

        textJustification = textJustification
    }
end

exports("generateRandomString", generateRandomString)
exports("clamp", clamp)
exports("hideHudComponents", hideHudComponents)
exports("getColorFromValue", getColorFromValue)
exports("drawTextLabel", drawTextLabel)
exports("GetCoordsAndSizes", GetCoordsAndSizes)

local timerBarPool = {}

Citizen.CreateThread(function()
    RequestStreamedTextureDict("timerbars", true)
    local CAS = GetCoordsAndSizes()

    while true do
        local Max = #timerBarPool

        if Max == 0 then
            Citizen.Wait(500)
        else
            Citizen.Wait(0)

            hideHudComponents()

            SetScriptGfxAlign(82, 66)
            SetScriptGfxAlignParams(0.0, 0.0, CAS.gfxAlignWidth, CAS.gfxAlignHeight)

            local drawY = BusyspinnerIsOn() and CAS.initialBusySpinnerY or CAS.initialY

            for i=1, Max, 1 do
                if timerBarPool[i] then
                    timerBarPool[i].Func.InternalDraw(drawY, timerBarPool[i]._Type)
                    drawY = drawY - (timerBarPool[i]._thin and CAS.timerBarThinMargin or CAS.timerBarMargin)
                end
            end

            ResetScriptGfxAlign()
        end
    end
end)

exports("GetAPI", function()
    return {
        add = function(Type, title, text, numCheckPoints)
            local ValidBar = exports["clm_ProgressBar"]:TimerBarBase(Type, title, text, numCheckPoints)
            table.insert(timerBarPool, ValidBar)
            for i=1, #timerBarPool, 1 do
                if timerBarPool[i]._id == ValidBar._id then return timerBarPool[i] end
            end
        end,
        remove = function(_id)
            for i=1, #timerBarPool, 1 do
                if timerBarPool[i]._id == _id then
                    timerBarPool[i] = nil
                end
            end
        end,
        clear = function()
            timerBarPool = {}
        end
    }
end)