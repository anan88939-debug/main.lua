--[[ 
    KAOS ULTIMATE V15 - REBUILT FROM SCRATCH
    Özellikler: E (Uçuş), B (Patlatma), G (God), V (Aura), X (ESP), C (Envanter)
    Menü: K Tuşu | Hız: Shift
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

--// AYARLAR VE DURUMLAR
local Settings = {
	Fly = false,
	God = false,
	Aura = false,
	Esp = false,
	Speed = 80,
	FastSpeed = 250
}

--// 1. MODÜL: ESP SİSTEMİ (Garantili Highlight)
local function UpdateESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local highlight = p.Character:FindFirstChild("KaosHighlight")
			if Settings.Esp then
				if not highlight then
					highlight = Instance.new("Highlight")
					highlight.Name = "KaosHighlight"
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
					highlight.FillTransparency = 0.5
					highlight.Parent = p.Character
				end
				highlight.Enabled = true
			else
				if highlight then highlight.Enabled = false end
			end
		end
	end
end

--// 2. MODÜL: KARAKTER MOTORU (Uçuş, Aura, God)
local function ManageCharacter(char)
	local root = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	local bv = Instance.new("BodyVelocity", root)
	bv.MaxForce = Vector3.zero
	local bg = Instance.new("BodyGyro", root)
	bg.MaxTorque = Vector3.zero

	RunService.Heartbeat:Connect(function()
		if not char:IsDescendantOf(workspace) then return end

		-- Uçuş Kontrolü
		if Settings.Fly then
			bv.MaxForce = Vector3.new(1,1,1) * math.huge
			bg.MaxTorque = Vector3.new(1,1,1) * math.huge
			bv.Velocity = camera.CFrame.LookVector * Settings.Speed
			bg.CFrame = camera.CFrame
			hum.PlatformStand = true
		else
			bv.MaxForce = Vector3.zero
			bg.MaxTorque = Vector3.zero
			hum.PlatformStand = false
		end

		-- God Mode & Aura
		if Settings.God then hum.Health = hum.MaxHealth end
		if Settings.Aura then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude < 25 then
						p.Character.Humanoid.Health = 0
					end
				end
			end
		end
	end)
end

player.CharacterAdded:Connect(ManageCharacter)
if player.Character then ManageCharacter(player.Character) end

--// 3. MODÜL: MODERN GUI
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false
sg.Name = "KaosUltimate"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 380)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "KAOS ULTIMATE V15"
title.TextColor3 = Color3.new(1,0,0)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local function AddToggle(name, pos, callback)
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, pos)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.Text = name .. ": OFF"
	btn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		local state = callback()
		btn.Text = name .. (state and ": ON" or ": OFF")
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(25, 25, 25)
	end)
end

-- Butonları Sırala
AddToggle("FLY (E)", 50, function() Settings.Fly = not Settings.Fly return Settings.Fly end)
AddToggle("GOD (G)", 95, function() Settings.God = not Settings.God return Settings.God end)
AddToggle("ESP (X)", 140, function() Settings.Esp = not Settings.Esp UpdateESP() return Settings.Esp end)
AddToggle("AURA (V)", 185, function() Settings.Aura = not Settings.Aura return Settings.Aura end)
AddToggle("INV (C)", 230, function() 
	for _, o in pairs(workspace:GetDescendants()) do if o:IsA("Tool") then o.Parent = player.Backpack end end
	return true
end)
AddToggle("BOOM (B)", 275, function() return false end) -- Sadece bilgi amaçlı

--// 4. MODÜL: INPUT DİNLEYİCİ
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.E then Settings.Fly = not Settings.Fly
	elseif input.KeyCode == Enum.KeyCode.G then Settings.God = not Settings.God
	elseif input.KeyCode == Enum.KeyCode.V then Settings.Aura = not Settings.Aura
	elseif input.KeyCode == Enum.KeyCode.X then Settings.Esp = not Settings.Esp UpdateESP()
	elseif input.KeyCode == Enum.KeyCode.C then for _, o in pairs(workspace:GetDescendants()) do if o:IsA("Tool") then o.Parent = player.Backpack end end
	elseif input.KeyCode == Enum.KeyCode.B then Instance.new("Explosion", workspace).Position = mouse.Hit.p
	elseif input.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible
	elseif input.KeyCode == Enum.KeyCode.LeftShift then Settings.Speed = Settings.FastSpeed end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then Settings.Speed = 80 end
end)

-- Sürekli ESP Kontrolü (Yeni gelen oyuncular için)
RunService.Stepped:Connect(UpdateESP)
