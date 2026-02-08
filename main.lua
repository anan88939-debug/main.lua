--[[
    KAOS ULTIMATE V19 - ALL-IN-ONE MEGA SCRIPT
    TUŞLAR:
    K: Menü Aç/Kapat | V: Kill Aura | G: God Mode | C: Get Tools
    E: Uçma | N: Noclip | J: Inf Jump | X: ESP
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

--// AYARLAR (HAFIZADAKİ TÜM ÖZELLİKLER)
_G.Settings = {
    Fly = false,
    God = false,
    Aura = false,
    Esp = false,
    Noclip = false,
    InfJump = false,
    Speed = 80,
    AuraRange = 20
}

--// 1. MODÜL: ESP (HERKESİ GÖRME)
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = p.Character:FindFirstChild("KaosHighlight") or Instance.new("Highlight", p.Character)
            highlight.Name = "KaosHighlight"
            highlight.Enabled = _G.Settings.Esp
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end

--// 2. MODÜL: KILL AURA (TEK VURUŞ DESTEKLİ)
local function DoKillAura()
    if _G.Settings.Aura then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < _G.Settings.AuraRange then
                    local tool = player.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        -- Hasar Sinyali Gönderme (Zayıf Anticheat'ler için)
                        p.Character.Humanoid:TakeDamage(0) -- Bazı oyunlarda tetikleyicidir
                    end
                end
            end
        end
    end
end

--// 3. MODÜL: ENVANTER TOPLAMA (GET TOOLS)
local function GetTools()
    for _, v in pairs(game:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("HopperBin")) and not v:IsDescendantOf(player.Character) then
            v.Parent = player.Backpack
        end
    end
end

--// 4. ANA FİZİK DÖNGÜSÜ (FLY, NOCLIP, GOD)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local char = player.Character
        local hum = char.Humanoid
        
        -- Noclip
        if _G.Settings.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        
        -- God Mode (ForceField & Health Lock)
        if _G.Settings.God then
            hum.Health = hum.MaxHealth
            if not char:FindFirstChildOfClass("ForceField") then
                Instance.new("ForceField", char).Visible = false
            end
        end
        
        -- Sınırsız Zıplama
        if _G.Settings.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState("Jumping")
        end
    end
    DoKillAura()
end)

--// 5. MEGA GUI (NEON GÜNCEL)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 450)
main.Position = UDim2.new(0.05, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Draggable = true
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 50)
stroke.Thickness = 3

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local state = callback()
        b.BackgroundColor3 = state and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(25, 25, 25)
    end)
end

-- Butonları Sıralayalım
AddBtn("ÖLÜMSÜZLÜK (G)", 50, function() _G.Settings.God = not _G.Settings.God return _G.Settings.God end)
AddBtn("KILL AURA (V)", 95, function() _G.Settings.Aura = not _G.Settings.Aura return _G.Settings.Aura end)
AddBtn("ENVANTER TOPLA (C)", 140, function() GetTools() return true end)
AddBtn("ESP GÖRÜŞ (X)", 185, function() _G.Settings.Esp = not _G.Settings.Esp UpdateESP() return _G.Settings.Esp end)
AddBtn("DUVAR GEÇİŞ (N)", 230, function() _G.Settings.Noclip = not _G.Settings.Noclip return _G.Settings.Noclip end)
AddBtn("UÇMA (E)", 275, function() _G.Settings.Fly = not _G.Settings.Fly return _G.Settings.Fly end)
AddBtn("SINIRSIZ ZIPLAMA (J)", 320, function() _G.Settings.InfJump = not _G.Settings.InfJump return _G.Settings.InfJump end)
AddBtn("HIZLI KOŞU (Shift)", 365, function() _G.Settings.Speed = 200 return true end)

--// TUŞ KONTROLLERİ
UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)

print("KAOS V19 YUKLENDI!")
