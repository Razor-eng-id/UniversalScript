-- GOD FE Script
-- By: RizkyEditz
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
-- UTILITY
-- =====================

local function getPlayers(excludeSelf)
	local list = {}
	for _, p in pairs(Players:GetPlayers()) do
		if excludeSelf and p == LocalPlayer then continue end
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(list, p)
		end
	end
	return list
end

local function notify(msg)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "GOD",
		Text = msg,
		Duration = 3,
	})
end

-- =====================
-- FEATURES
-- =====================

-- Kill All
local function killAll()
	for _, p in pairs(getPlayers(true)) do
		local hum = p.Character:FindFirstChild("Humanoid")
		if hum then hum.Health = 0 end
	end
	notify("Kill All executed!")
end

-- Fling All
local function flingAll()
	for _, p in pairs(getPlayers(true)) do
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local bv = Instance.new("BodyVelocity")
			bv.Velocity = Vector3.new(math.random(-200,200), math.random(300,600), math.random(-200,200))
			bv.MaxForce = Vector3.new(1e9,1e9,1e9)
			bv.Parent = hrp
			game:GetService("Debris"):AddItem(bv, 0.2)
		end
	end
	notify("Fling All executed!")
end

-- Nuke
local function nuke()
	local pos = RootPart.Position
	for i = 1, 5 do
		local exp = Instance.new("Explosion")
		exp.Position = pos + Vector3.new(math.random(-30,30), 0, math.random(-30,30))
		exp.BlastRadius = 30
		exp.BlastPressure = 1e6
		exp.Parent = workspace
	end
	notify("NUKE launched!")
end

-- Freeze All
local frozenPlayers = {}
local function freezeAll()
	for _, p in pairs(getPlayers(true)) do
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		local hum = p.Character:FindFirstChild("Humanoid")
		if hrp and hum then
			hum.WalkSpeed = 0
			hum.JumpPower = 0
			local bf = Instance.new("BodyPosition")
			bf.Position = hrp.Position
			bf.MaxForce = Vector3.new(1e9,1e9,1e9)
			bf.Parent = hrp
			table.insert(frozenPlayers, {hrp=hrp, bf=bf, hum=hum})
		end
	end
	notify("Freeze All executed!")
end

local function unfreezeAll()
	for _, data in pairs(frozenPlayers) do
		if data.bf and data.bf.Parent then data.bf:Destroy() end
		if data.hum and data.hum.Parent then
			data.hum.WalkSpeed = 16
			data.hum.JumpPower = 50
		end
	end
	frozenPlayers = {}
	notify("Unfreeze All!")
end

-- Ragdoll All
local function ragdollAll()
	for _, p in pairs(getPlayers(true)) do
		local hum = p.Character:FindFirstChild("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
		end
	end
	notify("Ragdoll All executed!")
end

-- Sit All
local function sitAll()
	for _, p in pairs(getPlayers(true)) do
		local hum = p.Character:FindFirstChild("Humanoid")
		if hum then hum.Sit = true end
	end
	notify("Sit All executed!")
end

-- Spin All
local spinConnections = {}
local spinActive = false
local function startSpinAll()
	spinActive = true
	for _, p in pairs(getPlayers(true)) do
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local conn = RunService.Heartbeat:Connect(function()
				if not spinActive then return end
				if hrp and hrp.Parent then
					hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0)
				end
			end)
			table.insert(spinConnections, conn)
		end
	end
	notify("Spin All started!")
end

local function stopSpinAll()
	spinActive = false
	for _, conn in pairs(spinConnections) do conn:Disconnect() end
	spinConnections = {}
	notify("Spin All stopped!")
end

-- Void All
local function voidAll()
	for _, p in pairs(getPlayers(true)) do
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(0, -5000, 0)
		end
	end
	notify("Void All executed!")
end

-- Bring All
local function bringAll()
	for _, p in pairs(getPlayers(true)) do
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = RootPart.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
		end
	end
	notify("Bring All executed!")
end

-- Teleport All to Me
local function teleportAllToMe()
	for _, p in pairs(getPlayers(true)) do
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = RootPart.CFrame + Vector3.new(0, 0, 3)
		end
	end
	notify("Teleport All to Me!")
end

-- Invisible
local invisActive = false
local function toggleInvisible(state)
	invisActive = state
	if Character then
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = state and 1 or 0
			end
		end
	end
end

-- Chat Spam
local spamActive = false
local spamMessage = "GOD SCRIPT BY RIZKYEDITZ"
task.spawn(function()
	while true do
		if spamActive then
			game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") and
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamMessage, "All")
			task.wait(1)
		else
			task.wait(0.5)
		end
	end
end)

-- Fake Error
local function fakeError()
	local fakeGui = Instance.new("ScreenGui")
	fakeGui.Name = "FakeError"
	fakeGui.ResetOnSpawn = false
	fakeGui.Parent = LocalPlayer.PlayerGui

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BorderSizePixel = 0
	bg.Parent = fakeGui

	local errLbl = Instance.new("TextLabel")
	errLbl.Size = UDim2.new(0.8, 0, 0.4, 0)
	errLbl.Position = UDim2.new(0.1, 0, 0.3, 0)
	errLbl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	errLbl.BorderSizePixel = 0
	errLbl.Text = "⚠️ ROBLOX ERROR\n\nAn unexpected error occurred.\nError Code: 0x8007001F\n\nPlease restart your game."
	errLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
	errLbl.TextSize = 16
	errLbl.Font = Enum.Font.GothamBold
	errLbl.TextWrapped = true
	errLbl.Parent = bg
	Instance.new("UICorner", errLbl).CornerRadius = UDim.new(0, 10)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 100, 0, 36)
	closeBtn.Position = UDim2.new(0.5, -50, 0.72, 0)
	closeBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
	closeBtn.Text = "Close"
	closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
	closeBtn.TextSize = 13
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = bg
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

	closeBtn.MouseButton1Click:Connect(function()
		fakeGui:Destroy()
	end)

	task.delay(10, function()
		if fakeGui and fakeGui.Parent then fakeGui:Destroy() end
	end)
end

-- Copy Character
local function copyCharacter(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local targetChar = targetPlayer.Character
	local myChar = LocalPlayer.Character
	if not myChar then return end

	for _, obj in pairs(targetChar:GetDescendants()) do
		if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") or obj:IsA("ShirtGraphic") then
			local existing = myChar:FindFirstChildOfClass(obj.ClassName)
			if existing then existing:Destroy() end
			local clone = obj:Clone()
			clone.Parent = myChar
		end
	end

	-- Copy face/accessories
	for _, acc in pairs(targetChar:GetChildren()) do
		if acc:IsA("Accessory") then
			local existing = myChar:FindFirstChild(acc.Name)
			if existing then existing:Destroy() end
			local clone = acc:Clone()
			clone.Parent = myChar
		end
	end
	notify("Copied " .. targetPlayer.Name .. "'s character!")
end

-- Kick Player
local function kickPlayer(targetName)
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower():find(targetName:lower()) and p ~= LocalPlayer then
			-- FE kick via exploit method
			pcall(function()
				p:Kick("Kicked by GOD Script")
			end)
			notify("Kicked: " .. p.Name)
			return
		end
	end
	notify("Player not found: " .. targetName)
end

-- Freeze Specific Player
local function freezePlayer(targetName)
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower():find(targetName:lower()) and p ~= LocalPlayer then
			local hum = p.Character and p.Character:FindFirstChild("Humanoid")
			local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
			if hum and hrp then
				hum.WalkSpeed = 0
				hum.JumpPower = 0
				local bf = Instance.new("BodyPosition")
				bf.Position = hrp.Position
				bf.MaxForce = Vector3.new(1e9,1e9,1e9)
				bf.Parent = hrp
				notify("Frozen: " .. p.Name)
			end
			return
		end
	end
	notify("Player not found!")
end

-- =====================
-- BTOOLS
-- =====================
local btoolMode = "delete"
local selectedPart = nil

local function activateBtools()
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		local target = mouse.Target
		if not target then return end

		if btoolMode == "delete" then
			target:Destroy()
		elseif btoolMode == "copy" then
			local clone = target:Clone()
			clone.Position = target.Position + Vector3.new(0, 3, 0)
			clone.Parent = workspace
		elseif btoolMode == "paint" then
			target.BrickColor = BrickColor.Random()
		elseif btoolMode == "resize" then
			target.Size = target.Size * 1.5
		elseif btoolMode == "move" then
			selectedPart = target
		end
	end)

	RunService.Heartbeat:Connect(function()
		if btoolMode == "move" and selectedPart and selectedPart.Parent then
			local mouse = LocalPlayer:GetMouse()
			if mouse.Target then
				selectedPart.Position = mouse.Hit.Position + Vector3.new(0, selectedPart.Size.Y/2, 0)
			end
		end
	end)
end

activateBtools()

-- =====================
-- GUI
-- =====================

if LocalPlayer.PlayerGui:FindFirstChild("GODScript") then
	LocalPlayer.PlayerGui:FindFirstChild("GODScript"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GODScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 520)
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
TitleLabel.Text = "👑 GOD Script"
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

-- Scroll
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
ContentLayout.Padding = UDim.new(0, 5)
ContentLayout.Parent = ScrollFrame

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingLeft = UDim.new(0, 10)
ContentPad.PaddingRight = UDim.new(0, 10)
ContentPad.PaddingTop = UDim.new(0, 8)
ContentPad.PaddingBottom = UDim.new(0, 8)
ContentPad.Parent = ScrollFrame

-- =====================
-- UI HELPERS
-- =====================

local orderCount = 0
local function nextOrder()
	orderCount += 1
	return orderCount
end

local function makeSection(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 18)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(130, 130, 130)
	lbl.TextSize = 10
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.LayoutOrder = nextOrder()
	lbl.Parent = ScrollFrame
end

local function makeBtn(labelText, color, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 30)
	Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Row.BorderSizePixel = 0
	Row.LayoutOrder = nextOrder()
	Row.Parent = ScrollFrame
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 1, 0)
	Btn.BackgroundColor3 = color or Color3.fromRGB(220, 38, 38)
	Btn.Text = labelText
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 11
	Btn.Font = Enum.Font.GothamBold
	Btn.BorderSizePixel = 0
	Btn.Parent = Row
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

	Btn.MouseButton1Click:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(150, 20, 20)
		}):Play()
		task.wait(0.1)
		TweenService:Create(Btn, TweenInfo.new(0.1), {
			BackgroundColor3 = color or Color3.fromRGB(220, 38, 38)
		}):Play()
		callback()
	end)

	return Row
end

local function makeToggle(labelText, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 30)
	Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Row.BorderSizePixel = 0
	Row.LayoutOrder = nextOrder()
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
	Btn.Size = UDim2.new(0, 40, 0, 20)
	Btn.Position = UDim2.new(1, -46, 0.5, -10)
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
end

local function makeInput(placeholderText, btnText, callback)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 30)
	Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Row.BorderSizePixel = 0
	Row.LayoutOrder = nextOrder()
	Row.Parent = ScrollFrame
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

	local InputBox = Instance.new("TextBox")
	InputBox.Size = UDim2.new(1, -80, 0.9, 0)
	InputBox.Position = UDim2.new(0, 6, 0.05, 0)
	InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	InputBox.PlaceholderText = placeholderText
	InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	InputBox.Text = ""
	InputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	InputBox.TextSize = 10
	InputBox.Font = Enum.Font.Gotham
	InputBox.TextXAlignment = Enum.TextXAlignment.Left
	InputBox.ClearTextOnFocus = false
	InputBox.BorderSizePixel = 0
	InputBox.Parent = Row
	Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 5)
	local ip = Instance.new("UIPadding", InputBox)
	ip.PaddingLeft = UDim.new(0, 5)

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 68, 0.9, 0)
	Btn.Position = UDim2.new(1, -72, 0.05, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
	Btn.Text = btnText
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 10
	Btn.Font = Enum.Font.GothamBold
	Btn.BorderSizePixel = 0
	Btn.Parent = Row
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

	Btn.MouseButton1Click:Connect(function()
		callback(InputBox.Text)
	end)
end

local function makeDropdown(labelText, options, callback)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 0, 30)
	Container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Container.BorderSizePixel = 0
	Container.LayoutOrder = nextOrder()
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
	DropBtn.Size = UDim2.new(0.5, 0, 0, 22)
	DropBtn.Position = UDim2.new(0.48, 0, 0.5, -11)
	DropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	DropBtn.Text = options[1] or "Select"
	DropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	DropBtn.TextSize = 9
	DropBtn.Font = Enum.Font.Gotham
	DropBtn.BorderSizePixel = 0
	DropBtn.Parent = Container
	Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 5)

	local DropList = Instance.new("Frame")
	DropList.Size = UDim2.new(1, 0, 0, math.min(#options, 5) * 24)
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
		OptBtn.Size = UDim2.new(1, 0, 0, 24)
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
end

-- =====================
-- BUILD UI
-- =====================

-- COMBAT
makeSection("  💥 COMBAT")
makeBtn("☠️ Kill All", Color3.fromRGB(180, 20, 20), killAll)
makeBtn("🌪️ Fling All", Color3.fromRGB(180, 20, 20), flingAll)
makeBtn("💣 Nuke", Color3.fromRGB(180, 20, 20), nuke)
makeBtn("❄️ Freeze All", Color3.fromRGB(37, 99, 235), freezeAll)
makeBtn("🔥 Unfreeze All", Color3.fromRGB(37, 99, 235), unfreezeAll)
makeBtn("🪆 Ragdoll All", Color3.fromRGB(180, 20, 20), ragdollAll)

-- PLAYER
makeSection("  👤 PLAYER")
makeBtn("🪑 Sit All", Color3.fromRGB(120, 40, 180), sitAll)
makeToggle("🌀 Spin All", function(v)
	if v then startSpinAll() else stopSpinAll() end
end)
makeBtn("🕳️ Void All", Color3.fromRGB(20, 20, 20), voidAll)
makeBtn("🧲 Bring All", Color3.fromRGB(37, 99, 235), bringAll)
makeBtn("📍 Teleport All to Me", Color3.fromRGB(37, 99, 235), teleportAllToMe)

-- COPY CHARACTER
makeSection("  🎭 COPY CHARACTER")
local copyTarget = ""
local function getPlayerNames()
	local names = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then table.insert(names, p.Name) end
	end
	if #names == 0 then table.insert(names, "No players") end
	return names
end
makeDropdown("Pilih Player", getPlayerNames(), function(v) copyTarget = v end)
makeBtn("🎭 Copy Character", Color3.fromRGB(120, 80, 20), function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name == copyTarget then copyCharacter(p) return end
	end
end)

-- BTOOLS
makeSection("  🔧 BTOOLS")
makeDropdown("Mode", {"Delete", "Copy", "Paint", "Resize", "Move"}, function(v)
	btoolMode = v:lower()
end)

-- ADMIN
makeSection("  👑 ADMIN")
makeInput("Nama player...", "Kick", function(name) kickPlayer(name) end)
makeInput("Nama player...", "Freeze", function(name) freezePlayer(name) end)

-- TROLL
makeSection("  😂 TROLL")
makeToggle("👻 Invisible", function(v) toggleInvisible(v) end)
makeToggle("💬 Chat Spam", function(v) spamActive = v end)
makeInput("Pesan spam...", "Set", function(msg)
	if msg ~= "" then spamMessage = msg end
end)
makeBtn("⚠️ Fake Error Screen", Color3.fromRGB(180, 20, 20), fakeError)

-- =====================
-- MINI BOX
-- =====================

local MiniBox = Instance.new("TextButton")
MiniBox.Size = UDim2.new(0, 44, 0, 44)
MiniBox.Position = MainFrame.Position
MiniBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MiniBox.Text = "GOD"
MiniBox.TextSize = 11
MiniBox.Font = Enum.Font.GothamBold
MiniBox.TextColor3 = Color3.fromRGB(220, 220, 220)
MiniBox.BorderSizePixel = 0
MiniBox.Visible = false
MiniBox.Active = true
MiniBox.Parent = ScreenGui
Instance.new("UICorner", MiniBox).CornerRadius = UDim.new(0, 8)
local mbs2 = Instance.new("UIStroke", MiniBox)
mbs2.Color = Color3.fromRGB(60, 60, 60)
mbs2.Thickness = 1

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

print("[GOD Script] Loaded! By RizkyEditz")
