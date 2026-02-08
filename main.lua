--[[ 
    KAOS v25 - FINAL BOSS EDITION
    UÇMA + BOMBA + ESP + ONE HIT + GOD + SPEED
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// AYARLAR
_G.Settings = {
    God = false,
    OneHit = false,
    Esp = false,
    Fly = false,
    Noclip = false,
    InfJump = false,
    Speed = 100,
    FlySpeed = 50
}

--// 1. MODÜL: UÇMA HİLESİ (FLY)
local bv, bg
local function StartFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
    bg = Instance.new("BodyGyro", char.HumanoidRootPart)
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    
    RunService.RenderStepped:Connect(function()
        if _G.Settings.Fly and char:FindFirstChild("HumanoidRootPart") then
            bg.CFrame = workspace.CurrentCamera.CFrame
            local moveDir = char.Humanoid.MoveDirection
            bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * (moveDir.Magnitude > 0 and _G.Settings.FlySpeed or 0))
        elseif not _G.Settings.Fly then
            bv:Destroy()
            bg:Destroy()
        end
    end)
end

--// 2. MODÜL: BOMBA ATMA (BOMB DROP)
-- Bazı oyunlarda envanterdeki bombayı veya patlayıcıyı otomatik spamlar
local function DropBomb()
    local tool = player.Backpack:FindFirstChild("Bomb") or player.Character:FindFirstChild("Bomb")
    if tool then
        tool.Parent = player.Character
        tool:Activate()
        wait(0.1)
        tool.Parent = player.Backpack
    end
end

--// 3. MODÜL: ESP (DÜŞMANLARI GÖRME)
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = p.Character:FindFirstChild("KaosESP")
            if _G.Settings.Esp then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "KaosESP"
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                end
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end)

--// 4. MODÜL: ONE HIT & GOD MODE & PHYSICS
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        -- God Mode
        if _G.Settings.God then
            hum.Health = 100
            if not player.Character:FindFirstChildOfClass("ForceField") then
                Instance.new("ForceField", player.Character).Visible = false
            end
        end
        -- Speed & Noclip
        hum.WalkSpeed = _G.Settings.Speed
        if _G.Settings.Noclip then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

--// 5. MODÜL: ONE HIT KILLER
RunService.RenderStepped:Connect(function()
    if _G.Settings.OneHit and player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < 20 then
                        tool:Activate()
                        firetouchinterest(v.Character.HumanoidRootPart, tool.Handle, 0)
                        firetouchinterest(v.Character.HumanoidRootPart, tool.Handle, 1)
                    end
                end
            end
        end
    end
end)

--// MEGA GUI v25
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 480)
main.Position = UDim2.new(0.05, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 0, 0) -- Kan Kırmızısı Tema
main.Draggable = true
main.Active = true
Instance.new("UICorner", main)

local function AddBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local s = callback()
        b.BackgroundColor3 = s and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

AddBtn("GOD MODE", 50, function() _G.Settings.God = not _G.Settings.God return _G.Settings.God end)
AddBtn("ONE HIT KILL", 95, function() _G.Settings.OneHit = not _G.Settings.OneHit return _G.Settings.OneHit end)
AddBtn("UÇMA (FLY)", 140, function() _G.Settings.Fly = not _G.Settings.Fly if _G.Settings.Fly then StartFly() end return _G.Settings.Fly end)
AddBtn("ESP (GÖRÜŞ)", 185, function() _G.Settings.Esp = not _G.Settings.Esp return _G.Settings.Esp end)
AddBtn("BOMBA AT (BOMB)", 230, function() DropBomb() return true end)
AddBtn("NOCLIP (DUVAR)", 275, function() _G.Settings.Noclip = not _G.Settings.Noclip return _G.Settings.Noclip end)
AddBtn("HIZLI KOŞU", 320, function() _G.Settings.Speed = 150 return true end)
AddBtn("MENÜYÜ KAPAT (K)", 365, function() main.Visible = false return false end)

-- K Tuşu
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)
