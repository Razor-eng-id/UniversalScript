-- =============================================
--         ARCEUS X NEO CLONE
--         By: RizkyEditz
--         Powered by ScriptBlox.com
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =============================================
-- REMOVE OLD GUI
-- =============================================

if LocalPlayer.PlayerGui:FindFirstChild("ArceusXNEO") then
    LocalPlayer.PlayerGui:FindFirstChild("ArceusXNEO"):Destroy()
end

-- =============================================
-- COLORS
-- =============================================

local C = {
    bg          = Color3.fromRGB(18, 18, 22),
    bgPanel     = Color3.fromRGB(24, 24, 30),
    bgCard      = Color3.fromRGB(30, 30, 38),
    bgDark      = Color3.fromRGB(12, 12, 16),
    red         = Color3.fromRGB(220, 38, 38),
    redHover    = Color3.fromRGB(185, 28, 28),
    redDark     = Color3.fromRGB(150, 20, 20),
    blue        = Color3.fromRGB(37, 99, 235),
    blueLight   = Color3.fromRGB(59, 130, 246),
    green       = Color3.fromRGB(34, 197, 94),
    greenDark   = Color3.fromRGB(22, 163, 74),
    yellow      = Color3.fromRGB(234, 179, 8),
    white       = Color3.fromRGB(255, 255, 255),
    text        = Color3.fromRGB(240, 240, 245),
    textSub     = Color3.fromRGB(160, 160, 175),
    textMuted   = Color3.fromRGB(100, 100, 115),
    border      = Color3.fromRGB(45, 45, 58),
    sidebar     = Color3.fromRGB(20, 20, 26),
    header      = Color3.fromRGB(22, 22, 28),
    neo         = Color3.fromRGB(220, 38, 38),
    sliderBg    = Color3.fromRGB(35, 35, 45),
    sliderFill  = Color3.fromRGB(220, 38, 38),
    searchBg    = Color3.fromRGB(28, 28, 36),
    executor    = Color3.fromRGB(10, 10, 14),
    lineNum     = Color3.fromRGB(60, 60, 75),
}

-- =============================================
-- STATE
-- =============================================

local currentPage = "home"
local savedScripts = {}
local executorTabs = {
    {name = "Script 1", content = ""}
}
local activeTabIdx = 1
local gravityVal = 50
local speedVal = 16
local jumpVal = 50
local flyEnabled = false
local noclipEnabled = false
local infJumpEnabled = false
local currentScriptInfo = nil

-- =============================================
-- SCREENGUI
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArceusXNEO"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = LocalPlayer.PlayerGui

-- =============================================
-- MAIN WINDOW
-- =============================================

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 480, 0, 340)
Window.Position = UDim2.new(0.5, -240, 0.5, -170)
Window.BackgroundColor3 = C.bg
Window.BorderSizePixel = 0
Window.Active = true
Window.ClipsDescendants = false
Window.Parent = ScreenGui

Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 10)
local ws = Instance.new("UIStroke", Window)
ws.Color = C.border
ws.Thickness = 1

-- =============================================
-- HEADER
-- =============================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = C.header
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = Window
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = C.header
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 2
HeaderFix.Parent = Header

-- Logo
local LogoImg = Instance.new("TextLabel")
LogoImg.Size = UDim2.new(0, 28, 0, 28)
LogoImg.Position = UDim2.new(0, 10, 0.5, -14)
LogoImg.BackgroundColor3 = C.red
LogoImg.Text = "⚡"
LogoImg.TextSize = 14
LogoImg.Font = Enum.Font.GothamBold
LogoImg.TextColor3 = C.white
LogoImg.BorderSizePixel = 0
LogoImg.ZIndex = 3
LogoImg.Parent = Header
Instance.new("UICorner", LogoImg).CornerRadius = UDim.new(0, 6)

-- "Arceus X" text
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 70, 1, 0)
HeaderTitle.Position = UDim2.new(0, 44, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "Arceus X"
HeaderTitle.TextColor3 = C.text
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 3
HeaderTitle.Parent = Header

-- NEO Badge
local NeoBadge = Instance.new("TextLabel")
NeoBadge.Size = UDim2.new(0, 34, 0, 16)
NeoBadge.Position = UDim2.new(0, 116, 0.5, -8)
NeoBadge.BackgroundColor3 = C.red
NeoBadge.Text = "NEO"
NeoBadge.TextColor3 = C.white
NeoBadge.TextSize = 9
NeoBadge.Font = Enum.Font.GothamBold
NeoBadge.BorderSizePixel = 0
NeoBadge.ZIndex = 3
NeoBadge.Parent = Header
Instance.new("UICorner", NeoBadge).CornerRadius = UDim.new(0, 4)

-- Page Title (dinamis)
local PageIcon = Instance.new("TextLabel")
PageIcon.Size = UDim2.new(0, 24, 0, 24)
PageIcon.Position = UDim2.new(0.5, -80, 0.5, -12)
PageIcon.BackgroundTransparency = 1
PageIcon.Text = "🏠"
PageIcon.TextSize = 14
PageIcon.Font = Enum.Font.GothamBold
PageIcon.ZIndex = 3
PageIcon.Parent = Header

local PageTitle = Instance.new("TextLabel")
PageTitle.Size = UDim2.new(0, 120, 0, 16)
PageTitle.Position = UDim2.new(0.5, -56, 0.5, -14)
PageTitle.BackgroundTransparency = 1
PageTitle.Text = "Home"
PageTitle.TextColor3 = C.text
PageTitle.TextSize = 13
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.ZIndex = 3
PageTitle.Parent = Header

local PageSub = Instance.new("TextLabel")
PageSub.Size = UDim2.new(0, 180, 0, 12)
PageSub.Position = UDim2.new(0.5, -56, 0.5, 2)
PageSub.BackgroundTransparency = 1
PageSub.Text = "Home & Quick Hacks"
PageSub.TextColor3 = C.textMuted
PageSub.TextSize = 9
PageSub.Font = Enum.Font.Gotham
PageSub.TextXAlignment = Enum.TextXAlignment.Left
PageSub.ZIndex = 3
PageSub.Parent = Header

-- Window Buttons
local function makeWinBtn(xOffset, color, symbol)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 22, 0, 22)
    btn.Position = UDim2.new(1, xOffset, 0.5, -11)
    btn.BackgroundColor3 = color
    btn.Text = symbol
    btn.TextColor3 = C.white
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 3
    btn.Parent = Header
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local CloseBtn = makeWinBtn(-28, C.red, "✕")
local MaxBtn = makeWinBtn(-54, C.textMuted, "⊞")
local MinBtn = makeWinBtn(-80, C.textMuted, "—")

-- =============================================
-- SIDEBAR
-- =============================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 44, 1, -44)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = C.sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Sidebar.Parent = Window

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 10, 1, 0)
SidebarFix.Position = UDim2.new(1, -10, 0, 0)
SidebarFix.BackgroundColor3 = C.sidebar
SidebarFix.BorderSizePixel = 0
SidebarFix.ZIndex = 1
SidebarFix.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 2)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 6)
SidebarPad.Parent = Sidebar

-- NEO badge sidebar
local NeoSide = Instance.new("TextLabel")
NeoSide.Size = UDim2.new(0, 36, 0, 16)
NeoSide.BackgroundColor3 = C.red
NeoSide.Text = "NEO"
NeoSide.TextColor3 = C.white
NeoSide.TextSize = 8
NeoSide.Font = Enum.Font.GothamBold
NeoSide.BorderSizePixel = 0
NeoSide.LayoutOrder = 0
NeoSide.ZIndex = 3
NeoSide.Parent = Sidebar
Instance.new("UICorner", NeoSide).CornerRadius = UDim.new(0, 4)

local sidePages = {
    {id="home",    icon="🏠", order=1},
    {id="appinfo", icon="ℹ️",  order=2},
    {id="files",   icon="⚡",  order=3},
    {id="executor",icon="</>", order=4},
    {id="scripthub",icon="📄", order=5},
}

local sideButtons = {}

local function makeSideBtn(data)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 36)
    btn.BackgroundColor3 = data.id == "home" and C.red or Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = data.id == "home" and 0 or 0.7
    btn.Text = data.icon
    btn.TextSize = data.id == "executor" and 9 or 14
    btn.Font = data.id == "executor" and Enum.Font.GothamBold or Enum.Font.Gotham
    btn.TextColor3 = C.text
    btn.BorderSizePixel = 0
    btn.LayoutOrder = data.order
    btn.ZIndex = 3
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    -- Active indicator
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Position = UDim2.new(0, -2, 0.2, 0)
    indicator.BackgroundColor3 = C.red
    indicator.BorderSizePixel = 0
    indicator.Visible = data.id == "home"
    indicator.ZIndex = 4
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    sideButtons[data.id] = {btn = btn, indicator = indicator}
    return btn
end

for _, data in ipairs(sidePages) do
    makeSideBtn(data)
end

-- =============================================
-- CONTENT AREA
-- =============================================

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -44, 1, -44)
ContentArea.Position = UDim2.new(0, 44, 0, 44)
ContentArea.BackgroundColor3 = C.bgPanel
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.Parent = Window

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentArea

local ContentFixTL = Instance.new("Frame")
ContentFixTL.Size = UDim2.new(0, 10, 0, 10)
ContentFixTL.BackgroundColor3 = C.bgPanel
ContentFixTL.BorderSizePixel = 0
ContentFixTL.Parent = ContentArea

local ContentFixBL = Instance.new("Frame")
ContentFixBL.Size = UDim2.new(0, 10, 0, 10)
ContentFixBL.Position = UDim2.new(0, 0, 1, -10)
ContentFixBL.BackgroundColor3 = C.bgPanel
ContentFixBL.BorderSizePixel = 0
ContentFixBL.Parent = ContentArea

-- =============================================
-- PAGES CONTAINER
-- =============================================

local Pages = {}

local function newPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ClipsDescendants = true
    page.Parent = ContentArea
    Pages[name] = page
    return page
end

-- =============================================
-- HELPER UI FUNCTIONS
-- =============================================

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function makeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.border
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function makeLabel(parent, text, size, color, font, xAlign)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextSize = size or 12
    lbl.TextColor3 = color or C.text
    lbl.Font = font or Enum.Font.Gotham
    lbl.TextXAlignment = xAlign or Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function makeRedBtn(parent, text, size, pos, w, h)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, w or 80, 0, h or 26)
    btn.Position = pos
    btn.BackgroundColor3 = C.red
    btn.Text = text
    btn.TextColor3 = C.white
    btn.TextSize = size or 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    makeCorner(btn, 6)
    return btn
end

-- =============================================
-- PAGE: HOME
-- =============================================

local HomePage = newPage("home")

-- Left Panel
local HomeLeft = Instance.new("Frame")
HomeLeft.Size = UDim2.new(0, 195, 1, 0)
HomeLeft.BackgroundTransparency = 1
HomeLeft.Parent = HomePage

local HomePad = Instance.new("UIPadding")
HomePad.PaddingLeft = UDim.new(0, 12)
HomePad.PaddingTop = UDim.new(0, 10)
HomePad.Parent = HomeLeft

-- Avatar
local AvatarFrame = Instance.new("Frame")
AvatarFrame.Size = UDim2.new(0, 36, 0, 36)
AvatarFrame.Position = UDim2.new(0, 0, 0, 0)
AvatarFrame.BackgroundColor3 = C.textMuted
AvatarFrame.BorderSizePixel = 0
AvatarFrame.Parent = HomeLeft
makeCorner(AvatarFrame, 18)

local AvatarLbl = makeLabel(AvatarFrame, "👤", 18, C.white, Enum.Font.Gotham, Enum.TextXAlignment.Center)
AvatarLbl.Size = UDim2.new(1, 0, 1, 0)
AvatarLbl.TextYAlignment = Enum.TextYAlignment.Center

-- Username
local UsernameLbl = makeLabel(HomeLeft, LocalPlayer.Name, 13, C.text, Enum.Font.GothamBold)
UsernameLbl.Size = UDim2.new(1, -45, 0, 18)
UsernameLbl.Position = UDim2.new(0, 42, 0, 2)

-- Key Status
local KeyStatusTitle = makeLabel(HomeLeft, "Key System Status", 11, C.text, Enum.Font.GothamBold)
KeyStatusTitle.Size = UDim2.new(1, 0, 0, 16)
KeyStatusTitle.Position = UDim2.new(0, 0, 0, 44)

local KeyOnline = makeLabel(HomeLeft, "● ONLINE", 10, C.green, Enum.Font.GothamBold)
KeyOnline.Size = UDim2.new(1, 0, 0, 14)
KeyOnline.Position = UDim2.new(0, 0, 0, 60)

local KeyExpiry = makeLabel(HomeLeft, "Expires in: 21h06m", 9, C.textMuted, Enum.Font.Gotham)
KeyExpiry.Size = UDim2.new(1, 0, 0, 12)
KeyExpiry.Position = UDim2.new(0, 0, 0, 74)

-- Progress Bar
local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(0.85, 0, 0, 6)
ProgressBg.Position = UDim2.new(0, 0, 0, 88)
ProgressBg.BackgroundColor3 = C.bgDark
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = HomeLeft
makeCorner(ProgressBg, 3)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0.67, 0, 1, 0)
ProgressFill.BackgroundColor3 = C.yellow
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBg
makeCorner(ProgressFill, 3)

-- Restore Button
local RestoreBtn = makeRedBtn(HomeLeft, "Restore", 12, UDim2.new(0, 0, 0, 102), 130, 28)

-- Quick Hacks Label
local QHLabel = makeLabel(HomeLeft, "Quick Hacks", 11, C.text, Enum.Font.GothamBold)
QHLabel.Size = UDim2.new(1, 0, 0, 16)
QHLabel.Position = UDim2.new(0, 0, 0, 138)

-- Quick Hacks Grid
local QHGrid = Instance.new("Frame")
QHGrid.Size = UDim2.new(0.95, 0, 0, 118)
QHGrid.Position = UDim2.new(0, 0, 0, 155)
QHGrid.BackgroundTransparency = 1
QHGrid.Parent = HomeLeft

local QHLayout = Instance.new("UIGridLayout")
QHLayout.CellSize = UDim2.new(0, 78, 0, 22)
QHLayout.CellPadding = UDim2.new(0, 4, 0, 4)
QHLayout.SortOrder = Enum.SortOrder.LayoutOrder
QHLayout.Parent = QHGrid

local quickHacks = {
    "Fly", "Aimbot", "Shiftlock", "Keyboard",
    "Fps Unlocker", "Infinite Yield", "DEX Explorer",
    "Fates ESP", "BTools", "Owl Hub", "Pwner Hub"
}

local hackScripts = {
    ["Fly"] = [[
        local p = game.Players.LocalPlayer
        local char = p.Character
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        local flying = false
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
        bg.P = 1e4
        local speed = 50
        flying = true
        bv.Parent = hrp
        bg.Parent = hrp
        game:GetService("RunService").Heartbeat:Connect(function()
            if flying then
                local cf = workspace.CurrentCamera.CFrame
                local move = Vector3.new(0,0,0)
                local uis = game:GetService("UserInputService")
                if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
                bv.Velocity = move * speed
                bg.CFrame = cf
            end
        end)
    ]],
    ["Infinite Yield"] = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infinite-yield/master/source'))()]],
    ["DEX Explorer"] = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/LorekeeperZinnia/Dex/master/Dex3.1.lua'))()]],
    ["Owl Hub"] = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ChloeSpacedOut/OwlHub/master/Source"))()]],
    ["BTools"] = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/SPDM-Team/ArceusX-V3-Scripts/main/BTools.lua"))()]],
    ["Fates ESP"] = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/SPDM-Team/ArceusX-V3-Scripts/main/Fates-ESP.lua"))()]],
    ["Pwner Hub"] = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/SPDM-Team/ArceusX-V3-Scripts/main/Pwner-Hub.lua"))()]],
}

for i, hackName in ipairs(quickHacks) do
    local hackBtn = Instance.new("TextButton")
    hackBtn.BackgroundColor3 = C.red
    hackBtn.Text = hackName
    hackBtn.TextColor3 = C.white
    hackBtn.TextSize = 9
    hackBtn.Font = Enum.Font.GothamBold
    hackBtn.BorderSizePixel = 0
    hackBtn.LayoutOrder = i
    hackBtn.Parent = QHGrid
    makeCorner(hackBtn, 5)

    hackBtn.MouseButton1Click:Connect(function()
        local script = hackScripts[hackName]
        if script then
            pcall(function() loadstring(script)() end)
        else
            warn("[ArceusX] No script for: " .. hackName)
        end
    end)
end

-- Right Panel (Sliders)
local HomeRight = Instance.new("Frame")
HomeRight.Size = UDim2.new(0, 68, 1, -10)
HomeRight.Position = UDim2.new(1, -75, 0, 5)
HomeRight.BackgroundTransparency = 1
HomeRight.Parent = HomePage

local function makeSlider(parent, label, defaultVal, yPos, onChanged)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 80)
    SliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local ValLbl = makeLabel(SliderFrame, defaultVal .. "%", 9, C.text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    ValLbl.Size = UDim2.new(1, 0, 0, 14)
    ValLbl.Position = UDim2.new(0, 0, 0, 0)

    local TrackBg = Instance.new("Frame")
    TrackBg.Size = UDim2.new(0, 10, 0, 55)
    TrackBg.Position = UDim2.new(0.5, -5, 0, 16)
    TrackBg.BackgroundColor3 = C.sliderBg
    TrackBg.BorderSizePixel = 0
    TrackBg.Parent = SliderFrame
    makeCorner(TrackBg, 5)

    local TrackFill = Instance.new("Frame")
    TrackFill.Size = UDim2.new(1, 0, defaultVal/100, 0)
    TrackFill.Position = UDim2.new(0, 0, 1-(defaultVal/100), 0)
    TrackFill.BackgroundColor3 = C.red
    TrackFill.BorderSizePixel = 0
    TrackFill.Parent = TrackBg
    makeCorner(TrackFill, 5)

    local LabelLbl = makeLabel(SliderFrame, label, 9, C.textSub, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    LabelLbl.Size = UDim2.new(1, 0, 0, 12)
    LabelLbl.Position = UDim2.new(0, 0, 0, 68)

    local dragging = false
    TrackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    TrackBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    TrackBg.InputChanged:Connect(function(input)
        if dragging then
            local relY = (input.Position.Y - TrackBg.AbsolutePosition.Y) / TrackBg.AbsoluteSize.Y
            local val = math.clamp(math.floor((1 - relY) * 100), 0, 100)
            ValLbl.Text = val .. "%"
            TrackFill.Size = UDim2.new(1, 0, val/100, 0)
            TrackFill.Position = UDim2.new(0, 0, 1-(val/100), 0)
            if onChanged then onChanged(val) end
        end
    end)

    return SliderFrame
end

makeSlider(HomeRight, "Gravity", gravityVal, 5, function(v)
    gravityVal = v
    workspace.Gravity = v * 1.96
end)

makeSlider(HomeRight, "Speed", 30, 90, function(v)
    speedVal = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v * 0.32 end
    end
end)

makeSlider(HomeRight, "Jump", jumpVal, 175, function(v)
    jumpVal = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v * 1.0 end
    end
end)

-- Welcome text
local WelcomeLbl = makeLabel(HomeLeft, "Welcome to the Built-In Hacks section!", 8, C.textMuted, Enum.Font.Gotham)
WelcomeLbl.Size = UDim2.new(0.9, 0, 0, 12)
WelcomeLbl.Position = UDim2.new(0, 0, 1, -18)

-- =============================================
-- PAGE: APP INFO
-- =============================================

local AppInfoPage = newPage("appinfo")

local AIPad = Instance.new("UIPadding")
AIPad.PaddingLeft = UDim.new(0, 12)
AIPad.PaddingTop = UDim.new(0, 10)
AIPad.PaddingRight = UDim.new(0, 12)
AIPad.Parent = AppInfoPage

-- Left: About Us
local AboutLeft = Instance.new("Frame")
AboutLeft.Size = UDim2.new(0.45, 0, 1, -20)
AboutLeft.BackgroundTransparency = 1
AboutLeft.Parent = AppInfoPage

-- SPDM Team Logo
local SPDMFrame = Instance.new("Frame")
SPDMFrame.Size = UDim2.new(1, 0, 0, 50)
SPDMFrame.BackgroundColor3 = C.red
SPDMFrame.BorderSizePixel = 0
SPDMFrame.Parent = AboutLeft
makeCorner(SPDMFrame, 8)

local SPDMLabel = makeLabel(SPDMFrame, "⚡ SPDM Team", 14, C.white, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
SPDMLabel.Size = UDim2.new(1, 0, 1, 0)
SPDMLabel.TextYAlignment = Enum.TextYAlignment.Center

local AboutTitle = makeLabel(AboutLeft, "About us", 11, C.text, Enum.Font.GothamBold)
AboutTitle.Size = UDim2.new(1, 0, 0, 18)
AboutTitle.Position = UDim2.new(0, 0, 0, 58)

local devList = {
    {name = "RizkyEditz", role = "Developer"},
}

for i, dev in ipairs(devList) do
    local DevRow = Instance.new("Frame")
    DevRow.Size = UDim2.new(1, 0, 0, 36)
    DevRow.Position = UDim2.new(0, 0, 0, 58 + (i * 40))
    DevRow.BackgroundColor3 = C.bgCard
    DevRow.BorderSizePixel = 0
    DevRow.Parent = AboutLeft
    makeCorner(DevRow, 8)

    local DevAvatar = Instance.new("Frame")
    DevAvatar.Size = UDim2.new(0, 26, 0, 26)
    DevAvatar.Position = UDim2.new(0, 5, 0.5, -13)
    DevAvatar.BackgroundColor3 = C.red
    DevAvatar.BorderSizePixel = 0
    DevAvatar.Parent = DevRow
    makeCorner(DevAvatar, 13)

    local DevAvatarLbl = makeLabel(DevAvatar, "👤", 12, C.white, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    DevAvatarLbl.Size = UDim2.new(1, 0, 1, 0)
    DevAvatarLbl.TextYAlignment = Enum.TextYAlignment.Center

    local DevName = makeLabel(DevRow, dev.name, 11, C.text, Enum.Font.GothamBold)
    DevName.Size = UDim2.new(1, -40, 0, 16)
    DevName.Position = UDim2.new(0, 36, 0, 4)

    local DevRole = makeLabel(DevRow, dev.role, 9, C.textMuted, Enum.Font.Gotham)
    DevRole.Size = UDim2.new(1, -40, 0, 12)
    DevRole.Position = UDim2.new(0, 36, 0, 20)
end

-- Right: Changelog
local ChangelogRight = Instance.new("Frame")
ChangelogRight.Size = UDim2.new(0.52, 0, 1, -20)
ChangelogRight.Position = UDim2.new(0.47, 0, 0, 0)
ChangelogRight.BackgroundTransparency = 1
ChangelogRight.Parent = AppInfoPage

local CLHeader = Instance.new("Frame")
CLHeader.Size = UDim2.new(1, 0, 0, 28)
CLHeader.BackgroundColor3 = C.bgCard
CLHeader.BorderSizePixel = 0
CLHeader.Parent = ChangelogRight
makeCorner(CLHeader, 8)

local CLTitle = makeLabel(CLHeader, "Changelog", 12, C.text, Enum.Font.GothamBold)
CLTitle.Size = UDim2.new(0.6, 0, 1, 0)
CLTitle.Position = UDim2.new(0, 10, 0, 0)
CLTitle.TextYAlignment = Enum.TextYAlignment.Center

local CLVersion = makeLabel(CLHeader, "v1.0.3", 11, C.red, Enum.Font.GothamBold)
CLVersion.Size = UDim2.new(0.35, 0, 1, 0)
CLVersion.Position = UDim2.new(0.63, 0, 0, 0)
CLVersion.TextXAlignment = Enum.TextXAlignment.Right
CLVersion.TextYAlignment = Enum.TextYAlignment.Center

local CLScroll = Instance.new("ScrollingFrame")
CLScroll.Size = UDim2.new(1, 0, 1, -36)
CLScroll.Position = UDim2.new(0, 0, 0, 34)
CLScroll.BackgroundTransparency = 1
CLScroll.BorderSizePixel = 0
CLScroll.ScrollBarThickness = 3
CLScroll.ScrollBarImageColor3 = C.red
CLScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CLScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
CLScroll.Parent = ChangelogRight

local CLLayout = Instance.new("UIListLayout")
CLLayout.Padding = UDim.new(0, 6)
CLLayout.Parent = CLScroll

local changeLogs = {
    {title = "Brand Evolution", desc = "New Name, New Era: Arceus X evolves into 'Arceus X NEO', marking a new chapter with complete overhaul of both frontend and backend."},
    {title = "Redesigned Aesthetics", desc = "Experience a fresh look with entirely revamped colors, icons, and enhanced transitions."},
    {title = "Introducing Scrollable Panels", desc = "Panels are now scrollable for a smoother navigation experience."},
    {title = "ScriptBlox Integration", desc = "Search and execute scripts directly from ScriptBlox cloud."},
}

for i, log in ipairs(changeLogs) do
    local LogCard = Instance.new("Frame")
    LogCard.Size = UDim2.new(1, -4, 0, 60)
    LogCard.BackgroundColor3 = C.bgCard
    LogCard.BorderSizePixel = 0
    LogCard.LayoutOrder = i
    LogCard.Parent = CLScroll
    makeCorner(LogCard, 8)

    local LogTitle = makeLabel(LogCard, log.title, 10, C.green, Enum.Font.GothamBold)
    LogTitle.Size = UDim2.new(1, -10, 0, 16)
    LogTitle.Position = UDim2.new(0, 8, 0, 6)

    local LogDesc = makeLabel(LogCard, log.desc, 9, C.textSub, Enum.Font.Gotham)
    LogDesc.Size = UDim2.new(1, -16, 0, 36)
    LogDesc.Position = UDim2.new(0, 8, 0, 22)
    LogDesc.TextWrapped = true
end

-- =============================================
-- PAGE: FILES
-- =============================================

local FilesPage = newPage("files")

local FilesHeader = Instance.new("Frame")
FilesHeader.Size = UDim2.new(1, -20, 0, 32)
FilesHeader.Position = UDim2.new(0, 10, 0, 8)
FilesHeader.BackgroundTransparency = 1
FilesHeader.Parent = FilesPage

local FilesTitleLbl = makeLabel(FilesHeader, "⚡ Saved Scripts", 13, C.text, Enum.Font.GothamBold)
FilesTitleLbl.Size = UDim2.new(0.6, 0, 1, 0)
FilesTitleLbl.TextYAlignment = Enum.TextYAlignment.Center

local FilesScroll = Instance.new("ScrollingFrame")
FilesScroll.Size = UDim2.new(1, -20, 1, -55)
FilesScroll.Position = UDim2.new(0, 10, 0, 45)
FilesScroll.BackgroundTransparency = 1
FilesScroll.BorderSizePixel = 0
FilesScroll.ScrollBarThickness = 3
FilesScroll.ScrollBarImageColor3 = C.red
FilesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
FilesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
FilesScroll.Parent = FilesPage

local FilesLayout = Instance.new("UIListLayout")
FilesLayout.Padding = UDim.new(0, 6)
FilesLayout.Parent = FilesScroll

local EmptyLbl = makeLabel(FilesScroll, "📂 Belum ada script tersimpan.\nExecute script lalu klik Save!", 11, C.textMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
EmptyLbl.Size = UDim2.new(1, 0, 0, 60)
EmptyLbl.TextWrapped = true
EmptyLbl.Name = "EmptyLabel"

local function refreshFilesList()
    for _, c in pairs(FilesScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    EmptyLbl.Visible = #savedScripts == 0

    for i, s in ipairs(savedScripts) do
        local FileCard = Instance.new("Frame")
        FileCard.Size = UDim2.new(1, 0, 0, 38)
        FileCard.BackgroundColor3 = C.bgCard
        FileCard.BorderSizePixel = 0
        FileCard.LayoutOrder = i
        FileCard.Parent = FilesScroll
        makeCorner(FileCard, 8)

        local FileIcon = makeLabel(FileCard, "📄", 14, C.white, Enum.Font.Gotham, Enum.TextXAlignment.Center)
        FileIcon.Size = UDim2.new(0, 30, 1, 0)

        local FileName = makeLabel(FileCard, s.name, 11, C.text, Enum.Font.GothamBold)
        FileName.Size = UDim2.new(1, -110, 0, 16)
        FileName.Position = UDim2.new(0, 34, 0, 5)

        local FileSize = makeLabel(FileCard, #s.content .. " chars", 9, C.textMuted, Enum.Font.Gotham)
        FileSize.Size = UDim2.new(1, -110, 0, 12)
        FileSize.Position = UDim2.new(0, 34, 0, 22)

        local LoadBtn = makeRedBtn(FileCard, "Load", 10, UDim2.new(1, -85, 0.5, -11), 38, 22)
        LoadBtn.MouseButton1Click:Connect(function()
            executorTabs[activeTabIdx].content = s.content
            -- Switch ke executor
        end)

        local DelBtn = Instance.new("TextButton")
        DelBtn.Size = UDim2.new(0, 38, 0, 22)
        DelBtn.Position = UDim2.new(1, -44, 0.5, -11)
        DelBtn.BackgroundColor3 = C.bgDark
        DelBtn.Text = "🗑"
        DelBtn.TextSize = 12
        DelBtn.Font = Enum.Font.Gotham
        DelBtn.BorderSizePixel = 0
        DelBtn.Parent = FileCard
        makeCorner(DelBtn, 6)

        DelBtn.MouseButton1Click:Connect(function()
            table.remove(savedScripts, i)
            refreshFilesList()
        end)
    end
end

refreshFilesList()

-- =============================================
-- PAGE: EXECUTOR
-- =============================================

local ExecutorPage = newPage("executor")

-- Tab bar
local ExecTabBar = Instance.new("Frame")
ExecTabBar.Size = UDim2.new(1, -20, 0, 26)
ExecTabBar.Position = UDim2.new(0, 10, 0, 8)
ExecTabBar.BackgroundTransparency = 1
ExecTabBar.Parent = ExecutorPage

local ExecTabLayout = Instance.new("UIListLayout")
ExecTabLayout.FillDirection = Enum.FillDirection.Horizontal
ExecTabLayout.Padding = UDim.new(0, 4)
ExecTabLayout.Parent = ExecTabBar

local tabFrames = {}

local function refreshExecTabs()
    for _, c in pairs(ExecTabBar:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    tabFrames = {}

    for i, tab in ipairs(executorTabs) do
        local TabF = Instance.new("Frame")
        TabF.Size = UDim2.new(0, 80, 1, 0)
        TabF.BackgroundColor3 = i == activeTabIdx and C.bgCard or C.bgDark
        TabF.BorderSizePixel = 0
        TabF.LayoutOrder = i
        TabF.Parent = ExecTabBar
        makeCorner(TabF, 6)

        local TabLbl = makeLabel(TabF, tab.name, 10, i == activeTabIdx and C.text or C.textMuted, Enum.Font.GothamBold)
        TabLbl.Size = UDim2.new(1, -22, 1, 0)
        TabLbl.Position = UDim2.new(0, 6, 0, 0)
        TabLbl.TextYAlignment = Enum.TextYAlignment.Center

        local TabClose = Instance.new("TextButton")
        TabClose.Size = UDim2.new(0, 16, 0, 16)
        TabClose.Position = UDim2.new(1, -18, 0.5, -8)
        TabClose.BackgroundColor3 = C.red
        TabClose.Text = "✕"
        TabClose.TextSize = 8
        TabClose.TextColor3 = C.white
        TabClose.Font = Enum.Font.GothamBold
        TabClose.BorderSizePixel = 0
        TabClose.Parent = TabF
        makeCorner(TabClose, 4)

        TabF.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                activeTabIdx = i
                refreshExecTabs()
            end
        end)

        TabClose.MouseButton1Click:Connect(function()
            if #executorTabs > 1 then
                table.remove(executorTabs, i)
                if activeTabIdx > #executorTabs then activeTabIdx = #executorTabs end
                refreshExecTabs()
            end
        end)

        tabFrames[i] = TabF
    end
end

refreshExecTabs()

-- Editor Frame
local EditorFrame = Instance.new("Frame")
EditorFrame.Size = UDim2.new(1, -20, 1, -84)
EditorFrame.Position = UDim2.new(0, 10, 0, 38)
EditorFrame.BackgroundColor3 = C.executor
EditorFrame.BorderSizePixel = 0
EditorFrame.ClipsDescendants = true
EditorFrame.Parent = ExecutorPage
makeCorner(EditorFrame, 8)
makeStroke(EditorFrame, C.border, 1)

-- Line numbers
local LineNums = Instance.new("Frame")
LineNums.Size = UDim2.new(0, 24, 1, 0)
LineNums.BackgroundColor3 = C.bgDark
LineNums.BorderSizePixel = 0
LineNums.Parent = EditorFrame

local LineNumsLbl = makeLabel(LineNums, "1\n2\n3\n4\n5\n6\n7\n8", 10, C.lineNum, Enum.Font.Code, Enum.TextXAlignment.Center)
LineNumsLbl.Size = UDim2.new(1, 0, 1, 0)
LineNumsLbl.TextYAlignment = Enum.TextYAlignment.Top
LineNumsLbl.Position = UDim2.new(0, 0, 0, 6)

-- Text Box
local EditorBox = Instance.new("TextBox")
EditorBox.Size = UDim2.new(1, -28, 1, 0)
EditorBox.Position = UDim2.new(0, 26, 0, 0)
EditorBox.BackgroundTransparency = 1
EditorBox.PlaceholderText = "Insert text here..."
EditorBox.PlaceholderColor3 = C.textMuted
EditorBox.Text = ""
EditorBox.TextColor3 = Color3.fromRGB(180, 210, 255)
EditorBox.TextSize = 11
EditorBox.Font = Enum.Font.Code
EditorBox.TextXAlignment = Enum.TextXAlignment.Left
EditorBox.TextYAlignment = Enum.TextYAlignment.Top
EditorBox.MultiLine = true
EditorBox.ClearTextOnFocus = false
EditorBox.TextWrapped = false
EditorBox.Parent = EditorFrame

local EditorPad = Instance.new("UIPadding")
EditorPad.PaddingLeft = UDim.new(0, 6)
EditorPad.PaddingTop = UDim.new(0, 6)
EditorPad.Parent = EditorBox

-- Bottom Buttons
local ExecBtnBar = Instance.new("Frame")
ExecBtnBar.Size = UDim2.new(1, -20, 0, 30)
ExecBtnBar.Position = UDim2.new(0, 10, 1, -36)
ExecBtnBar.BackgroundTransparency = 1
ExecBtnBar.Parent = ExecutorPage

local ExecBtnLayout = Instance.new("UIListLayout")
ExecBtnLayout.FillDirection = Enum.FillDirection.Horizontal
ExecBtnLayout.Padding = UDim.new(0, 5)
ExecBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ExecBtnLayout.Parent = ExecBtnBar

local function makeExecBtn(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.BackgroundColor3 = color or C.blue
    btn.Text = text
    btn.TextColor3 = C.white
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = ExecBtnBar
    makeCorner(btn, 7)
    return btn
end

local ExecRunBtn = makeExecBtn("Execute ▶", C.green)
local ExecClearBtn = makeExecBtn("Clear 🗑", C.blue)
local ExecCopyBtn = makeExecBtn("Copy 📋", C.blue)
local ExecPasteBtn = makeExecBtn("Paste 📋", C.blue)
local ExecNewBtn = makeExecBtn("New ✕", C.blue)
local ExecSaveBtn = makeExecBtn("Save 💾", C.red)

ExecRunBtn.MouseButton1Click:Connect(function()
    local code = EditorBox.Text
    if code ~= "" then
        pcall(function() loadstring(code)() end)
    end
end)

ExecClearBtn.MouseButton1Click:Connect(function()
    EditorBox.Text = ""
    executorTabs[activeTabIdx].content = ""
end)

ExecCopyBtn.MouseButton1Click:Connect(function()
    setclipboard(EditorBox.Text)
end)

ExecPasteBtn.MouseButton1Click:Connect(function()
    EditorBox.Text = getclipboard()
end)

ExecNewBtn.MouseButton1Click:Connect(function()
    table.insert(executorTabs, {name = "Script " .. (#executorTabs + 1), content = ""})
    activeTabIdx = #executorTabs
    EditorBox.Text = ""
    refreshExecTabs()
end)

ExecSaveBtn.MouseButton1Click:Connect(function()
    local code = EditorBox.Text
    if code ~= "" then
        table.insert(savedScripts, {
            name = "Script " .. (#savedScripts + 1),
            content = code
        })
        refreshFilesList()
    end
end)

EditorBox:GetPropertyChangedSignal("Text"):Connect(function()
    executorTabs[activeTabIdx].content = EditorBox.Text
    -- Update line numbers
    local lines = #string.split(EditorBox.Text, "\n")
    local lineStr = ""
    for i = 1, math.max(lines, 8) do
        lineStr = lineStr .. i .. "\n"
    end
    LineNumsLbl.Text = lineStr
end)

-- =============================================
-- PAGE: SCRIPT HUB
-- =============================================

local ScriptHubPage = newPage("scripthub")

-- Top Bar
local SHTopBar = Instance.new("Frame")
SHTopBar.Size = UDim2.new(1, -20, 0, 30)
SHTopBar.Position = UDim2.new(0, 10, 0, 8)
SHTopBar.BackgroundTransparency = 1
SHTopBar.Parent = ScriptHubPage

local SHBtnLayout = Instance.new("UIListLayout")
SHBtnLayout.FillDirection = Enum.FillDirection.Horizontal
SHBtnLayout.Padding = UDim.new(0, 5)
SHBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
SHBtnLayout.Parent = SHTopBar

local SHExecBtn = makeRedBtn(SHTopBar, "Execute ▶", 10, UDim2.new(0,0,0,0), 80, 26)
SHExecBtn.BackgroundColor3 = C.green
SHExecBtn.Parent = SHTopBar

local SHOpenBtn = makeRedBtn(SHTopBar, "Open </>", 10, UDim2.new(0,0,0,0), 76, 26)
SHOpenBtn.BackgroundColor3 = C.blue
SHOpenBtn.Parent = SHTopBar

-- Search Bar
local SHSearchContainer = Instance.new("Frame")
SHSearchContainer.Size = UDim2.new(0, 120, 0, 26)
SHSearchContainer.BackgroundColor3 = C.searchBg
SHSearchContainer.BorderSizePixel = 0
SHSearchContainer.Parent = SHTopBar
makeCorner(SHSearchContainer, 7)
makeStroke(SHSearchContainer, C.border, 1)

local SHSearchIcon = makeLabel(SHSearchContainer, "🔍", 11, C.textMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
SHSearchIcon.Size = UDim2.new(0, 22, 1, 0)

local SHSearchBox = Instance.new("TextBox")
SHSearchBox.Size = UDim2.new(1, -24, 1, 0)
SHSearchBox.Position = UDim2.new(0, 22, 0, 0)
SHSearchBox.BackgroundTransparency = 1
SHSearchBox.PlaceholderText = "Search..."
SHSearchBox.PlaceholderColor3 = C.textMuted
SHSearchBox.Text = ""
SHSearchBox.TextColor3 = C.text
SHSearchBox.TextSize = 10
SHSearchBox.Font = Enum.Font.Gotham
SHSearchBox.TextXAlignment = Enum.TextXAlignment.Left
SHSearchBox.ClearTextOnFocus = false
SHSearchBox.Parent = SHSearchContainer

-- Script Grid
local SHScroll = Instance.new("ScrollingFrame")
SHScroll.Size = UDim2.new(1, -20, 1, -88)
SHScroll.Position = UDim2.new(0, 10, 0, 42)
SHScroll.BackgroundTransparency = 1
SHScroll.BorderSizePixel = 0
SHScroll.ScrollBarThickness = 3
SHScroll.ScrollBarImageColor3 = C.red
SHScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SHScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SHScroll.Parent = ScriptHubPage

local SHGrid = Instance.new("UIGridLayout")
SHGrid.CellSize = UDim2.new(0, 100, 0, 80)
SHGrid.CellPadding = UDim2.new(0, 6, 0, 6)
SHGrid.SortOrder = Enum.SortOrder.LayoutOrder
SHGrid.Parent = SHScroll

-- Info Bar
local SHInfoBar = Instance.new("Frame")
SHInfoBar.Size = UDim2.new(1, -20, 0, 22)
SHInfoBar.Position = UDim2.new(0, 10, 1, -28)
SHInfoBar.BackgroundColor3 = C.bgCard
SHInfoBar.BorderSizePixel = 0
SHInfoBar.Parent = ScriptHubPage
makeCorner(SHInfoBar, 6)

local SHInfoLbl = makeLabel(SHInfoBar, "Select a script to see info", 9, C.textMuted, Enum.Font.Gotham)
SHInfoLbl.Size = UDim2.new(0.5, 0, 1, 0)
SHInfoLbl.Position = UDim2.new(0, 8, 0, 0)
SHInfoLbl.TextYAlignment = Enum.TextYAlignment.Center

local SHViewsLbl = makeLabel(SHInfoBar, "", 9, C.textMuted, Enum.Font.Gotham)
SHViewsLbl.Size = UDim2.new(0.2, 0, 1, 0)
SHViewsLbl.Position = UDim2.new(0.5, 0, 0, 0)
SHViewsLbl.TextYAlignment = Enum.TextYAlignment.Center

local SHKeyLbl = makeLabel(SHInfoBar, "", 9, C.green, Enum.Font.GothamBold)
SHKeyLbl.Size = UDim2.new(0.2, 0, 1, 0)
SHKeyLbl.Position = UDim2.new(0.75, 0, 0, 0)
SHKeyLbl.TextYAlignment = Enum.TextYAlignment.Center

local SHInfoBtn = Instance.new("TextButton")
SHInfoBtn.Size = UDim2.new(0, 20, 0, 20)
SHInfoBtn.Position = UDim2.new(1, -24, 0.5, -10)
SHInfoBtn.BackgroundColor3 = C.blue
SHInfoBtn.Text = "ℹ"
SHInfoBtn.TextColor3 = C.white
SHInfoBtn.TextSize = 10
SHInfoBtn.Font = Enum.Font.GothamBold
SHInfoBtn.BorderSizePixel = 0
SHInfoBtn.Parent = SHInfoBar
makeCorner(SHInfoBtn, 10)

-- SH Loading Label
local SHStatusLbl = makeLabel(SHScroll, "⏳ Memuat scripts...", 11, C.textMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
SHStatusLbl.Size = UDim2.new(1, 0, 0, 30)
SHStatusLbl.Name = "SHStatus"

local selectedScript = nil

local function buildSHCard(scriptData, order)
    local title = scriptData.title or "Unknown"
    local gameName = (scriptData.game and scriptData.game.name) or "Universal"
    local views = scriptData.views or 0
    local isPatched = scriptData.isPatched or false
    local hasKey = scriptData.key or false
    local verified = scriptData.verified or false
    local slug = scriptData.slug or ""
    local scriptContent = scriptData.script or ""

    local Card = Instance.new("Frame")
    Card.BackgroundColor3 = C.bgCard
    Card.BorderSizePixel = 0
    Card.LayoutOrder = order
    Card.Parent = SHScroll
    makeCorner(Card, 8)
    makeStroke(Card, C.border, 1)

    -- User icon
    local UserIcon = makeLabel(Card, "👤", 14, C.textMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    UserIcon.Size = UDim2.new(1, 0, 0, 22)
    UserIcon.Position = UDim2.new(0, 0, 0, 2)

    -- Today label
    local TodayLbl = makeLabel(Card, "Today", 8, C.textMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    TodayLbl.Size = UDim2.new(1, 0, 0, 12)
    TodayLbl.Position = UDim2.new(0, 0, 0, 2)

    -- Game name
    local GameLbl = makeLabel(Card, gameName, 8, C.textMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    GameLbl.Size = UDim2.new(1, -4, 0, 12)
    GameLbl.Position = UDim2.new(0, 2, 0, 24)
    GameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- Title
    local TitleLbl = makeLabel(Card, title, 9, C.text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    TitleLbl.Size = UDim2.new(1, -4, 0, 24)
    TitleLbl.Position = UDim2.new(0, 2, 0, 36)
    TitleLbl.TextWrapped = true

    -- By
    local ByLbl = makeLabel(Card, "By: " .. (scriptData.owner and scriptData.owner.username or "Unknown"), 8, C.textMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    ByLbl.Size = UDim2.new(1, -4, 0, 12)
    ByLbl.Position = UDim2.new(0, 2, 0, 62)
    ByLbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- Select on click
    Card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            selectedScript = scriptData
            SHInfoLbl.Text = title
            SHViewsLbl.Text = "👁 " .. views
            SHKeyLbl.Text = hasKey and "🔑 Key" or "🔓 Keyless"
            SHKeyLbl.TextColor3 = hasKey and C.yellow or C.green
        end
    end)

    return Card
end

local function loadSHScripts(url)
    SHStatusLbl.Visible = true
    SHStatusLbl.Text = "⏳ Memuat scripts..."
    for _, c in pairs(SHScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    task.spawn(function()
        local success, raw = pcall(function()
            return game:HttpGet(url)
        end)
        if not success then
            SHStatusLbl.Text = "❌ Gagal konek ke ScriptBlox!"
            return
        end
        local data = HttpService:JSONDecode(raw)
        local scripts = data.result and data.result.scripts
        if scripts and #scripts > 0 then
            SHStatusLbl.Visible = false
            for i, s in ipairs(scripts) do
                buildSHCard(s, i)
            end
        else
            SHStatusLbl.Text = "❌ Tidak ada script ditemukan!"
        end
    end)
end

-- Execute selected script
SHExecBtn.MouseButton1Click:Connect(function()
    if selectedScript then
        local code = selectedScript.script or ""
        if code == "" and selectedScript.slug then
            task.spawn(function()
                local raw = pcall(function()
                    return game:HttpGet("https://scriptblox.com/api/script/raw/" .. selectedScript.slug)
                end)
                if raw then
                    local data = HttpService:JSONDecode(raw)
                    if data and data.script then
                        pcall(function() loadstring(data.script)() end)
                    end
                end
            end)
        else
            pcall(function() loadstring(code)() end)
        end
    end
end)

-- Open to executor
SHOpenBtn.MouseButton1Click:Connect(function()
    if selectedScript then
        EditorBox.Text = selectedScript.script or ("-- " .. (selectedScript.title or "Script"))
        executorTabs[activeTabIdx].content = EditorBox.Text
    end
end)

SHSearchBox.FocusLost:Connect(function(enter)
    if enter then
        local q = SHSearchBox.Text:gsub(" ", "%%20")
        loadSHScripts("https://scriptblox.com/api/script/search?q=" .. q)
    end
end)

-- =============================================
-- PAGE NAVIGATION
-- =============================================

local pageInfo = {
    home       = {icon = "🏠", title = "Home",       sub = "Home & Quick Hacks"},
    appinfo    = {icon = "ℹ️",  title = "App Info",   sub = "About SPDM Team & Arceus X NEO"},
    files      = {icon = "⚡",  title = "Files",      sub = "Saved Scripts"},
    executor   = {icon = "</>", title = "Executor",   sub = "Executor & Console"},
    scripthub  = {icon = "📄",  title = "Script Hub", sub = "Script Hub & Cloud Script"},
}

local function navigateTo(pageId)
    currentPage = pageId

    for id, data in pairs(sideButtons) do
        data.btn.BackgroundTransparency = id == pageId and 0 or 0.7
        data.btn.BackgroundColor3 = id == pageId and C.red or Color3.fromRGB(0,0,0)
        data.indicator.Visible = id == pageId
    end

    for name, page in pairs(Pages) do
        page.Visible = name == pageId
    end

    local info = pageInfo[pageId]
    if info then
        PageIcon.Text = info.icon
        PageTitle.Text = info.title
        PageSub.Text = info.sub
    end

    if pageId == "scripthub" then
        loadSHScripts("https://scriptblox.com/api/script/trending")
    end
end

for _, data in ipairs(sidePages) do
    sideButtons[data.id].btn.MouseButton1Click:Connect(function()
        navigateTo(data.id)
    end)
end

-- =============================================
-- DRAGGING
-- =============================================

local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- =============================================
-- MINI BOX
-- =============================================

local MiniBox = Instance.new("TextButton")
MiniBox.Size = UDim2.new(0, 44, 0, 44)
MiniBox.Position = UDim2.new(0, 20, 0, 20)
MiniBox.BackgroundColor3 = C.red
MiniBox.Text = "⚡"
MiniBox.TextSize = 20
MiniBox.Font = Enum.Font.GothamBold
MiniBox.BorderSizePixel = 0
MiniBox.Visible = false
MiniBox.Active = true
MiniBox.Parent = ScreenGui
makeCorner(MiniBox, 10)

local miniDragging = false
local miniDragStart, miniStartPos

MiniBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true
        miniDragStart = input.Position
        miniStartPos = MiniBox.Position
    end
end)
MiniBox.InputChanged:Connect(function(input)
    if miniDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - miniDragStart
        MiniBox.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)
MiniBox.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = false
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    MiniBox.Position = UDim2.new(Window.Position.X.Scale, Window.Position.X.Offset, Window.Position.Y.Scale, Window.Position.Y.Offset)
    Window.Visible = false
    MiniBox.Visible = true
end)

MiniBox.MouseButton1Click:Connect(function()
    if not miniDragging then
        Window.Position = MiniBox.Position
        MiniBox.Visible = false
        Window.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =============================================
-- START ON HOME PAGE
-- =============================================

navigateTo("home")

print("[Arceus X NEO] Loaded! By RizkyEditz")
