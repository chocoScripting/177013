-- PLAYER & GUI SERVICES
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- CREATE SCREEN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SlimeRNGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- CREATE MAIN FRAME (DRAGGABLE)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 300)
mainFrame.Position = UDim2.new(1, -400, 1, -320)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 16)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Color = Color3.fromRGB(0, 165, 220)
mainFrameStroke.Thickness = 1
mainFrameStroke.Transparency = 0.35
mainFrameStroke.Parent = mainFrame

-- BLUR EFFECT
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 8
blurEffect.Parent = screenGui

-- TITLE BAR
local titleBar = Instance.new("TextLabel")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Text = "🎮 Slime RNG Script"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 14
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 180)),
})
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

-- TOGGLE BUTTON
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 34, 0, 34)
toggleButton.Position = UDim2.new(1, -60, 1, -382)
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "+"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

toggleButton.Active = true

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(0, 12)
toggleButtonCorner.Parent = toggleButton

local toggleDragging = false
local toggleDragInput
local toggleDragStart
local toggleStartPos

toggleButton.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - toggleDragStart
        toggleButton.Position = toggleStartPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = false
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    updateMinimizeState()
end)

-- LOG DISPLAY TEXTBOX
local logDisplay = Instance.new("TextLabel")
logDisplay.Name = "LogDisplay"
logDisplay.Size = UDim2.new(1, -10, 0, 160)
logDisplay.Position = UDim2.new(0, 5, 0, 35)
logDisplay.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
logDisplay.BackgroundTransparency = 0.1
logDisplay.TextColor3 = Color3.fromRGB(0, 255, 120)
logDisplay.Text = "🚀 Starting script..."
logDisplay.Font = Enum.Font.Code
logDisplay.TextSize = 10
logDisplay.TextXAlignment = Enum.TextXAlignment.Left
logDisplay.TextYAlignment = Enum.TextYAlignment.Top
logDisplay.TextWrapped = true
logDisplay.Parent = mainFrame

-- DRAG FUNCTIONALITY
local dragging = false
local dragInput
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- TOGGLE MINIMIZE WITH G KEY
local isMinimized = false
local delayFrameRef = nil

local function updateMinimizeState()
    mainFrame.Visible = not isMinimized
    blurEffect.Enabled = not isMinimized
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        isMinimized = not isMinimized
        updateMinimizeState()
    end
end)

-- ⏱️ DELAY CONFIGURATION UI
local currentDelay = 0.1

-- Delay Control Frame
local delayFrame = Instance.new("Frame")
delayFrame.Name = "DelayFrame"
delayFrame.Size = UDim2.new(1, -10, 0, 80)
delayFrame.Position = UDim2.new(0, 5, 0, 200)
delayFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
delayFrame.BackgroundTransparency = 0.08
delayFrame.BorderSizePixel = 0
delayFrame.Parent = mainFrame
delayFrameRef = delayFrame

local delayFrameCorner = Instance.new("UICorner")
delayFrameCorner.CornerRadius = UDim.new(0, 12)
delayFrameCorner.Parent = delayFrame

local delayFrameStroke = Instance.new("UIStroke")
delayFrameStroke.Color = Color3.fromRGB(0, 145, 205)
delayFrameStroke.Thickness = 1
delayFrameStroke.Transparency = 0.4
delayFrameStroke.Parent = delayFrame

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Name = "DelayLabel"
delayLabel.Size = UDim2.new(0, 50, 0, 20)
delayLabel.Position = UDim2.new(0, 5, 0, 5)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.GothamBold
delayLabel.TextSize = 12
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayFrame

-- Current Delay Display
local currentDelayLabel = Instance.new("TextLabel")
currentDelayLabel.Name = "CurrentDelayLabel"
currentDelayLabel.Size = UDim2.new(0, 100, 0, 20)
currentDelayLabel.Position = UDim2.new(0, 5, 0, 30)
currentDelayLabel.BackgroundTransparency = 1
currentDelayLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
currentDelayLabel.Text = "Current: 0.10s"
currentDelayLabel.Font = Enum.Font.Gotham
currentDelayLabel.TextSize = 11
currentDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
currentDelayLabel.Parent = delayFrame

-- Delay Input TextBox
local delayInput = Instance.new("TextBox")
delayInput.Name = "DelayInput"
delayInput.Size = UDim2.new(0, 70, 0, 25)
delayInput.Position = UDim2.new(0, 120, 0, 5)
delayInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
delayInput.BackgroundTransparency = 0.2
delayInput.BorderColor3 = Color3.fromRGB(0, 200, 255)
delayInput.BorderSizePixel = 1
delayInput.TextColor3 = Color3.fromRGB(0, 255, 120)
delayInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
delayInput.PlaceholderText = "e.g. 0.1"
delayInput.Font = Enum.Font.Code
delayInput.TextSize = 10
delayInput.Text = "0.1"
delayInput.ClearTextOnFocus = false
delayInput.Parent = delayFrame

local delayInputCorner = Instance.new("UICorner")
delayInputCorner.CornerRadius = UDim.new(0, 8)
delayInputCorner.Parent = delayInput

-- Apply Button
local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(0, 50, 0, 25)
applyButton.Position = UDim2.new(0, 200, 0, 5)
applyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.Text = "Apply"
applyButton.Font = Enum.Font.GothamBold
applyButton.TextSize = 10
applyButton.BorderSizePixel = 0
applyButton.Parent = delayFrame

local applyButtonCorner = Instance.new("UICorner")
applyButtonCorner.CornerRadius = UDim.new(0, 8)
applyButtonCorner.Parent = applyButton

-- Apply Button Hover Effect
applyButton.MouseEnter:Connect(function()
    applyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 220)
end)

applyButton.MouseLeave:Connect(function()
    applyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
end)

-- Apply Delay Function
local function applyDelay()
    local inputValue = delayInput.Text:match("[%d.]+")
    if inputValue then
        local newDelay = tonumber(inputValue)
        if newDelay and newDelay > 0 then
            currentDelay = newDelay
            currentDelayLabel.Text = "Current: " .. string.format("%.2f", newDelay) .. "s"
            addLog("CONFIG", "✅ Delay updated to: " .. string.format("%.2f", newDelay) .. "s")
            updateLogDisplay()
        else
            addLog("CONFIG", "❌ Invalid delay value")
            updateLogDisplay()
        end
    end
end

applyButton.MouseButton1Click:Connect(applyDelay)

-- Also apply on Enter key
delayInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        applyDelay()
    end
end)

-- SERVICES
local rs = game:GetService("ReplicatedStorage")

-- REMOTES
local rollRemote = rs:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("leifstout_networker@0.3.1")
    :WaitForChild("networker")
    :WaitForChild("_remotes")
    :WaitForChild("RollService")
    :WaitForChild("RemoteFunction")

local collectRemote = rs:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("leifstout_networker@0.3.1")
    :WaitForChild("networker")
    :WaitForChild("_remotes")
    :WaitForChild("LootService")
    :WaitForChild("RemoteFunction")

-- LOG STORAGE
local logHistory = {}

-- FORMATTER (Recursive)
local function formatValue(value, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)

    if type(value) == "table" then
        local str = "{\n"

        for k, v in pairs(value) do
            local key = (type(k) == "number") and ("["..k.."]") or ('["'..tostring(k)..'"]')
            str = str .. spacing .. "  " .. key .. " = " .. formatValue(v, indent + 1) .. "\n"
        end

        return str .. spacing .. "}"
    elseif type(value) == "string" then
        return '"' .. value .. '"'
    else
        return tostring(value)
    end
end

-- ADD LOG FUNCTION
local function addLog(logType, message)
    local timestamp = os.date("%H:%M:%S")
    local logText = "[" .. timestamp .. "] [" .. logType .. "] " .. tostring(message)
    
    table.insert(logHistory, logText)
    table.insert(logHistory, "") -- Add spacing separator
    
    -- Keep only last 50 logs
    if #logHistory > 50 then
        table.remove(logHistory, 1)
        table.remove(logHistory, 1)
    end
    
    return logText
end

-- 🔍 Cari loot yang tersedia
local function getAvailableLoot()
    local lootFolder = workspace:FindFirstChild("Loot")
    if not lootFolder then return nil end

    for _, v in pairs(lootFolder:GetChildren()) do
        -- ambil nama model (UUID)
        return v.Name
    end

    return nil
end

-- 🎲 EXTRACT SLIME NAME FROM RESULT
local function extractSlimeName(result)
    if type(result) == "table" then
        -- Cek berbagai struktur hasil yang mungkin
        if result.name then return result.name end
        if result.slime then return result.slime end
        if result["name"] then return result["name"] end
        if result["slime"] then return result["slime"] end
        
        -- Jika ada field 'type' atau 'type' yang mirip
        for k, v in pairs(result) do
            if type(v) == "string" and (k:lower():find("name") or k:lower():find("type") or k:lower():find("slime")) then
                return v
            end
        end
        
        -- Ambil value string pertama yang ditemukan
        for k, v in pairs(result) do
            if type(v) == "string" and v ~= "" then
                return v
            end
        end
    end
    return "Unknown"
end

-- CREATE MAIN TAB
local runCount = 0
local successCount = 0
local errorCount = 0

-- UPDATE LOG DISPLAY FUNCTION
local function updateLogDisplay()
    local displayText = table.concat(logHistory, "\n")
    if displayText == "" then
        displayText = "⏳ Initializing..."
    end
    -- Limit display ke 30 lines terakhir untuk performa
    local lines = {}
    for line in displayText:gmatch("[^\n]+") do
        table.insert(lines, line)
    end
    if #lines > 30 then
        lines = {unpack(lines, #lines - 29, #lines)}
    end
    logDisplay.Text = table.concat(lines, "\n")
end

-- INITIALIZE LOGS
addLog("START", "🎮 Script started!")
updateLogDisplay()

-- MAIN LOOP - AUTO RUN
task.spawn(function()
    while true do
        runCount = runCount + 1
        
        -- 🎲 ROLL
        local successRoll, resultRoll = pcall(function()
            return rollRemote:InvokeServer("requestRoll", false)
        end)

        if successRoll then
            addLog("ROLL", "✅ Roll Success")
            successCount = successCount + 1
        else
            addLog("ROLL", "❌ Roll failed")
            errorCount = errorCount + 1
        end

        -- 💰 AUTO COLLECT
        local lootId = getAvailableLoot()

        if lootId then
            local successCollect, resultCollect = pcall(function()
                return collectRemote:InvokeServer("requestCollect", lootId)
            end)
            
            if successCollect then
                addLog("LOOT", "✅ Collected")
            else
                addLog("LOOT", "❌ Collect failed")
            end
        else
            addLog("LOOT", "⚠️ Not Found")
        end

        -- UPDATE UI
        updateLogDisplay()

        task.wait(currentDelay)
    end
end)
