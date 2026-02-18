-- Bubble Gum Universal Script
-- Dark Theme | Draggable | Minimize

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(c)
	Character = c
	RootPart = c:WaitForChild("HumanoidRootPart")
	Humanoid = c:WaitForChild("Humanoid")
end)

-- =====================
-- STATE
-- =====================
local autoCollectGems = false
local autoCollectCoins = false
local autoUnlockWorld = false
local autoTeleportWorld = false
local infJump = false
local autoBuyUpgrade = false
local autoEquipPet = false
local autoHatchEgg = false
local autoPop = false
local autoRebirth = false

local selectedWorld = "World 1"
local statusText = "Idle"

-- =====================
-- UTILITY
-- =====================

local function getPlayerMoney()
	local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Data")
	if stats then
		for _, v in pairs(stats:GetChildren()) do
			local n = v.Name:lower()
			if n:find("coin") or n:find("money") or n:find("cash") then
				return v.Value
			end
		end
	end
	return 0
end

local function getPlayerGems()
	local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Data")
	if stats then
		for _, v in pairs(stats:GetChildren()) do
			if v.Name:lower():find("gem") then
				return v.Value
			end
		end
	end
	return 0
end

local function getWorlds()
	local worlds = {}
	for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
		local name = obj.Name:lower()
		if name:find("world") or name:find("island") or name:find("zone") then
			if not table.find(worlds, obj.Name) then
				table.insert(worlds, obj.Name)
			end
		end
	end
	if #worlds == 0 then
		for i = 1, 10 do
			table.insert(worlds, "World " .. i)
		end
	end
	return worlds
end

local function teleportTo(pos)
	if RootPart then
		RootPart.CFrame = CFrame.new(pos) + Vector3.new(0, 3, 0)
		task.wait(0.3)
	end
end

-- =====================
-- FEATURE LOOPS
-- =====================

-- Auto Collect Gems
task.spawn(function()
	while true do
		if autoCollectGems then
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if not autoCollectGems then break end
				local name = obj.Name:lower()
				if (name:find("gem") or name:find("ruby") or name:find("diamond")) and obj:IsA("BasePart") then
					teleportTo(obj.Position)
				end
			end
			statusText = "Collecting Gems..."
		end
		task.wait(0.5)
	end
end)

-- Auto Collect Coins (awan)
task.spawn(function()
	while true do
		if autoCollectCoins then
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if not autoCollectCoins then break end
				local name = obj.Name:lower()
				if (name:find("coin") or name:find("bubble") or name:find("cloud") or name:find("collect")) and obj:IsA("BasePart") then
					teleportTo(obj.Position)
				end
			end
			statusText = "Collecting Coins..."
		end
		task.wait(0.5)
	end
end)

-- Auto Unlock World
task.spawn(function()
	while true do
		if autoUnlockWorld then
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if not autoUnlockWorld then break end
				local name = obj.Name:lower()
				if name:find("unlock") or name:find("portal") or name:find("gate") then
					if obj:IsA("BasePart") then
						teleportTo(obj.Position)
						task.wait(1)
					end
				end
			end
			statusText = "Unlocking Worlds..."
		end
		task.wait(1)
	end
end)

-- Auto Teleport World
task.spawn(function()
	while true do
		if autoTeleportWorld then
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if obj.Name == selectedWorld and obj:IsA("BasePart") then
					teleportTo(obj.Position)
					statusText = "Teleported to " .. selectedWorld
					break
				end
			end
		end
		task.wait(2)
	end
end)

-- Auto Buy Upgrade
task.spawn(function()
	while true do
		if autoBuyUpgrade then
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if not autoBuyUpgrade then break end
				local name = obj.Name:lower()
				if (name:find("upgrade") or name:find("buy") or name:find("shop")) and obj:IsA("BasePart") then
					teleportTo(obj.Position)
					task.wait(0.5)
				end
			end
			statusText = "Buying Upgrades..."
		end
		task.wait(1)
	end
end)

-- Auto Equip Best Pet
task.spawn(function()
	while true do
		if autoEquipPet then
			-- Coba fire remote equip pet
			for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
				local name = remote.Name:lower()
				if name:find("equip") and name:find("pet") then
					if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
						pcall(function()
							if remote:IsA("RemoteEvent") then
								remote:FireServer("best")
							end
						end)
					end
				end
			end
			statusText = "Equipping Best Pet..."
		end
		task.wait(3)
	end
end)

-- Auto Hatch Egg
task.spawn(function()
	while true do
		if autoHatchEgg then
			for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
				if not autoHatchEgg then break end
				local name = obj.Name:lower()
				if name:find("egg") and obj:IsA("BasePart") then
					teleportTo(obj.Position)
					task.wait(0.5)
					-- Fire hatch remote
					for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
						local rname = remote.Name:lower()
						if rname:find("hatch") then
							pcall(function()
								if remote:IsA("RemoteEvent") then
									remote:FireServer(obj.Parent or obj)
								end
							end)
						end
					end
				end
			end
			statusText = "Hatching Eggs..."
		end
		task.wait(0.5)
	end
end)

-- Auto Pop Bubble
task.spawn(function()
	while true do
		if autoPop then
			-- Cari remote pop/blow
			for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
				local name = remote.Name:lower()
				if name:find("pop") or name:find("blow") or name:find("bubble") then
					pcall(function()
						if remote:IsA("RemoteEvent") then
							remote:FireServer()
						end
					end)
				end
			end
			statusText = "Popping Bubbles..."
		end
		task.wait(0.1)
	end
end)

-- Auto Rebirth
task.spawn(function()
	while true do
		if autoRebirth then
			for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
				local name = remote.Name:lower()
				if name:find("rebirth") then
					pcall(function()
						if remote:IsA("RemoteEvent") then
							remote:FireServer()
						elseif remote:IsA("RemoteFunction") then
							remote:InvokeServer()
						end
					end)
				end
			end
			statusText = "Rebirthing..."
		end
		task.wait(2)
	end
end)

-- Inf Jump
local jumpConn
local function enableInfJump()
	if jumpConn then jumpConn:Disconnect() end
	jumpConn = UIS.JumpRequest:Connect(function()
		if infJump and Humanoid then
			Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end
enableInfJump()

LocalPlayer.CharacterAdded:Connect(function(c)
	Character = c
	Humanoid = c:WaitForChild("Humanoid")
	enableInfJump()
end)

-- =====================
-- GUI
-- =====================

if LocalPlayer.PlayerGui:FindFirstChild("BubbleGumUniversal") then
	LocalPlayer.PlayerGui:FindFirstChild("BubbleGumUniversal"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BubbleGumUniversal"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

-- =====================
-- MAIN FRAME
-- =====================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 460)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local ms = Instance.new("UIStroke", MainFrame)
ms.Color = Color3.fromRGB(60, 60, 60)
ms.Thickness = 1

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
TitleLabel.Text = "🫧 Bubble Gum Universal"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleLabel.TextSize = 12
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

-- Scroll Frame untuk konten
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

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingLeft = UDim.new(0, 10)
ContentPadding.PaddingRight = UDim.new(0, 10)
ContentPadding.PaddingTop = UDim.new(0, 8)
ContentPadding.PaddingBottom = UDim.new(0, 8)
ContentPadding.Parent = ScrollFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.Parent = ScrollFrame

-- =====================
-- HELPERS
-- =====================

local function makeToggle(parent, labelText, order, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 34)
	Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Row.BorderSizePixel = 0
	Row.LayoutOrder = order
	Row.Parent = parent
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

local function makeSectionLabel(parent, text, order)
	local Lbl = Instance.new("TextLabel")
	Lbl.Size = UDim2.new(1, 0, 0, 20)
	Lbl.BackgroundTransparency = 1
	Lbl.Text = text
	Lbl.TextColor3 = Color3.fromRGB(130, 130, 130)
	Lbl.TextSize = 10
	Lbl.Font = Enum.Font.GothamBold
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.LayoutOrder = order
	Lbl.Parent = parent
end

local function makeDropdown(parent, labelText, order, options, callback)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 0, 34)
	Container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Container.BorderSizePixel = 0
	Container.LayoutOrder = order
	Container.ClipsDescendants = false
	Container.Parent = parent
	Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

	local Lbl = Instance.new("TextLabel")
	Lbl.Size = UDim2.new(0.5, 0, 1, 0)
	Lbl.Position = UDim2.new(0, 8, 0, 0)
	Lbl.BackgroundTransparency = 1
	Lbl.Text = labelText
	Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	Lbl.TextSize = 11
	Lbl.Font = Enum.Font.Gotham
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.Parent = Container

	local DropBtn = Instance.new("TextButton")
	DropBtn.Size = UDim2.new(0.45, 0, 0, 24)
	DropBtn.Position = UDim2.new(0.53, 0, 0.5, -12)
	DropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	DropBtn.Text = options[1] or "Select"
	DropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	DropBtn.TextSize = 9
	DropBtn.Font = Enum.Font.Gotham
	DropBtn.BorderSizePixel = 0
	DropBtn.ClipsDescendants = false
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

-- =====================
-- BUILD UI CONTENT
-- =====================

makeSectionLabel(ScrollFrame, "  💰 COLLECT", 1)
makeToggle(ScrollFrame, "Auto Collect Gems", 2, function(v) autoCollectGems = v end)
makeToggle(ScrollFrame, "Auto Collect Coins (Awan)", 3, function(v) autoCollectCoins = v end)

makeSectionLabel(ScrollFrame, "  🌍 WORLD", 4)
makeToggle(ScrollFrame, "Auto Unlock World Baru", 5, function(v) autoUnlockWorld = v end)
makeToggle(ScrollFrame, "Auto Teleport ke World", 6, function(v) autoTeleportWorld = v end)

local worldOptions = {"World 1","World 2","World 3","World 4","World 5","World 6","World 7","World 8","World 9","World 10"}
makeDropdown(ScrollFrame, "Pilih World", 7, worldOptions, function(v) selectedWorld = v end)

makeSectionLabel(ScrollFrame, "  ⚡ UPGRADE & LAIN", 8)
makeToggle(ScrollFrame, "Auto Buy Upgrade", 9, function(v) autoBuyUpgrade = v end)
makeToggle(ScrollFrame, "Inf Jump (Android)", 10, function(v) infJump = v end)

makeSectionLabel(ScrollFrame, "  🥚 PET", 11)
makeToggle(ScrollFrame, "Auto Equip Best Pet", 12, function(v) autoEquipPet = v end)
makeToggle(ScrollFrame, "Auto Hatch Egg", 13, function(v) autoHatchEgg = v end)

makeSectionLabel(ScrollFrame, "  🫧 BUBBLE", 14)
makeToggle(ScrollFrame, "Auto Pop Bubble", 15, function(v) autoPop = v end)
makeToggle(ScrollFrame, "Auto Rebirth", 16, function(v) autoRebirth = v end)

-- Status Box
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(1, 0, 0, 36)
StatusBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
StatusBox.BorderSizePixel = 0
StatusBox.LayoutOrder = 17
StatusBox.Parent = ScrollFrame
Instance.new("UICorner", StatusBox).CornerRadius = UDim.new(0, 6)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, -10, 1, 0)
StatusLbl.Position = UDim2.new(0, 8, 0, 0)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "📋 Status: Idle"
StatusLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLbl.TextSize = 10
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Parent = StatusBox

RunService.Heartbeat:Connect(function()
	StatusLbl.Text = "📋 " .. statusText
end)

-- =====================
-- MINI BOX
-- =====================

local MiniBox = Instance.new("TextButton")
MiniBox.Size = UDim2.new(0, 40, 0, 40)
MiniBox.Position = MainFrame.Position
MiniBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MiniBox.Text = "🫧"
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

print("[Bubble Gum Universal] Loaded!")
