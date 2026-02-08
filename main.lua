--[[ 
    KAOS ULTIMATE v21 - AGRESSIVE BYPASS
    FIX: God Mode, Fast Attack (Right Click Support), One Hit
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

_G.Settings = {
    God = false,
    FastAttack = false,
    Aura = false,
    AuraRange = 25
}

--// 1. AGRESİF ÖLÜMSÜZLÜK (RE-SPAWN PROOF)
-- Karakter her doğduğunda veya canı değiştiğinde tetiklenir
local function ApplyGod()
    local char = player.Character
    if char and _G.Settings.God then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
        -- Bazı oyunlarda ölümü tetikleyen scriptleri bozmak için:
        if not char:FindFirstChild("GodPart") then
            local p = Instance.new("Part", char)
            p.Name = "GodPart"
            p.Transparency = 1
            p.CanCollide = false
        end
    end
end

--// 2. SAĞ TIK VE HIZLI VURMA DESTEĞİ
RunService.RenderStepped:Connect(function()
    if _G.Settings.FastAttack or _G.Settings.Aura then
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool then
            -- Sağ tık vurma simülasyonu ve hızlı sinyal gönderme
            tool:Activate() 
            
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < _G.Settings.AuraRange then
                        -- ONE HIT DENEMESİ: Sunucuya arka arkaya 50 vuruş sinyali gönderir
                        for i = 1, 10 do 
                            firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 0)
                            firetouchinterest(p.Character.HumanoidRootPart, tool.Handle, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- Sürekli kontrol döngüsü
RunService.Stepped:Connect(function()
    if _G.Settings.God then ApplyGod() end
end)

--// GUI (v21 Design)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 400)
main.Position = UDim2.new(0.1, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local s = callback()
        b.BackgroundColor3 = s and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(30, 30, 30)
    end)
end

AddBtn("GOD MODE v21", 50, function() _G.Settings.God = not _G.Settings.God ApplyGod() return _G.Settings.God end)
AddBtn("ULTRA FAST ATTACK", 100, function() _G.Settings.FastAttack = not _G.Settings.FastAttack return _G.Settings.FastAttack end)
AddBtn("ONE HIT KILLER", 150, function() _G.Settings.Aura = not _G.Settings.Aura return _G.Settings.Aura end)
AddBtn("WALKSPEED (200)", 200, function() player.Character.Humanoid.WalkSpeed = 200 return true end)
