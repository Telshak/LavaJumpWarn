local JumpBar = {}
JumpBar.r = 0.2
JumpBar.g = 0.6
JumpBar.b = 1.0

-- progressbar
JumpBar.frame = CreateFrame("StatusBar", "JumpBarFrame", UIParent)
JumpBar.frame:SetWidth(200)
JumpBar.frame:SetHeight(20)
JumpBar.frame:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
JumpBar.frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
JumpBar.frame:SetStatusBarColor(JumpBar.r, JumpBar.g, JumpBar.b)
JumpBar.frame:SetMinMaxValues(0, 1)
JumpBar.frame:SetValue(0)
JumpBar.frame:Hide()

-- Jump window
JumpBar.jumpWindow = JumpBar.frame:CreateTexture(nil, "ARTWORK")
JumpBar.jumpWindow:SetDrawLayer("OVERLAY")
JumpBar.jumpWindow:SetAlpha(1)
JumpBar.jumpWindow:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
JumpBar.jumpWindow:SetVertexColor(1, 1, 0, 0.8) -- Bright yellow
JumpBar.jumpWindow:SetHeight(JumpBar.frame:GetHeight())
JumpBar.jumpWindow:SetPoint("LEFT", JumpBar.frame, "LEFT", JumpBar.frame:GetWidth() * 0.75, 0)
JumpBar.jumpWindow:SetWidth(JumpBar.frame:GetWidth() * 0.25)
JumpBar.jumpWindow:Hide()

-- backdrop - frame
JumpBar.backdrop = CreateFrame("Frame", nil, UIParent)
JumpBar.backdrop:SetWidth(JumpBar.frame:GetWidth() + 8)
JumpBar.backdrop:SetHeight(JumpBar.frame:GetHeight() + 8)
JumpBar.backdrop:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
JumpBar.backdrop:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
JumpBar.backdrop:SetBackdropColor(0, 0, 0, 0.6)
JumpBar.backdrop:SetBackdropBorderColor(1, 1, 1, 1)
JumpBar.backdrop:Hide()

-- little spark during progress bar
local spark = JumpBar.frame:CreateTexture(nil, "OVERLAY")
spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
spark:SetHeight(20)
spark:SetBlendMode("ADD")
spark:SetPoint("CENTER", JumpBar.frame, "LEFT", 0, 0)

-- Attach the progress frame to the backdrop
JumpBar.frame:SetParent(JumpBar.backdrop)
JumpBar.frame:ClearAllPoints()
JumpBar.frame:SetPoint("CENTER", JumpBar.backdrop, "CENTER", 0, 0)

-----------------------
----- functions -------
-----------------------
local function ResetJumpBar()
    JumpBar.startTime = nil
    JumpBar.duration = nil
    JumpBar.frame:SetScript("OnUpdate", nil)
    JumpBar.frame:Hide()
    if JumpBar.backdrop then
        JumpBar.backdrop:Hide()
    end
end

local function UpdateJumpBar()
    if not JumpBar.startTime or not JumpBar.duration then return end

    local elapsed = GetTime() - JumpBar.startTime
    local progress = elapsed / JumpBar.duration

    if progress >= 1 then
        if JumpBar.cyclesRemaining and JumpBar.cyclesRemaining > 1 then
            JumpBar.cyclesRemaining = JumpBar.cyclesRemaining - 1
            JumpBar.startTime = GetTime()
            JumpBar.frame:SetValue(0.01)
            return
        end

        ResetJumpBar()
        return
    end

    JumpBar.frame:SetValue(progress)
    spark:SetPoint("CENTER", JumpBar.frame, "LEFT", (JumpBar.frame:GetWidth() * progress) - 10, 0)

    if progress >= 0.7 then
        JumpBar.jumpWindow:Show()
    else
        JumpBar.jumpWindow:Hide()
    end
end


-----------------------
---- event handler ----
-----------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")

eventFrame:SetScript("OnEvent", function()
    local msg = arg1

    if msg and string.find(msg, "swimming in lava") then
        JumpBar.cyclesRemaining = 3
        JumpBar.startTime = GetTime()
        JumpBar.duration = 2
        JumpBar.frame:SetValue(0.01)
        JumpBar.frame:SetAlpha(1)
        JumpBar.frame:SetFrameStrata("HIGH")
        JumpBar.frame:SetScript("OnUpdate", UpdateJumpBar)
        JumpBar.backdrop:Show()
        JumpBar.frame:Show()
    end
end)



-- Slash command to manually trigger, set cycles, or stop the bar
SLASH_JUMPBAR1 = "/jumpbar"
SlashCmdList["JUMPBAR"] = function(msg)
    local raw = msg
    if raw == nil then raw = "" end
    raw = string.gsub(tostring(raw), "^%s*(.-)%s*$", "%1")
    local arg = string.lower(raw)

    local n = tonumber(arg)

    if arg == "" or arg == "show" then
        JumpBar.cyclesRemaining = 3
    elseif n and n >= 1 then
        JumpBar.cyclesRemaining = math.floor(n)
    elseif arg == "stop" or arg == "reset" then
        ResetJumpBar()
        return
    else
        print("/jumpbar [count]  start with count cycles (default 3)")
        print("/jumpbar show      start with default cycles")
        print("/jumpbar stop||reset stop and hide the bar")
        return
    end

    -- Start/restart the bar
    JumpBar.startTime = GetTime()
    JumpBar.duration = 2
    JumpBar.frame:SetValue(0.01)
    JumpBar.frame:SetAlpha(1)
    JumpBar.frame:SetFrameStrata("HIGH")
    JumpBar.frame:SetScript("OnUpdate", UpdateJumpBar)
    JumpBar.backdrop:Show()
    JumpBar.frame:Show()
end


-- Expose ResetJumpBar for macro use
_G["JumpBar_Reset"] = ResetJumpBar

ResetJumpBar()