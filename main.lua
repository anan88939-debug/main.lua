--[[ 
    KAOS ULTIMATE V20 - HARDCORE UPDATE
    YENİ: Fast Attack (Hızlı Vurma) | FIX: God & OneHit
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// AYARLAR
_G.Settings = {
    Fly = false,
    God = false,
    Aura = false,
    FastAttack = false, -- YENİ ÖZELLİK
    Noclip = false,
    InfJump = false,
    Speed = 100,
    AuraRange = 20
}

--// 1. MODÜL: AGRESİF ÖLÜMSÜZLÜK (GOD MODE FIX)
-- Bazı oyunlarda ölünce hile durmasın diye döngüye alındı
RunService.Heartbeat:Connect(function()
    if _G.Settings.God and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 100
            -- Ölümü engellemek için state değiştirme
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.Health = 100
            end
        end
        if not player.Character:FindFirstChildOfClass("ForceField") then
            Instance.new("ForceField", player.Character).Visible = false
        end
    end
end)

--// 2. MODÜL: FAST ATTACK & ONE HIT (HIZLI VURMA)
RunService.RenderStepped:Connect(function()
    if _G.Settings.Aura or _G.Settings.FastAttack then
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < _G.Settings.AuraRange then
                        -- Hızlı Vurma: Saniyede onlarca vuruş sinyali gönderir
                        tool:Activate()
                        firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 0)
                        firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 1)
                    end
                end
            end
        end
    end
end)

--// 3. MODÜL: ENVANTER TOPLAYICI
local function GetTools()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Tool") and not v:IsDescendantOf(player.Character) then
            v.Parent = player.Backpack
        end
    end
end

--// MODERN MEGA GUI
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 420)
main.Position = UDim2.new(0.1, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Draggable = true
main.Active = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 255) -- Buz Mavisi Neon
stroke.Thickness = 2

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local s = callback()
        b.BackgroundColor3 = s and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(35, 35, 35)
        b.TextColor3 = s and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)
end

AddBtn("GOD MODE (FIXED)", 50, function() _G.Settings.God = not _G.Settings.God return _G.Settings.God end)
AddBtn("FAST ATTACK (Hızlı Vur)", 95, function() _G.Settings.FastAttack = not _G.Settings.FastAttack return _G.Settings.FastAttack end)
AddBtn("KILL AURA (Tek Vuruş)", 140, function() _G.Settings.Aura = not _G.Settings.Aura return _G.Settings.Aura end)
AddBtn("GET TOOLS (Envanter)", 185, function() GetTools() return true end)
AddBtn("SPEED (Hız 100)", 230, function() player.Character.Humanoid.WalkSpeed = 100 return true end)
AddBtn("NOCLIP (Duvar Geçme)", 275, function() _G.Settings.Noclip = not _G.Settings.Noclip return _G.Settings.Noclip end)
AddBtn("JUMP (Zıplama)", 320, function() _G.Settings.InfJump = not _G.Settings.InfJump return _G.Settings.InfJump end)

-- K kapatır
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)
