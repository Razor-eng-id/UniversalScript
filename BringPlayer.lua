-- Bring Player Script
-- Game: Fish It
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
local selectedPlayer = nil
local autoBring = false
local bringStatus = "Idle"

-- =====================
-- BRING FUNCTION
-- =====================

local function bringPlayer(target)
	if not target or not target.Character then
		bringStatus = "Player not found!"
		return
	end
	local hrp = target.Character:FindFirstChild("HumanoidRootPart")
	if hrp and RootPart then
		hrp.CFrame = RootPart.CFrame + Vector3.new(0, 0, 3)
		bringStatus = "Brought: " .. target.Name
	end
end

-- =====================
-- AUTO BRING LOOP
-- =====================

task.spawn(function()
	while true do
		if autoBring and selectedPlayer then
			bringPlayer(selectedPlayer)
		elseif autoBring and not selectedPlayer then
			bringStatus = "Pilih player dulu!"
		end
		task.wait(0.5)
	end
end)

-- =====================
-- GUI
-- =====================

if LocalPlayer.PlayerGui:FindFirstChild("BringPlayer") then
	LocalPlayer.PlayerGui:FindFirstChild("BringPlayer"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BringPlayer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

-- =====================
-- MAIN FRAME
-- =====================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
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
TitleLabel.Text = "🌀 Bring Player"
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

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -46)
ContentFrame.Position = UDim2.new(0, 10, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentFrame

-- =====================
-- PLAYER LIST SECTION
-- =====================

-- Section Label
local ListSectionLbl = Instance.new("TextLabel")
ListSectionLbl.Size = UDim2.new(1, 0, 0, 18)
ListSectionLbl.BackgroundTransparency = 1
ListSectionLbl.Text = "  👥 PILIH PLAYER"
ListSectionLbl.TextColor3 = Color3.fromRGB(130, 130, 130)
ListSectionLbl.TextSize = 10
ListSectionLbl.Font = Enum.Font.GothamBold
ListSectionLbl.TextXAlignment = Enum.TextXAlignment.Left
ListSectionLbl.LayoutOrder = 1
ListSectionLbl.Parent = ContentFrame

-- Player List Background
local ListBg = Instance.new("Frame")
ListBg.Size = UDim2.new(1, 0, 0, 180)
ListBg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ListBg.BorderSizePixel = 0
ListBg.LayoutOrder = 2
ListBg.Parent = ContentFrame
Instance.new("UICorner", ListBg).CornerRadius = UDim.new(0, 8)
local lbs = Instance.new("UIStroke", ListBg)
lbs.Color = Color3.fromRGB(50, 50, 50)
lbs.Thickness = 1

-- List Header
local ListHeader = Instance.new("Frame")
ListHeader.Size = UDim2.new(1, 0, 0, 28)
ListHeader.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ListHeader.BorderSizePixel = 0
ListHeader.Parent = ListBg
Instance.new("UICorner", ListHeader).CornerRadius = UDim.new(0, 8)

local ListHeaderFix = Instance.new("Frame")
ListHeaderFix.Size = UDim2.new(1, 0, 0, 8)
ListHeaderFix.Position = UDim2.new(0, 0, 1, -8)
ListHeaderFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ListHeaderFix.BorderSizePixel = 0
ListHeaderFix.Parent = ListHeader

local ListHeaderLbl = Instance.new("TextLabel")
ListHeaderLbl.Size = UDim2.new(0.6, 0, 1, 0)
ListHeaderLbl.Position = UDim2.new(0, 10, 0, 0)
ListHeaderLbl.BackgroundTransparency = 1
ListHeaderLbl.Text = "Players in Server"
ListHeaderLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
ListHeaderLbl.TextSize = 10
ListHeaderLbl.Font = Enum.Font.GothamBold
ListHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
ListHeaderLbl.Parent = ListHeader

-- Refresh Button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 65, 0, 20)
RefreshBtn.Position = UDim2.new(1, -70, 0.5, -10)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
RefreshBtn.Text = "🔄 Refresh"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 9
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Parent = ListHeader
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 5)

-- Scroll List
local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -8, 1, -32)
PlayerScroll.Position = UDim2.new(0, 4, 0, 30)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.Parent = ListBg

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 4)
PlayerListLayout.Parent = PlayerScroll

local PlayerListPad = Instance.new("UIPadding")
PlayerListPad.PaddingTop = UDim.new(0, 4)
PlayerListPad.PaddingBottom = UDim.new(0, 4)
PlayerListPad.Parent = PlayerScroll

-- Selected Player Display
local SelectedFrame = Instance.new("Frame")
SelectedFrame.Size = UDim2.new(1, 0, 0, 36)
SelectedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SelectedFrame.BorderSizePixel = 0
SelectedFrame.LayoutOrder = 3
SelectedFrame.Parent = ContentFrame
Instance.new("UICorner", SelectedFrame).CornerRadius = UDim.new(0, 8)
local sfs = Instance.new("UIStroke", SelectedFrame)
sfs.Color = Color3.fromRGB(99, 102, 241)
sfs.Thickness = 1

local SelectedIcon = Instance.new("TextLabel")
SelectedIcon.Size = UDim2.new(0, 28, 1, 0)
SelectedIcon.BackgroundTransparency = 1
SelectedIcon.Text = "👤"
SelectedIcon.TextSize = 14
SelectedIcon.Font = Enum.Font.Gotham
SelectedIcon.Parent = SelectedFrame

local SelectedLbl = Instance.new("TextLabel")
SelectedLbl.Size = UDim2.new(1, -36, 1, 0)
SelectedLbl.Position = UDim2.new(0, 32, 0, 0)
SelectedLbl.BackgroundTransparency = 1
SelectedLbl.Text = "Belum ada player dipilih"
SelectedLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
SelectedLbl.TextSize = 11
SelectedLbl.Font = Enum.Font.GothamBold
SelectedLbl.TextXAlignment = Enum.TextXAlignment.Left
SelectedLbl.Parent = SelectedFrame

-- =====================
-- BRING BUTTONS
-- =====================

local BtnSectionLbl = Instance.new("TextLabel")
BtnSectionLbl.Size = UDim2.new(1, 0, 0, 18)
BtnSectionLbl.BackgroundTransparency = 1
BtnSectionLbl.Text = "  🌀 BRING"
BtnSectionLbl.TextColor3 = Color3.fromRGB(130, 130, 130)
BtnSectionLbl.TextSize = 10
BtnSectionLbl.Font = Enum.Font.GothamBold
BtnSectionLbl.TextXAlignment = Enum.TextXAlignment.Left
BtnSectionLbl.LayoutOrder = 4
BtnSectionLbl.Parent = ContentFrame

-- Bring Once Button
local BringOnceRow = Instance.new("Frame")
BringOnceRow.Size = UDim2.new(1, 0, 0, 34)
BringOnceRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BringOnceRow.BorderSizePixel = 0
BringOnceRow.LayoutOrder = 5
BringOnceRow.Parent = ContentFrame
Instance.new("UICorner", BringOnceRow).CornerRadius = UDim.new(0, 6)

local BringOnceBtn = Instance.new("TextButton")
BringOnceBtn.Size = UDim2.new(1, 0, 1, 0)
BringOnceBtn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
BringOnceBtn.Text = "🌀 Bring Sekali"
BringOnceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BringOnceBtn.TextSize = 12
BringOnceBtn.Font = Enum.Font.GothamBold
BringOnceBtn.BorderSizePixel = 0
BringOnceBtn.Parent = BringOnceRow
Instance.new("UICorner", BringOnceBtn).CornerRadius = UDim.new(0, 6)

BringOnceBtn.MouseButton1Click:Connect(function()
	if selectedPlayer then
		bringPlayer(selectedPlayer)
		TweenService:Create(BringOnceBtn, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(22, 163, 74)
		}):Play()
		task.wait(0.3)
		TweenService:Create(BringOnceBtn, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(37, 99, 235)
		}):Play()
	else
		bringStatus = "Pilih player dulu!"
	end
end)

-- Auto Bring Toggle
local AutoBringRow = Instance.new("Frame")
AutoBringRow.Size = UDim2.new(1, 0, 0, 34)
AutoBringRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
AutoBringRow.BorderSizePixel = 0
AutoBringRow.LayoutOrder = 6
AutoBringRow.Parent = ContentFrame
Instance.new("UICorner", AutoBringRow).CornerRadius = UDim.new(0, 6)

local AutoBringLbl = Instance.new("TextLabel")
AutoBringLbl.Size = UDim2.new(1, -55, 1, 0)
AutoBringLbl.Position = UDim2.new(0, 8, 0, 0)
AutoBringLbl.BackgroundTransparency = 1
AutoBringLbl.Text = "🔁 Auto Bring (terus-terusan)"
AutoBringLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoBringLbl.TextSize = 11
AutoBringLbl.Font = Enum.Font.Gotham
AutoBringLbl.TextXAlignment = Enum.TextXAlignment.Left
AutoBringLbl.Parent = AutoBringRow

local AutoBringBtn = Instance.new("TextButton")
AutoBringBtn.Size = UDim2.new(0, 40, 0, 22)
AutoBringBtn.Position = UDim2.new(1, -46, 0.5, -11)
AutoBringBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AutoBringBtn.Text = "OFF"
AutoBringBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBringBtn.TextSize = 10
AutoBringBtn.Font = Enum.Font.GothamBold
AutoBringBtn.BorderSizePixel = 0
AutoBringBtn.Parent = AutoBringRow
Instance.new("UICorner", AutoBringBtn).CornerRadius = UDim.new(0, 5)

AutoBringBtn.MouseButton1Click:Connect(function()
	autoBring = not autoBring
	AutoBringBtn.Text = autoBring and "ON" or "OFF"
	TweenService:Create(AutoBringBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = autoBring and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(80, 80, 80)
	}):Play()
end)

-- Status Box
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(1, 0, 0, 34)
StatusBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
StatusBox.BorderSizePixel = 0
StatusBox.LayoutOrder = 7
StatusBox.Parent = ContentFrame
Instance.new("UICorner", StatusBox).CornerRadius = UDim.new(0, 6)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, -8, 1, 0)
StatusLbl.Position = UDim2.new(0, 8, 0, 0)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "📋 Status: Idle"
StatusLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLbl.TextSize = 10
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Parent = StatusBox

RunService.Heartbeat:Connect(function()
	StatusLbl.Text = "📋 Status: " .. bringStatus
end)

-- =====================
-- BUILD PLAYER LIST
-- =====================

local function buildPlayerList()
	-- Clear existing
	for _, c in pairs(PlayerScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	local playerList = Players:GetPlayers()
	local order = 0

	if #playerList <= 1 then
		local EmptyLbl = Instance.new("TextLabel")
		EmptyLbl.Size = UDim2.new(1, 0, 0, 30)
		EmptyLbl.BackgroundTransparency = 1
		EmptyLbl.Text = "😕 Tidak ada player lain"
		EmptyLbl.TextColor3 = Color3.fromRGB(100, 100, 100)
		EmptyLbl.TextSize = 10
		EmptyLbl.Font = Enum.Font.Gotham
		EmptyLbl.TextXAlignment = Enum.TextXAlignment.Center
		EmptyLbl.Parent = PlayerScroll
		return
	end

	for _, p in pairs(playerList) do
		if p == LocalPlayer then continue end
		order += 1

		local isSelected = selectedPlayer == p

		local PlayerCard = Instance.new("Frame")
		PlayerCard.Size = UDim2.new(1, -4, 0, 34)
		PlayerCard.BackgroundColor3 = isSelected and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(28, 28, 28)
		PlayerCard.BorderSizePixel = 0
		PlayerCard.LayoutOrder = order
		PlayerCard.Parent = PlayerScroll
		Instance.new("UICorner", PlayerCard).CornerRadius = UDim.new(0, 6)

		if isSelected then
			local cs = Instance.new("UIStroke", PlayerCard)
			cs.Color = Color3.fromRGB(99, 102, 241)
			cs.Thickness = 1
		end

		-- Avatar icon
		local AvatarFrame = Instance.new("Frame")
		AvatarFrame.Size = UDim2.new(0, 24, 0, 24)
		AvatarFrame.Position = UDim2.new(0, 5, 0.5, -12)
		AvatarFrame.BackgroundColor3 = isSelected and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(50, 50, 50)
		AvatarFrame.BorderSizePixel = 0
		AvatarFrame.Parent = PlayerCard
		Instance.new("UICorner", AvatarFrame).CornerRadius = UDim.new(1, 0)

		local AvatarLbl = Instance.new("TextLabel")
		AvatarLbl.Size = UDim2.new(1, 0, 1, 0)
		AvatarLbl.BackgroundTransparency = 1
		AvatarLbl.Text = string.upper(string.sub(p.Name, 1, 1))
		AvatarLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		AvatarLbl.TextSize = 11
		AvatarLbl.Font = Enum.Font.GothamBold
		AvatarLbl.Parent = AvatarFrame

		-- Player name
		local NameLbl = Instance.new("TextLabel")
		NameLbl.Size = UDim2.new(1, -80, 1, 0)
		NameLbl.Position = UDim2.new(0, 34, 0, 0)
		NameLbl.BackgroundTransparency = 1
		NameLbl.Text = p.Name
		NameLbl.TextColor3 = isSelected and Color3.fromRGB(200, 200, 255) or Color3.fromRGB(200, 200, 200)
		NameLbl.TextSize = 11
		NameLbl.Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham
		NameLbl.TextXAlignment = Enum.TextXAlignment.Left
		NameLbl.TextTruncate = Enum.TextTruncate.AtEnd
		NameLbl.Parent = PlayerCard

		-- Select indicator
		if isSelected then
			local SelectedDot = Instance.new("TextLabel")
			SelectedDot.Size = UDim2.new(0, 40, 0, 18)
			SelectedDot.Position = UDim2.new(1, -44, 0.5, -9)
			SelectedDot.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
			SelectedDot.Text = "✓ Dipilih"
			SelectedDot.TextColor3 = Color3.fromRGB(255, 255, 255)
			SelectedDot.TextSize = 8
			SelectedDot.Font = Enum.Font.GothamBold
			SelectedDot.BorderSizePixel = 0
			SelectedDot.Parent = PlayerCard
			Instance.new("UICorner", SelectedDot).CornerRadius = UDim.new(0, 4)
		end

		-- Click to select
		PlayerCard.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				selectedPlayer = p
				SelectedLbl.Text = "✓ " .. p.Name
				SelectedLbl.TextColor3 = Color3.fromRGB(200, 200, 255)
				bringStatus = "Siap bring: " .. p.Name
				buildPlayerList()
			end
		end)
	end
end

-- Refresh button
RefreshBtn.MouseButton1Click:Connect(function()
	buildPlayerList()
	TweenService:Create(RefreshBtn, TweenInfo.new(0.1), {
		BackgroundColor3 = Color3.fromRGB(22, 163, 74)
	}):Play()
	task.wait(0.3)
	TweenService:Create(RefreshBtn, TweenInfo.new(0.1), {
		BackgroundColor3 = Color3.fromRGB(37, 99, 235)
	}):Play()
end)

-- Auto refresh player list saat ada yang join/leave
Players.PlayerAdded:Connect(function() buildPlayerList() end)
Players.PlayerRemoving:Connect(function(p)
	if selectedPlayer == p then
		selectedPlayer = nil
		SelectedLbl.Text = "Belum ada player dipilih"
		SelectedLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
		bringStatus = "Player left!"
	end
	buildPlayerList()
end)

-- Build on start
buildPlayerList()

-- =====================
-- MINI BOX
-- =====================

local MiniBox = Instance.new("TextButton")
MiniBox.Size = UDim2.new(0, 40, 0, 40)
MiniBox.Position = MainFrame.Position
MiniBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MiniBox.Text = "🌀"
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

print("[Bring Player] Loaded!")
