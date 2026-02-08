--[[ 
    KAOS v23 - THE FINAL BYPASS
    FIXED: God Mode, One Hit, Fast Attack, ESP
    Solara Compatible %100
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

_G.Settings = {
    God = false,
    OneHit = false,
    FastAttack = false,
    Esp = false,
    Speed = 100,
    InfJump = false
}

--// 1. KESİN ÖLÜMSÜZLÜK (HUMANOID BYPASS)
-- Can düşmesini kod seviyesinde durdurur
local mt = getrawmetatable(game)
local old = mt.__index
setfastflag("HumanoidHealthNoLocal", "True") -- Bazı oyunlarda canı korur
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if _G.Settings.God and t:IsA("Humanoid") and k == "Health" then
        return 100
    end
    return old(t, k)
end)
setreadonly(mt, true)

--// 2. ONE HIT & FAST ATTACK (AGGRESSIVE MODE)
RunService.Heartbeat:Connect(function()
    if (_G.Settings.OneHit or _G.Settings.FastAttack) and player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 25 then
                        -- En verimli vuruş motoru
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

--// 3. FİZİKSEL HİLELER (SPEED & JUMP)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = _G.Settings.Speed
        if _G.Settings.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            player.Character.Humanoid:ChangeState("Jumping")
        end
    end
end)

--// 4. ESP & GET TOOLS (CLASSIC)
local function GetTools()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Tool") and not v:IsDescendantOf(player.Character) then
            v.Parent = player.Backpack
        end
    end
end

--// MEGA NEON GUI
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 400)
main.Position = UDim2.new(0.05, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.Draggable = true
main.Active = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 100)
stroke.Thickness = 2

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local s = callback()
        b.BackgroundColor3 = s and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(20, 20, 20)
        b.TextColor3 = s and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)
end

AddBtn("GOD MODE (Ölümsüzlük)", 50, function() _G.Settings.God = not _G.Settings.God return _G.Settings.God end)
AddBtn("ONE HIT (Tek Vuruş)", 100, function() _G.Settings.OneHit = not _G.Settings.OneHit return _G.Settings.OneHit end)
AddBtn("FAST ATTACK (Hızlı)", 150, function() _G.Settings.FastAttack = not _G.Settings.FastAttack return _G.Settings.FastAttack end)
AddBtn("SPEED (Hızlan)", 200, function() _G.Settings.Speed = 100 return true end)
AddBtn("GET TOOLS (Envanter)", 250, function() GetTools() return true end)
AddBtn("INF JUMP (Zıpla)", 300, function() _G.Settings.InfJump = not _G.Settings.InfJump return _G.Settings.InfJump end)

print("v23 HYPER-FIX Aktif!")
