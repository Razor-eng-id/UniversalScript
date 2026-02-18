-- Tycoon Universal Script
-- By: You | UI: Dark Theme | Features: Auto Collect, Auto Upgrade, Status Info

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local autoCollect = false
local autoUpgrade = false
local collectDelay = 0.3
local upgradeDelay = 0.5

-- Status
local collectStatus = "Idle"
local upgradeStatus = "Idle"

-- Refresh character on respawn
LocalPlayer.CharacterAdded:Connect(function(c)
	Character = c
	RootPart = c:WaitForChild("HumanoidRootPart")
end)

-- =====================
-- UTILITY FUNCTIONS
-- =====================

local function getCollectPads()
	local pads = {}

	for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
			local name = obj.Name:lower()
			local parentName = obj.Parent and obj.Parent.Name:lower() or ""
			if name:find("collect") or name:find("cash") or name:find("money") or name:find("income")
				or name:find("drop") or name:find("pickup") or name:find("coin")
				or parentName:find("collect") or parentName:find("cash") then
				table.insert(pads, obj)
			end
		end
	end

	return pads
end

local function getUpgradePads()
	local pads = {}

	for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
			local name = obj.Name:lower()
			local parentName = obj.Parent and obj.Parent.Name:lower() or ""
			if name:find("buy") or name:find("upgrade") or name:find("purchase")
				or name:find("unlock") or name:find("button") or name:find("dropper")
				or name:find("power") or name:find("pad")
				or parentName:find("buy") or parentName:find("upgrade") or parentName:find("dropper") then
				table.insert(pads, obj)
			end
		end
	end

	return pads
end

local function teleportTo(part)
	if Character and RootPart and part then
		RootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
		task.wait(collectDelay)
	end
end

-- =====================
-- AUTO COLLECT LOOP
-- =====================

task.spawn(function()
	while true do
		if autoCollect then
			local pads = getCollectPads()
			if #pads > 0 then
				collectStatus = "Collecting... (" .. #pads .. " pad)"
				for _, pad in pairs(pads) do
					if not autoCollect then break end
					teleportTo(pad)
				end
			else
				collectStatus = "No collect pad found"
				task.wait(1)
			end
		else
			collectStatus = "Off"
			task.wait(0.5)
		end
	end
end)

-- =====================
-- AUTO UPGRADE LOOP
-- =====================

task.spawn(function()
	while true do
		if autoUpgrade then
			local pads = getUpgradePads()
			if #pads > 0 then
				upgradeStatus = "Upgrading... (" .. #pads .. " pad)"
				for _, pad in pairs(pads) do
					if not autoUpgrade then break end
					teleportTo(pad)
					task.wait(upgradeDelay)
				end
			else
				upgradeStatus = "No upgrade pad found"
				task.wait(1)
			end
		else
			upgradeStatus = "Off"
			task.wait(0.5)
		end
	end
end)

-- =====================
-- GUI
-- =====================

-- Remove existing GUI
if LocalPlayer.PlayerGui:FindFirstChild("TycoonUniversal") then
	LocalPlayer.PlayerGui:FindFirstChild("TycoonUniversal"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TycoonUniversal"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

-- =====================
-- MAIN FRAME
-- =====================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 200)
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
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Fix bottom corner of titlebar
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
TitleLabel.Text = "🏗️ Tycoon Universal"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Minimize Button
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

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -36)
ContentFrame.Position = UDim2.new(0, 0, 0, 36)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = ContentFrame

-- Toggle Button Factory
local function createToggle(parent, yPos, labelText, default)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = parent

	local TFCorner = Instance.new("UICorner")
	TFCorner.CornerRadius = UDim.new(0, 6)
	TFCorner.Parent = ToggleFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -55, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = labelText
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.TextSize = 12
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ToggleFrame

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(0, 40, 0, 22)
	ToggleBtn.Position = UDim2.new(1, -48, 0.5, -11)
	ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(80, 80, 80)
	ToggleBtn.Text = default and "ON" or "OFF"
	ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleBtn.TextSize = 10
	ToggleBtn.Font = Enum.Font.GothamBold
	ToggleBtn.BorderSizePixel = 0
	ToggleBtn.Parent = ToggleFrame

	local TBCorner = Instance.new("UICorner")
	TBCorner.CornerRadius = UDim.new(0, 5)
	TBCorner.Parent = ToggleBtn

	local state = default or false

	ToggleBtn.MouseButton1Click:Connect(function()
		state = not state
		ToggleBtn.Text = state and "ON" or "OFF"
		TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = state and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(80, 80, 80)
		}):Play()
		return state
	end)

	return ToggleBtn, function() return state end
end

-- Toggle: Auto Collect
local CollectBtn, getCollect = createToggle(ContentFrame, 0, "Auto Collect Money", false)
CollectBtn.MouseButton1Click:Connect(function()
	autoCollect = not autoCollect
end)

-- Toggle: Auto Upgrade
local UpgradeBtn, getUpgrade = createToggle(ContentFrame, 44, "Auto Upgrade Bangunan", false)
UpgradeBtn.MouseButton1Click:Connect(function()
	autoUpgrade = not autoUpgrade
end)

-- Status Box
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(1, 0, 0, 60)
StatusBox.Position = UDim2.new(0, 0, 0, 88)
StatusBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
StatusBox.BorderSizePixel = 0
StatusBox.Parent = ContentFrame

local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 6)
SBCorner.Parent = StatusBox

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(1, 0, 0, 18)
StatusTitle.Position = UDim2.new(0, 8, 0, 4)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Text = "📋 Status"
StatusTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusTitle.TextSize = 10
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.Parent = StatusBox

local CollectStatusLabel = Instance.new("TextLabel")
CollectStatusLabel.Size = UDim2.new(1, -8, 0, 16)
CollectStatusLabel.Position = UDim2.new(0, 8, 0, 22)
CollectStatusLabel.BackgroundTransparency = 1
CollectStatusLabel.Text = "Collect: Off"
CollectStatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
CollectStatusLabel.TextSize = 10
CollectStatusLabel.Font = Enum.Font.Gotham
CollectStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
CollectStatusLabel.Parent = StatusBox

local UpgradeStatusLabel = Instance.new("TextLabel")
UpgradeStatusLabel.Size = UDim2.new(1, -8, 0, 16)
UpgradeStatusLabel.Position = UDim2.new(0, 8, 0, 40)
UpgradeStatusLabel.BackgroundTransparency = 1
UpgradeStatusLabel.Text = "Upgrade: Off"
UpgradeStatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
UpgradeStatusLabel.TextSize = 10
UpgradeStatusLabel.Font = Enum.Font.Gotham
UpgradeStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
UpgradeStatusLabel.Parent = StatusBox

-- Update status labels
RunService.Heartbeat:Connect(function()
	CollectStatusLabel.Text = "Collect: " .. collectStatus
	UpgradeStatusLabel.Text = "Upgrade: " .. upgradeStatus
end)

-- =====================
-- MINI BOX (saat minimize)
-- =====================

local MiniBox = Instance.new("TextButton")
MiniBox.Name = "MiniBox"
MiniBox.Size = UDim2.new(0, 40, 0, 40)
MiniBox.Position = MainFrame.Position
MiniBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MiniBox.Text = "🏗️"
MiniBox.TextSize = 18
MiniBox.Font = Enum.Font.GothamBold
MiniBox.BorderSizePixel = 0
MiniBox.Visible = false
MiniBox.Active = true
MiniBox.Parent = ScreenGui

local MBCorner = Instance.new("UICorner")
MBCorner.CornerRadius = UDim.new(0, 8)
MBCorner.Parent = MiniBox

local MBStroke = Instance.new("UIStroke")
MBStroke.Color = Color3.fromRGB(60, 60, 60)
MBStroke.Thickness = 1
MBStroke.Parent = MiniBox

-- =====================
-- DRAGGING FUNCTION
-- =====================

local function makeDraggable(frame, dragHandle)
	local dragging = false
	local dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	dragHandle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(MainFrame, TitleBar)
makeDraggable(MiniBox, MiniBox)

-- =====================
-- MINIMIZE LOGIC
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

print("[Tycoon Universal] Script loaded!")
