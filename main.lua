-- [[ ÖL IMPERIUM HELPER + LOADING SYSTEM ]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- VARIABLEN
local raffinerien = {}
local autoModus = false

-- 1. SCREEN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RaffinerieSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. DAS HAUPTMENÜ (Vorerst unsichtbar)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 180)
mainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Visible = false -- Wird erst nach dem Laden sichtbar
mainFrame.Parent = screenGui

-- UI CORNER (Abgerundete Ecken für modernen Look)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "ÖL IMPERIUM HELPER"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.BorderSizePixel = 0
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- BUTTONS
local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0.9, 0, 0, 35)
addBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
addBtn.Text = "Raffinerie hinzufügen"
addBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
addBtn.TextColor3 = Color3.new(1, 1, 1)
addBtn.Font = Enum.Font.SourceSansBold
addBtn.Parent = mainFrame
Instance.new("UICorner", addBtn)

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0.9, 0, 0, 35)
autoBtn.Position = UDim2.new(0.05, 0, 0.50, 0)
autoBtn.Text = "Auto-Teleport: AUS"
autoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
autoBtn.TextColor3 = Color3.new(1, 1, 1)
autoBtn.Font = Enum.Font.SourceSansBold
autoBtn.Parent = mainFrame
Instance.new("UICorner", autoBtn)

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.9, 0, 0, 25)
resetBtn.Position = UDim2.new(0.05, 0, 0.80, 0)
resetBtn.Text = "Liste löschen"
resetBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
resetBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
resetBtn.Parent = mainFrame
Instance.new("UICorner", resetBtn)

-- 3. LOADING SCREEN
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 220, 0, 180)
loadingFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 8)

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 40)
loadTitle.Position = UDim2.new(0, 0, 0.2, 0)
loadTitle.Text = "Initialisiere..."
loadTitle.TextColor3 = Color3.new(1, 1, 1)
loadTitle.BackgroundTransparency = 1
loadTitle.TextSize = 18
loadTitle.Parent = loadingFrame

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(0.8, 0, 0, 8)
barBackground.Position = UDim2.new(0.1, 0, 0.6, 0)
barBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
barBackground.BorderSizePixel = 0
barBackground.Parent = loadingFrame
Instance.new("UICorner", barBackground)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
barFill.BorderSizePixel = 0
barFill.Parent = barBackground
Instance.new("UICorner", barFill)

-- 4. LOGIK: LOADING ANIMATION
task.spawn(function()
    task.wait(0.5)
    loadTitle.Text = "Lade Assets..."
    barFill:TweenSize(UDim2.new(0.4, 0, 1, 0), "Out", "Quad", 0.8)
    task.wait(0.8)
    
    loadTitle.Text = "Prüfe Whitelist..."
    barFill:TweenSize(UDim2.new(0.7, 0, 1, 0), "Out", "Quad", 1)
    task.wait(1)
    
    loadTitle.Text = "Bereit!"
    barFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.5)
    task.wait(0.6)
    
    loadingFrame:Destroy()
    mainFrame.Visible = true
end)

-- 5. LOGIK: SYSTEM FUNKTIONEN
addBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.CFrame
        table.insert(raffinerien, pos)
        addBtn.Text = "Raffinerie " .. #raffinerien .. " OK!"
        task.wait(0.5)
        addBtn.Text = "Nächste hinzufügen"
    end
end)

autoBtn.MouseButton1Click:Connect(function()
    autoModus = not autoModus
    
    if autoModus then
        if #raffinerien == 0 then
            autoBtn.Text = "Keine Ziele!"
            autoModus = false
            task.wait(1)
            autoBtn.Text = "Auto-Teleport: AUS"
            return
        end
        
        autoBtn.Text = "Auto-Teleport: AN"
        autoBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
        
        task.spawn(function()
            while autoModus do
                for i, cframe in ipairs(raffinerien) do
                    if not autoModus then break end
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = cframe + Vector3.new(0, 2, 0)
                    end
                    task.wait(1.5)
                end
            end
        end)
    else
        autoBtn.Text = "Auto-Teleport: AUS"
        autoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

resetBtn.MouseButton1Click:Connect(function()
    raffinerien = {}
    autoModus = false
    autoBtn.Text = "Auto-Teleport: AUS"
    autoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    addBtn.Text = "Raffinerie hinzufügen"
end)
