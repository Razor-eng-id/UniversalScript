-- iLY furry🤤
-- Game: Fur Infection Outbreak
-- UI: Dark Theme | Draggable | Minimize

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(c)
	Character = c
	RootPart = c:WaitForChild("HumanoidRootPart")
end)

-- =====================
-- STATE
-- =====================
local autoCollectAll = false
local autoCollectResource = false
local autoCollectAmmo = false
local selectedLocation = "Spawn"
local collectStatus = "Off"
local teleportStatus = "Ready"

-- =====================
-- LOCATIONS
-- =====================
local locations = {
	["Spawn"]       = Vector3.new(0, 5, 0),
	["Safe Zone"]   = Vector3.new(50, 5, 50),
	["Forest"]      = Vector3.new(120, 5, 80),
	["Bunker"]      = Vector3.new(-80, 5, 120),
	["Supply Drop"] = Vector3.new(200, 5, -100),
	["City"]        = Vector3.new(-150, 5, -80),
	["Hospital"]    = Vector3.new(100, 5, -150),
	["Rooftop"]     = Vector3.new(0, 50, 0),
}

-- =====================
-- UTILITY
-- =====================

local function teleportTo(pos)
	if RootPart then
		RootPart.CFrame = CFrame.new(pos) + Vector3.new(0, 3, 0)
		task.wait(0.3)
	end
end

local function isItem(obj)
	if not obj:IsA("BasePart") and not obj:IsA("Model") then return false end
	local name = obj.Name:lower()
	return name:find("item") or name:find("pickup") or name:find("drop")
		or name:find("loot") or name:find("supply") or name:find("collect")
		or name:find("resource") or name:find("wood") or name:find("food")
		or name:find("medkit") or name:find("bandage") or name:find("herb")
		or name:find("material") or name:find("craft")
end

local function isAmmo(obj)
	if not obj:IsA("BasePart") and not obj:IsA("Model") then return false end
	local name = obj.Name:lower()
	return name:find("ammo") or name:find("bullet") or name:find("gun")
		or name:find("rifle") or name:find("pistol") or name:find("magazine")
		or name:find("weapon") or name:find("arrow")
end

local function isResource(obj)
	if not obj:IsA("BasePart") and not obj:IsA("Model") then return false end
	local name = obj.Name:lower()
	return name:find("resource") or name:find("wood") or name:find("stone")
		or name:find("food") or name:find("water") or name:find("herb")
		or name:find("material") or name:find("craft") or name:find("medkit")
		or name:find("bandage")
end

-- =====================
-- AUTO COLLECT LOOPS
-- =====================

task.spawn(function()
	while true do
		if autoCollectAll then
			local count = 0
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if not autoCollectAll then break end
				if isItem(obj) or isAmmo(obj) or isResource(obj) then
					local pos = obj:IsA("Model") and obj:GetModelCFrame().Position or obj.Position
					if pos and (pos - RootPart.Position).Magnitude < 500 then
						teleportTo(pos)
						count += 1
					end
				end
			end
			collectStatus = count > 0 and "Collecting... (" .. count .. " items)" or "No items found"
		elseif autoCollectResource or autoCollectAmmo then
			local count = 0
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if not (autoCollectResource or autoCollectAmmo) then break end
				local shouldCollect = false
				if autoCollectResource and isResource(obj) then shouldCollect = true end
				if autoCollectAmmo and isAmmo(obj) then shouldCollect = true end
				if shouldCollect then
					local pos = obj:IsA("Model") and obj:GetModelCFrame().Position or obj.Position
					if pos and (pos - RootPart.Position).Magnitude < 500 then
						teleportTo(pos)
						count += 1
					end
				end
			end
			collectStatus = count > 0 and "Collecting... (" .. count .. " items)" or "No items found"
		else
			collectStatus = "Off"
		end
		task.wait(0.5)
	end
end)

-- =====================
-- GUI
-- =====================

if LocalPlayer.PlayerGui:FindFirstChild("iLYfurry") then
	LocalPlayer.PlayerGui:FindFirstChild("iLYfurry"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "iLYfurry"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

-- =====================
-- MAIN FRAME
-- =====================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 310)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 60)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 8)
TitleFix.Position = UDim2.new(0, 0, 1, -8)
TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🤤 iLY furry"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -32, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Scroll Content
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -36)
ScrollFrame.Position = UDim2.new(0, 0, 0, 36)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.Parent = ScrollFrame

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingLeft = UDim.new(0, 10)
ContentPad.PaddingRight = UDim.new(0, 10)
ContentPad.PaddingTop = UDim.new(0, 8)
ContentPad.PaddingBottom = UDim.new(0, 8)
ContentPad.Parent = ScrollFrame

-- =====================
-- HELPER
-- =====================

local function makeSectionLabel(text, order)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 18)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(130, 130, 130)
	lbl.TextSize = 10
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = order
	lbl.Parent = ScrollFrame
end

local function makeToggle(labelText, order, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 34)
	Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Row.BorderSizePixel = 0
	Row.LayoutOrder = order
	Row.Parent = ScrollFrame
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

	local Lbl = Instance.new("TextLabel")
	Lbl.Size = UDim2.new(1, -55, 1, 0)
	Lbl.Position = UDim2.new(0, 8, 0, 0)
	Lbl.BackgroundTransparency = 1
	Lbl.Text = labelText
	Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	Lbl.TextSize = 11
	Lbl.Font = Enum.Font.Gotham
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.Parent = Row

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 40, 0, 22)
	Btn.Position = UDim2.new(1, -46, 0.5, -11)
	Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	Btn.Text = "OFF"
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 10
	Btn.Font = Enum.Font.GothamBold
	Btn.BorderSizePixel = 0
	Btn.Parent = Row
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

	local state = false
	Btn.MouseButton1Click:Connect(function()
		state = not state
		Btn.Text = state and "ON" or "OFF"
		TweenService:Create(Btn, TweenInfo.new(0.15), {
			BackgroundColor3 = state and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(80, 80, 80)
		}):Play()
		callback(state)
	end)

	return Row
end

local function makeDropdown(labelText, order, options, callback)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 0, 34)
	Container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Container.BorderSizePixel = 0
	Container.LayoutOrder = order
	Container.ClipsDescendants = false
	Container.Parent = ScrollFrame
	Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

	local Lbl = Instance.new("TextLabel")
	Lbl.Size = UDim2.new(0.45, 0, 1, 0)
	Lbl.Position = UDim2.new(0, 8, 0, 0)
	Lbl.BackgroundTransparency = 1
	Lbl.Text = labelText
	Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	Lbl.TextSize = 11
	Lbl.Font = Enum.Font.Gotham
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.Parent = Container

	local DropBtn = Instance.new("TextButton")
	DropBtn.Size = UDim2.new(0.5, 0, 0, 24)
	DropBtn.Position = UDim2.new(0.48, 0, 0.5, -12)
	DropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	DropBtn.Text = options[1] or "Select"
	DropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	DropBtn.TextSize = 9
	DropBtn.Font = Enum.Font.Gotham
	DropBtn.BorderSizePixel = 0
	DropBtn.Parent = Container
	Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 5)

	local DropList = Instance.new("Frame")
	DropList.Size = UDim2.new(1, 0, 0, #options * 26)
	DropList.Position = UDim2.new(0, 0, 1, 2)
	DropList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	DropList.BorderSizePixel = 0
	DropList.Visible = false
	DropList.ZIndex = 10
	DropList.Parent = Container
	Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)

	local DLLayout = Instance.new("UIListLayout")
	DLLayout.SortOrder = Enum.SortOrder.LayoutOrder
	DLLayout.Parent = DropList

	local isOpen = false
	for i, opt in ipairs(options) do
		local OptBtn = Instance.new("TextButton")
		OptBtn.Size = UDim2.new(1, 0, 0, 26)
		OptBtn.BackgroundTransparency = 1
		OptBtn.Text = opt
		OptBtn.TextColor3 = Color3.fromRGB(190, 190, 190)
		OptBtn.TextSize = 10
		OptBtn.Font = Enum.Font.Gotham
		OptBtn.ZIndex = 11
		OptBtn.LayoutOrder = i
		OptBtn.Parent = DropList

		OptBtn.MouseButton1Click:Connect(function()
			DropBtn.Text = opt
			DropList.Visible = false
			isOpen = false
			callback(opt)
		end)
	end

	DropBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		DropList.Visible = isOpen
	end)

	return Container
end

local function makeTeleportBtn(order)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 34)
	Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Row.BorderSizePixel = 0
	Row.LayoutOrder = order
	Row.Parent = ScrollFrame
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

	local Lbl = Instance.new("TextLabel")
	Lbl.Size = UDim2.new(1, -100, 1, 0)
	Lbl.Position = UDim2.new(0, 8, 0, 0)
	Lbl.BackgroundTransparency = 1
	Lbl.Text = "🌀 Teleport Sekarang"
	Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	Lbl.TextSize = 11
	Lbl.Font = Enum.Font.Gotham
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.Parent = Row

	local TpBtn = Instance.new("TextButton")
	TpBtn.Size = UDim2.new(0, 70, 0, 22)
	TpBtn.Position = UDim2.new(1, -76, 0.5, -11)
	TpBtn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
	TpBtn.Text = "GO ▶"
	TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	TpBtn.TextSize = 10
	TpBtn.Font = Enum.Font.GothamBold
	TpBtn.BorderSizePixel = 0
	TpBtn.Parent = Row
	Instance.new("UICorner", TpBtn).CornerRadius = UDim.new(0, 5)

	TpBtn.MouseButton1Click:Connect(function()
		local pos = locations[selectedLocation]
		if pos then
			teleportTo(pos)
			teleportStatus = "Teleported to " .. selectedLocation
			TpBtn.Text = "✅"
			task.wait(1.5)
			TpBtn.Text = "GO ▶"
			teleportStatus = "Ready"
		end
	end)
end

-- =====================
-- BUILD UI
-- =====================

makeSectionLabel("  🎒 AUTO COLLECT", 1)
makeToggle("Auto Collect Semua Item", 2, function(v) autoCollectAll = v end)
makeToggle("Auto Collect Resource", 3, function(v) autoCollectResource = v end)
makeToggle("Auto Collect Ammo", 4, function(v) autoCollectAmmo = v end)

makeSectionLabel("  🌀 TELEPORT", 5)

local locList = {}
for name, _ in pairs(locations) do
	table.insert(locList, name)
end
table.sort(locList)

makeDropdown("Pilih Lokasi", 6, locList, function(v)
	selectedLocation = v
end)

makeTeleportBtn(7)

-- Status Box
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(1, 0, 0, 52)
StatusBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
StatusBox.BorderSizePixel = 0
StatusBox.LayoutOrder = 8
StatusBox.Parent = ScrollFrame
Instance.new("UICorner", StatusBox).CornerRadius = UDim.new(0, 6)

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(1, -8, 0, 16)
StatusTitle.Position = UDim2.new(0, 8, 0, 4)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Text = "📋 Status"
StatusTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusTitle.TextSize = 10
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.Parent = StatusBox

local CollectStatusLbl = Instance.new("TextLabel")
CollectStatusLbl.Size = UDim2.new(1, -8, 0, 14)
CollectStatusLbl.Position = UDim2.new(0, 8, 0, 20)
CollectStatusLbl.BackgroundTransparency = 1
CollectStatusLbl.Text = "Collect: Off"
CollectStatusLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
CollectStatusLbl.TextSize = 10
CollectStatusLbl.Font = Enum.Font.Gotham
CollectStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
CollectStatusLbl.Parent = StatusBox

local TeleportStatusLbl = Instance.new("TextLabel")
TeleportStatusLbl.Size = UDim2.new(1, -8, 0, 14)
TeleportStatusLbl.Position = UDim2.new(0, 8, 0, 35)
TeleportStatusLbl.BackgroundTransparency = 1
TeleportStatusLbl.Text = "Teleport: Ready"
TeleportStatusLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
TeleportStatusLbl.TextSize = 10
TeleportStatusLbl.Font = Enum.Font.Gotham
TeleportStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
TeleportStatusLbl.Parent = StatusBox

RunService.Heartbeat:Connect(function()
	CollectStatusLbl.Text = "Collect: " .. collectStatus
	TeleportStatusLbl.Text = "Teleport: " .. teleportStatus
end)

-- =====================
-- MINI BOX
-- =====================

local MiniBox = Instance.new("TextButton")
MiniBox.Size = UDim2.new(0, 40, 0, 40)
MiniBox.Position = MainFrame.Position
MiniBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MiniBox.Text = "🦊"
MiniBox.TextSize = 20
MiniBox.Font = Enum.Font.GothamBold
MiniBox.BorderSizePixel = 0
MiniBox.Visible = false
MiniBox.Active = true
MiniBox.Parent = ScreenGui
Instance.new("UICorner", MiniBox).CornerRadius = UDim.new(0, 8)
local mbs = Instance.new("UIStroke", MiniBox)
mbs.Color = Color3.fromRGB(60, 60, 60)
mbs.Thickness = 1

-- =====================
-- DRAGGING
-- =====================

local function makeDraggable(frame, handle)
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	handle.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(MainFrame, TitleBar)
makeDraggable(MiniBox, MiniBox)

-- =====================
-- MINIMIZE
-- =====================

MinBtn.MouseButton1Click:Connect(function()
	MiniBox.Position = MainFrame.Position
	MainFrame.Visible = false
	MiniBox.Visible = true
end)

MiniBox.MouseButton1Click:Connect(function()
	MainFrame.Position = MiniBox.Position
	MiniBox.Visible = false
	MainFrame.Visible = true
end)

print("[iLY furry🤤] Loaded!")
