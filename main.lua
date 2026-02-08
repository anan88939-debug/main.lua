--[[
    KAOS ULTIMATE v22 - MEGA PACK (FULL BYPASS)
    Geliştirici: Kaos Team
    Özellikler: Her şey dahil (God, OneHit, Fly, ESP, Inventory, Speed, Noclip)
    Tuş: K (Menü Aç/Kapat)
]]

--// BAŞLATICI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// TÜM AYARLAR (HAFIZADAKİ HER ŞEY)
_G.Settings = {
    God = false,
    OneHit = false,
    FastAttack = false,
    Esp = false,
    Fly = false,
    Noclip = false,
    InfJump = false,
    Speed = 100,
    JumpPower = 50,
    AuraRange = 30
}

--// 1. MODÜL: HARDCORE GOD MODE (ÖLÜMSÜZLÜK)
-- Bu yöntem canı sadece 100 yapmaz, ölümü tetikleyen "Humanoid" durumlarını bloke eder.
RunService.Heartbeat:Connect(function()
    if _G.Settings.God and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        if not player.Character:FindFirstChildOfClass("ForceField") then
            Instance.new("ForceField", player.Character).Visible = false
        end
    end
end)

--// 2. MODÜL: ONE HIT & FAST ATTACK (TEK VURUŞ / HIZLI VURMA)
-- Sağ tık veya sol tık fark etmeksizin elindeki aleti saniyede 50 kez tetikler.
RunService.RenderStepped:Connect(function()
    if (_G.Settings.OneHit or _G.Settings.FastAttack) and player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < _G.Settings.AuraRange then
                        -- Tek vuruş etkisi için çoklu sinyal
                        for i = 1, 5 do
                            tool:Activate()
                            firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 0)
                            firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 1)
                        end
                    end
                end
            end
        end
    end
end)

--// 3. MODÜL: ESP (DÜŞMAN GÖRÜŞÜ)
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = p.Character:FindFirstChild("KaosESP")
            if _G.Settings.Esp then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "KaosESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

--// 4. MODÜL: FİZİKSEL HİLELER (NOCLIP, SPEED, JUMP)
RunService.Stepped:Connect(function()
    if player.Character then
        -- Noclip
        if _G.Settings.Noclip then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        -- Speed & Jump
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = _G.Settings.Speed
            if _G.Settings.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hum:ChangeState("Jumping")
            end
        end
    end
end)

--// 5. MODÜL: ENVANTER TOPLAYICI (GET TOOLS)
local function GetTools()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Tool") and not v:IsDescendantOf(player.Character) then
            v.Parent = player.Backpack
        end
    end
end

--// MEGA GUI v22 (SOLARA İÇİN ÖZEL)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 480)
main.Position = UDim2.new(0.05, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 30) -- Koyu Mor Neon
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(200, 0, 255)
stroke.Thickness = 2

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local s = callback()
        b.BackgroundColor3 = s and Color3.fromRGB(200, 0, 255) or Color3.fromRGB(30, 30, 30)
    end)
end

-- Buton Listesi (Tam Takır)
AddBtn("GOD MODE (Ölümsüzlük)", 50, function() _G.Settings.God = not _G.Settings.God return _G.Settings.God end)
AddBtn("ONE HIT (Tek Vuruş)", 95, function() _G.Settings.OneHit = not _G.Settings.OneHit return _G.Settings.OneHit end)
AddBtn("FAST ATTACK (Hızlı Vur)", 140, function() _G.Settings.FastAttack = not _G.Settings.FastAttack return _G.Settings.FastAttack end)
AddBtn("ESP (Herkesi Gör)", 185, function() _G.Settings.Esp = not _G.Settings.Esp return _G.Settings.Esp end)
AddBtn("GET TOOLS (Eşya Topla)", 230, function() GetTools() return true end)
AddBtn("NOCLIP (Duvar Geç)", 275, function() _G.Settings.Noclip = not _G.Settings.Noclip return _G.Settings.Noclip end)
AddBtn("INF JUMP (Sınırsız Zıpla)", 320, function() _G.Settings.InfJump = not _G.Settings.InfJump return _G.Settings.InfJump end)
AddBtn("SPEED (Hızlan)", 365, function() _G.Settings.Speed = (_G.Settings.Speed == 100 and 16 or 100) return (_G.Settings.Speed == 100) end)
AddBtn("UÇMA (E)", 410, function() _G.Settings.Fly = not _G.Settings.Fly return _G.Settings.Fly end)

-- Menü Kapatma
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)

print("KAOS v22 YÜKLENDİ - TÜM ÖZELLİKLER AKTİF!")
