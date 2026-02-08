--[[ 
    KAOS ULTIMATE V16 - MEGA UPDATE
    K: Menü | B: Patlatma | N: Noclip | J: Sınırsız Zıplama
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

--// AYARLAR
_G.Settings = {
    Fly = false,
    God = false,
    Aura = false,
    Esp = false,
    Noclip = false,
    InfJump = false,
    Speed = 80
}

--// 1. MODÜLLER
-- ESP Sistemi
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChild("KaosHighlight") or Instance.new("Highlight", p.Character)
            h.Name = "KaosHighlight"
            h.Enabled = _G.Settings.Esp
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end

-- Sınırsız Zıplama
UserInputService.JumpRequest:Connect(function()
    if _G.Settings.InfJump then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

--// 2. ANA DÖNGÜ (Fizik Motoru)
player.CharacterAdded:Connect(function(char)
    local root = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    
    local bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.zero
    local bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.zero

    RunService.Stepped:Connect(function()
        if _G.Settings.Fly then
            bv.MaxForce = Vector3.new(1,1,1) * math.huge
            bg.MaxTorque = Vector3.new(1,1,1) * math.huge
            bv.Velocity = camera.CFrame.LookVector * _G.Settings.Speed
            bg.CFrame = camera.CFrame
        else
            bv.MaxForce = Vector3.zero
            bg.MaxTorque = Vector3.zero
        end

        if _G.Settings.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        
        if _G.Settings.God then hum.Health = hum.MaxHealth end
    end)
end)

--// 3. MODERN GUI (Neon V2)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 420)
main.Position = UDim2.new(0.05, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 50)
stroke.Thickness = 2

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.Text = text .. ": OFF"
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        local s = callback()
        b.Text = text .. (s and ": ON" or ": OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(20, 20, 20)
    end)
end

AddBtn("FLY (E)", 50, function() _G.Settings.Fly = not _G.Settings.Fly return _G.Settings.Fly end)
AddBtn("NOCLIP (N)", 95, function() _G.Settings.Noclip = not _G.Settings.Noclip return _G.Settings.Noclip end)
AddBtn("ESP (X)", 140, function() _G.Settings.Esp = not _G.Settings.Esp UpdateESP() return _G.Settings.Esp end)
AddBtn("INF JUMP (J)", 185, function() _G.Settings.InfJump = not _G.Settings.InfJump return _G.Settings.InfJump end)
AddBtn("KILL AURA (V)", 230, function() _G.Settings.Aura = not _G.Settings.Aura return _G.Settings.Aura end)
AddBtn("GOD MODE (G)", 275, function() _G.Settings.God = not _G.Settings.God return _G.Settings.God end)
AddBtn("GET TOOLS (C)", 320, function() 
    for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") then v.Parent = player.Backpack end end
    return true
end)

--// 4. TUŞLAR
UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible
    elseif i.KeyCode == Enum.KeyCode.B then Instance.new("Explosion", workspace).Position = mouse.Hit.p
    end
end)

RunService.RenderStepped:Connect(UpdateESP)
