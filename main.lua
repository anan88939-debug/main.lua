--[[ 
    KAOS v24 MASTER - ROBLOX BYPASS
    TÜM ÖZELLİKLER TEK PAKET
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// AYARLAR TABLOSU
_G.Settings = {
    God = false,
    OneHit = false,
    FastAttack = false,
    Esp = false,
    Speed = 100,
    InfJump = false,
    Noclip = false,
    AuraRange = 25
}

--// 1. MODÜL: KESİN ÖLÜMSÜZLÜK (GOD MODE)
RunService.Heartbeat:Connect(function()
    if _G.Settings.God and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 100
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        if not player.Character:FindFirstChildOfClass("ForceField") then
            Instance.new("ForceField", player.Character).Visible = false
        end
    end
end)

--// 2. MODÜL: TEK VURUŞ & HIZLI VURMA (ONE HIT / FAST)
RunService.RenderStepped:Connect(function()
    if (_G.Settings.OneHit or _G.Settings.FastAttack) and player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist < _G.Settings.AuraRange then
                        tool:Activate()
                        pcall(function()
                            firetouchinterest(v.Character.HumanoidRootPart, tool.Handle, 0)
                            firetouchinterest(v.Character.HumanoidRootPart, tool.Handle, 1)
                        end)
                    end
                end
            end
        end
    end
end)

--// 3. MODÜL: FİZİK & HIZ (SPEED / NOCLIP / JUMP)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = _G.Settings.Speed
        if _G.Settings.Noclip then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        if _G.Settings.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            player.Character.Humanoid:ChangeState("Jumping")
        end
    end
end)

--// 4. MODÜL: ESP & GET TOOLS
local function GetTools()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Tool") and not v:IsDescendantOf(player.Character) then
            v.Parent = player.Backpack
        end
    end
end

--// MEGA GUI v24 (EKRAN GELME GARANTİLİ)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "KaosGui"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 240, 0, 420)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local s = callback()
        b.BackgroundColor3 = s and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(30, 30, 30)
    end)
end

AddBtn("GOD MODE", 50, function() _G.Settings.God = not _G.Settings.God return _G.Settings.God end)
AddBtn("ONE HIT / FAST", 95, function() _G.Settings.OneHit = not _G.Settings.OneHit return _G.Settings.OneHit end)
AddBtn("SPEED (HIZ)", 140, function() _G.Settings.Speed = (_G.Settings.Speed == 100 and 16 or 100) return (_G.Settings.Speed == 100) end)
AddBtn("NOCLIP (DUVAR)", 185, function() _G.Settings.Noclip = not _G.Settings.Noclip return _G.Settings.Noclip end)
AddBtn("INF JUMP", 230, function() _G.Settings.InfJump = not _G.Settings.InfJump return _G.Settings.InfJump end)
AddBtn("GET TOOLS", 275, function() GetTools() return true end)
AddBtn("KAPAT (K)", 320, function() main.Visible = false return false end)

-- K tuşu ile menüyü geri getirme
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)

print("KAOS v24 Yüklendi! Menüyü açmak/kapatmak için K tuşuna basın.")
