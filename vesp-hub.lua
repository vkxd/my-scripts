
-- [[ VESP HUB | V3 OVERHAUL ]] --
-- // Services
-- // MADE BY ITSKINGKAD

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Cleanup old instances
for _, g in pairs(game.CoreGui:GetChildren()) do
    if g.Name == "VespHubV3" then g:Destroy() end
end

-- // State
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local OriginalGravity = workspace.Gravity
local OriginalFOV = Camera.FieldOfView

local Settings = {
    -- Combat
    Aimbot = false,
    AimbotSmooth = 0.5,
    AimbotFOV = 200,
    ShowFOVCircle = false,
    TriggerBot = false,
    TriggerDelay = 0.05,
    -- Visuals
    ESP = false,
    Tracers = false,
    NameTags = false,
    BigHead = false,
    Fullbright = false,
    -- Movement
    Fly = false,
    FlySpeed = 80,
    SpeedEnabled = false,
    WalkSpeed = 50,
    JumpEnabled = false,
    JumpPower = 100,
    Noclip = false,
    NoFallDamage = false,
    LowGravity = false,
    -- Player
    GodMode = false,
    GodMethod = 1,
    Invisible = false,
    AntiAFK = true,
    -- Misc
    ChatSpam = false,
    ChatSpamMsg = "VESP on top",
    ChatSpamDelay = 2,
    -- System
    ThemeColor = Color3.fromRGB(180, 130, 255),
    AccentColor = Color3.fromRGB(120, 80, 220),
    AimbotKey = Enum.UserInputType.MouseButton2,
    Binding = false,
    BindingTarget = nil,
    Visible = true,
    Notifications = true,
}

-- // Keybinds & Toggle Registries
local Keybinds = {}
local ToggleFunctions = {}
local TracerLines = {}

-- // Drawing: FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Settings.ThemeColor
FOVCircle.Thickness = 1.2
FOVCircle.NumSides = 60
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Transparency = 0.6
FOVCircle.Visible = false

-- ================================================================
-- // UI FRAMEWORK
-- ================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VespHubV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- // Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 380, 0, 480)
Main.Position = UDim2.new(0.5, -190, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Settings.ThemeColor
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5

-- // Glow Effect (gradient behind main)
local Glow = Instance.new("ImageLabel", Main)
Glow.Name = "Glow"
Glow.Size = UDim2.new(1, 40, 0, 80)
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://7912134082"
Glow.ImageColor3 = Settings.ThemeColor
Glow.ImageTransparency = 0.85
Glow.ZIndex = 0

-- // Header
local Header = Instance.new("Frame", Main)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(16, 13, 24)
Header.BorderSizePixel = 0
Header.ZIndex = 5

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 14)

-- Header gradient bar (top accent line)
local AccentBar = Instance.new("Frame", Header)
AccentBar.Name = "AccentBar"
AccentBar.Size = UDim2.new(1, -28, 0, 2)
AccentBar.Position = UDim2.new(0, 14, 1, -2)
AccentBar.BackgroundColor3 = Settings.ThemeColor
AccentBar.BorderSizePixel = 0
AccentBar.BackgroundTransparency = 0.5
local AccentBarCorner = Instance.new("UICorner", AccentBar)
AccentBarCorner.CornerRadius = UDim.new(0, 1)

local HeaderGrad = Instance.new("UIGradient", AccentBar)
HeaderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
})
HeaderGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.3, 0),
    NumberSequenceKeypoint.new(0.7, 0),
    NumberSequenceKeypoint.new(1, 1)
})

-- // Title
local Title = Instance.new("TextLabel", Header)
Title.Text = "VESP"
Title.Size = UDim2.new(0, 55, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 19
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6

local VersionLabel = Instance.new("TextLabel", Header)
VersionLabel.Text = "v3"
VersionLabel.Size = UDim2.new(0, 20, 0, 14)
VersionLabel.Position = UDim2.new(0, 68, 0, 8)
VersionLabel.TextColor3 = Settings.ThemeColor
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.TextSize = 9
VersionLabel.BackgroundTransparency = 1
VersionLabel.ZIndex = 6

-- // Status indicator (shows # of active features)
local StatusLabel = Instance.new("TextLabel", Header)
StatusLabel.Text = "0 active"
StatusLabel.Size = UDim2.new(0, 80, 0, 20)
StatusLabel.Position = UDim2.new(1, -90, 0, 5)
StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 10
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
StatusLabel.ZIndex = 6

-- // Tab Bar
local TabBar = Instance.new("Frame", Header)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 300, 0, 28)
TabBar.Position = UDim2.new(0.5, -150, 1, -32)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 6

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0, 2)

-- // Container
local Container = Instance.new("Frame", Main)
Container.Name = "Container"
Container.Size = UDim2.new(1, -24, 1, -62)
Container.Position = UDim2.new(0, 12, 0, 56)
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.ZIndex = 2

-- // Pages
local PageNames = {"Combat", "Visuals", "Move", "Player", "Config"}
local Pages = {}
local TabBtns = {}
local TabIndicators = {}

for _, name in ipairs(PageNames) do
    local page = Instance.new("ScrollingFrame", Container)
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = (name == "Combat")
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Settings.ThemeColor
    page.ScrollBarImageTransparency = 0.5
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ZIndex = 3
    page.BorderSizePixel = 0
    page.TopImage = "rbxassetid://0"
    page.BottomImage = "rbxassetid://0"
    page.MidImage = "rbxassetid://0"

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    local padding = Instance.new("UIPadding", page)
    padding.PaddingTop = UDim.new(0, 4)

    Pages[name] = page
end

-- // Tab Button Creator
local currentTab = "Combat"
local function SwitchTab(name)
    currentTab = name
    for tName, page in pairs(Pages) do
        page.Visible = (tName == name)
    end
    for tName, btn in pairs(TabBtns) do
        local isActive = (tName == name)
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            TextColor3 = isActive and Color3.new(1,1,1) or Color3.fromRGB(90, 85, 110)
        }):Play()
        if TabIndicators[tName] then
            TweenService:Create(TabIndicators[tName], TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                BackgroundTransparency = isActive and 0 or 1,
                Size = isActive and UDim2.new(0.7, 0, 0, 2) or UDim2.new(0, 0, 0, 2)
            }):Play()
        end
    end
end

for _, name in ipairs(PageNames) do
    local short = name == "Combat" and "Combat" or name == "Visuals" and "Visual" or name == "Move" and "Move" or name == "Player" and "Player" or "Config"
    local btn = Instance.new("TextButton", TabBar)
    btn.Name = name
    btn.Size = UDim2.new(0, 58, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = short
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = (name == "Combat") and Color3.new(1,1,1) or Color3.fromRGB(90, 85, 110)
    btn.ZIndex = 7

    -- Active indicator dot
    local indicator = Instance.new("Frame", btn)
    indicator.Name = "Indicator"
    indicator.Size = (name == "Combat") and UDim2.new(0.7, 0, 0, 2) or UDim2.new(0, 0, 0, 2)
    indicator.Position = UDim2.new(0.15, 0, 1, -3)
    indicator.BackgroundColor3 = Settings.ThemeColor
    indicator.BackgroundTransparency = (name == "Combat") and 0 or 1
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 8
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(0, 2)

    TabBtns[name] = btn
    TabIndicators[name] = indicator

    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

-- ================================================================
-- // UI ELEMENT BUILDERS
-- ================================================================

local function AddCorner(obj, px)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, px or 8)
end

-- // Notification System
local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Name = "Notifications"
NotifContainer.Size = UDim2.new(0, 220, 1, 0)
NotifContainer.Position = UDim2.new(1, -230, 0, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.ZIndex = 100

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local NotifPad = Instance.new("UIPadding", NotifContainer)
NotifPad.PaddingBottom = UDim.new(0, 15)

local function Notify(text, duration)
    if not Settings.Notifications then return end
    duration = duration or 2.5
    local notif = Instance.new("Frame", NotifContainer)
    notif.Size = UDim2.new(1, 0, 0, 32)
    notif.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
    notif.BorderSizePixel = 0
    notif.ZIndex = 101
    notif.BackgroundTransparency = 1
    AddCorner(notif, 8)

    local nStroke = Instance.new("UIStroke", notif)
    nStroke.Color = Settings.ThemeColor
    nStroke.Thickness = 1
    nStroke.Transparency = 0.7

    local nLabel = Instance.new("TextLabel", notif)
    nLabel.Size = UDim2.new(1, -16, 1, 0)
    nLabel.Position = UDim2.new(0, 8, 0, 0)
    nLabel.Text = text
    nLabel.TextColor3 = Color3.new(1,1,1)
    nLabel.Font = Enum.Font.GothamSemibold
    nLabel.TextSize = 11
    nLabel.BackgroundTransparency = 1
    nLabel.TextXAlignment = Enum.TextXAlignment.Left
    nLabel.TextTransparency = 1
    nLabel.ZIndex = 102

    -- Animate in
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(nLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()

    task.delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
        TweenService:Create(nLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {TextTransparency = 1}):Play()
        task.wait(0.45)
        notif:Destroy()
    end)
end

-- // Section Label
local function AddSection(parent, text, order)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1
    f.LayoutOrder = order or 0
    f.ZIndex = 3

    local label = Instance.new("TextLabel", f)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 2, 0, 0)
    label.Text = text:upper()
    label.TextColor3 = Settings.ThemeColor
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 10
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 0.3
    label.ZIndex = 4

    -- Subtle line
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, -60, 0, 1)
    line.Position = UDim2.new(0, 58, 0.5, 0)
    line.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    line.BorderSizePixel = 0
    line.ZIndex = 4
end

-- // Toggle
local function AddToggle(parent, text, featureName, callback, order)
    local b = Instance.new("Frame", parent)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(20, 17, 28)
    b.BorderSizePixel = 0
    b.LayoutOrder = order or 0
    b.ZIndex = 3
    AddCorner(b, 8)

    -- Subtle hover effect
    local hoverStroke = Instance.new("UIStroke", b)
    hoverStroke.Color = Settings.ThemeColor
    hoverStroke.Thickness = 1
    hoverStroke.Transparency = 1

    local label = Instance.new("TextLabel", b)
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 195, 215)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    -- Modern pill toggle
    local toggleBg = Instance.new("TextButton", b)
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -46, 0.5, -9)
    toggleBg.BackgroundColor3 = Color3.fromRGB(35, 32, 48)
    toggleBg.Text = ""
    toggleBg.ZIndex = 5
    toggleBg.AutoButtonColor = false
    AddCorner(toggleBg, 10)

    local knob = Instance.new("Frame", toggleBg)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(140, 135, 160)
    knob.ZIndex = 6
    AddCorner(knob, 10)

    local state = false

    local function setState(newState)
        state = newState
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            BackgroundColor3 = state and Color3.new(1,1,1) or Color3.fromRGB(140, 135, 160)
        }):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            BackgroundColor3 = state and Settings.ThemeColor or Color3.fromRGB(35, 32, 48)
        }):Play()
        TweenService:Create(label, TweenInfo.new(0.2), {
            TextColor3 = state and Color3.new(1,1,1) or Color3.fromRGB(200, 195, 215)
        }):Play()
        callback(state)
        Notify(text .. (state and " enabled" or " disabled"), 1.5)
    end

    toggleBg.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    -- Hover effects
    b.MouseEnter:Connect(function()
        TweenService:Create(hoverStroke, TweenInfo.new(0.2), {Transparency = 0.85}):Play()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 22, 35)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(hoverStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 17, 28)}):Play()
    end)

    -- Register for keybinds
    if featureName then
        ToggleFunctions[featureName] = function()
            setState(not state)
        end
    end

    return setState
end

-- // Slider
local function AddSlider(parent, text, min, max, default, callback, order)
    local b = Instance.new("Frame", parent)
    b.Size = UDim2.new(1, 0, 0, 52)
    b.BackgroundColor3 = Color3.fromRGB(20, 17, 28)
    b.BorderSizePixel = 0
    b.LayoutOrder = order or 0
    b.ZIndex = 3
    AddCorner(b, 8)

    local label = Instance.new("TextLabel", b)
    label.Text = text .. ": " .. default
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 14, 0, 4)
    label.TextColor3 = Color3.fromRGB(200, 195, 215)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    local track = Instance.new("Frame", b)
    track.Size = UDim2.new(1, -28, 0, 4)
    track.Position = UDim2.new(0, 14, 0, 36)
    track.BackgroundColor3 = Color3.fromRGB(35, 32, 48)
    track.ZIndex = 4
    AddCorner(track, 3)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Settings.ThemeColor
    fill.BorderSizePixel = 0
    fill.ZIndex = 5
    AddCorner(fill, 3)

    local knob = Instance.new("TextButton", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Text = ""
    knob.ZIndex = 6
    knob.AutoButtonColor = false
    AddCorner(knob, 10)

    local dragging = false
    knob.MouseButton1Down:Connect(function() dragging = true end)
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouseX = UserInputService:GetMouseLocation().X
            local percent = math.clamp((mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(percent, 0, 0.5, 0)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- // Button
local function AddButton(parent, text, callback, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(20, 17, 28)
    btn.Text = ""
    btn.LayoutOrder = order or 0
    btn.ZIndex = 3
    btn.AutoButtonColor = false
    AddCorner(btn, 8)

    local hoverStroke = Instance.new("UIStroke", btn)
    hoverStroke.Color = Settings.ThemeColor
    hoverStroke.Thickness = 1
    hoverStroke.Transparency = 1

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 195, 215)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    -- Arrow icon
    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "›"
    arrow.TextColor3 = Color3.fromRGB(100, 95, 120)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 18
    arrow.BackgroundTransparency = 1
    arrow.ZIndex = 4

    btn.MouseButton1Click:Connect(function()
        -- Flash effect
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Settings.ThemeColor}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 17, 28)}):Play()
        callback()
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(hoverStroke, TweenInfo.new(0.2), {Transparency = 0.85}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(hoverStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    end)
end

-- // Hue Slider
local function AddHueSlider(parent, order)
    local b = Instance.new("Frame", parent)
    b.Size = UDim2.new(1, 0, 0, 52)
    b.BackgroundColor3 = Color3.fromRGB(20, 17, 28)
    b.LayoutOrder = order or 0
    b.ZIndex = 3
    AddCorner(b, 8)

    local label = Instance.new("TextLabel", b)
    label.Text = "Theme Color"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 14, 0, 4)
    label.TextColor3 = Color3.fromRGB(200, 195, 215)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    local gradFrame = Instance.new("Frame", b)
    gradFrame.Size = UDim2.new(1, -28, 0, 8)
    gradFrame.Position = UDim2.new(0, 14, 0, 34)
    gradFrame.ZIndex = 4
    AddCorner(gradFrame, 4)

    local grad = Instance.new("UIGradient", gradFrame)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1)),
    })

    local knob = Instance.new("TextButton", gradFrame)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0.75, -7, 0.5, -7)
    knob.Text = ""
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.ZIndex = 6
    knob.AutoButtonColor = false
    AddCorner(knob, 10)

    local h_dragging = false
    knob.MouseButton1Down:Connect(function() h_dragging = true end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then h_dragging = false end end)

    RunService.RenderStepped:Connect(function()
        if h_dragging then
            local percent = math.clamp((UserInputService:GetMouseLocation().X - gradFrame.AbsolutePosition.X) / gradFrame.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(percent, -7, 0.5, -7)
            Settings.ThemeColor = Color3.fromHSV(percent, 0.7, 1)
            MainStroke.Color = Settings.ThemeColor
            AccentBar.BackgroundColor3 = Settings.ThemeColor
            Glow.ImageColor3 = Settings.ThemeColor
            FOVCircle.Color = Settings.ThemeColor
            for _, ind in pairs(TabIndicators) do
                ind.BackgroundColor3 = Settings.ThemeColor
            end
        end
    end)
end

-- // Keybind Button
local function AddKeybindButton(parent, featureName, displayName, order)
    local b = Instance.new("Frame", parent)
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(20, 17, 28)
    b.LayoutOrder = order or 0
    b.ZIndex = 3
    AddCorner(b, 8)

    local label = Instance.new("TextLabel", b)
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Text = displayName
    label.TextColor3 = Color3.fromRGB(180, 175, 200)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    local btn = Instance.new("TextButton", b)
    btn.Size = UDim2.new(0, 80, 0, 24)
    btn.Position = UDim2.new(1, -90, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(30, 27, 42)
    btn.Text = Keybinds[featureName] and Keybinds[featureName].Name or "—"
    btn.TextColor3 = Color3.fromRGB(160, 155, 180)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.ZIndex = 5
    btn.AutoButtonColor = false
    AddCorner(btn, 6)

    btn.MouseButton1Click:Connect(function()
        Settings.Binding = true
        Settings.BindingTarget = featureName
        btn.Text = "..."
        btn.TextColor3 = Settings.ThemeColor

        local conn
        conn = UserInputService.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 then return end

            local key = (i.KeyCode ~= Enum.KeyCode.Unknown) and i.KeyCode or i.UserInputType

            if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace then
                Keybinds[featureName] = nil
                btn.Text = "—"
                btn.TextColor3 = Color3.fromRGB(160, 155, 180)
                Notify(displayName .. " keybind cleared", 1.5)
            else
                Keybinds[featureName] = key
                btn.Text = key.Name
                btn.TextColor3 = Color3.fromRGB(160, 155, 180)
                Notify(displayName .. " → " .. key.Name, 1.5)
            end

            Settings.Binding = false
            Settings.BindingTarget = nil
            conn:Disconnect()
        end)
    end)
end

-- ================================================================
-- // DRAGGING
-- ================================================================
local dragStart, startPos, draggingUI
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingUI = true; dragStart = i.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if draggingUI and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingUI = false end
end)

-- // Alt Key Hide (smooth)
UserInputService.InputBegan:Connect(function(i, gpe)
    if not gpe and i.KeyCode == Enum.KeyCode.LeftAlt then
        Settings.Visible = not Settings.Visible
        if Settings.Visible then
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 380, 0, 480),
                BackgroundTransparency = 0
            }):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 380, 0, 0),
                BackgroundTransparency = 0.5
            }):Play()
            task.delay(0.3, function()
                if not Settings.Visible then Main.Visible = false end
            end)
        end
    end
end)

-- // Capture Original Speed/Jump
local function CaptureOriginals()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        if not Settings.SpeedEnabled then OriginalWalkSpeed = hum.WalkSpeed end
        if not Settings.JumpEnabled then OriginalJumpPower = hum.JumpPower end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    CaptureOriginals()
end)

task.spawn(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        task.wait(1)
        CaptureOriginals()
    end
end)

-- ================================================================
-- // ACTIVE FEATURES COUNTER
-- ================================================================
RunService.Heartbeat:Connect(function()
    local count = 0
    local checks = {"Aimbot","ESP","Tracers","Fly","SpeedEnabled","JumpEnabled","Noclip","GodMode","BigHead","TriggerBot","NameTags","Invisible","Fullbright","LowGravity","NoFallDamage","ChatSpam"}
    for _, k in pairs(checks) do
        if Settings[k] then count = count + 1 end
    end
    StatusLabel.Text = count .. " active"
    StatusLabel.TextColor3 = count > 0 and Settings.ThemeColor or Color3.fromRGB(100, 100, 120)
end)

-- ================================================================
-- // GAME LOGIC LOOPS
-- ================================================================

-- // Movement & Player Loop
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local hum = char.Humanoid

    -- Speed Toggle
    if Settings.SpeedEnabled then
        hum.WalkSpeed = Settings.WalkSpeed
    end

    -- Jump Toggle
    if Settings.JumpEnabled then
        hum.JumpPower = Settings.JumpPower
    end

    -- God Mode (multiple methods)
    if Settings.GodMode then
        -- Method 1: MaxHealth + Health loop
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end)
        -- Method 2: ForceField
        if not char:FindFirstChildOfClass("ForceField") then
            pcall(function()
                local ff = Instance.new("ForceField", char)
                ff.Name = "VespFF"
                ff.Visible = false
            end)
        end
        -- Method 3: Block damage remote events (attempt to find common patterns)
        pcall(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("Script") and (v.Name:lower():find("damage") or v.Name:lower():find("health")) then
                    v.Disabled = true
                end
            end
        end)
    else
        -- Cleanup forcefield
        local ff = char:FindFirstChild("VespFF")
        if ff then ff:Destroy() end
    end

    -- Noclip
    if Settings.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- No Fall Damage
    if Settings.NoFallDamage then
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
    end

    -- Invisible
    if Settings.Invisible then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = 1
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
        if char:FindFirstChild("Head") then
            local face = char.Head:FindFirstChild("face") or char.Head:FindFirstChildOfClass("Decal")
            if face then face.Transparency = 1 end
        end
    end

    -- Low Gravity
    if Settings.LowGravity then
        workspace.Gravity = 50
    end

    -- Fly
    if Settings.Fly and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if not hrp:FindFirstChild("VespFly") then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "VespFly"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            local bg = Instance.new("BodyGyro", hrp)
            bg.Name = "VespGyro"
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        end
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        hrp.VespFly.Velocity = moveDir * Settings.FlySpeed
        hrp.VespGyro.CFrame = Camera.CFrame
    elseif char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("VespFly") then
        char.HumanoidRootPart.VespFly:Destroy()
        char.HumanoidRootPart.VespGyro:Destroy()
    end
end)

-- // Big Head
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if Settings.BigHead then
                pcall(function() p.Character.Head.Size = Vector3.new(5, 5, 5) end)
            end
        end
    end
end)

-- // ESP, Tracers & Name Tags
RunService.RenderStepped:Connect(function()
    -- ESP Highlights
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("VespHigh")
            if Settings.ESP and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not h then
                    h = Instance.new("Highlight", p.Character)
                    h.Name = "VespHigh"
                end
                h.FillColor = Settings.ThemeColor
                h.FillTransparency = 0.65
                h.OutlineColor = Settings.ThemeColor
                h.OutlineTransparency = 0.3
            elseif h then
                h:Destroy()
            end
        end
    end

    -- Name Tags
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local tag = p.Character.Head:FindFirstChild("VespTag")
            if Settings.NameTags and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not tag then
                    tag = Instance.new("BillboardGui", p.Character.Head)
                    tag.Name = "VespTag"
                    tag.Size = UDim2.new(0, 180, 0, 40)
                    tag.StudsOffset = Vector3.new(0, 3, 0)
                    tag.AlwaysOnTop = true
                    tag.MaxDistance = 500

                    local nameLabel = Instance.new("TextLabel", tag)
                    nameLabel.Name = "NameLabel"
                    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.TextSize = 13
                    nameLabel.TextStrokeTransparency = 0.5
                    nameLabel.TextColor3 = Settings.ThemeColor

                    local hpLabel = Instance.new("TextLabel", tag)
                    hpLabel.Name = "HPLabel"
                    hpLabel.Size = UDim2.new(1, 0, 0.4, 0)
                    hpLabel.Position = UDim2.new(0, 0, 0.55, 0)
                    hpLabel.BackgroundTransparency = 1
                    hpLabel.Font = Enum.Font.GothamSemibold
                    hpLabel.TextSize = 10
                    hpLabel.TextStrokeTransparency = 0.6
                end
                local hum = p.Character.Humanoid
                local hp = math.floor(hum.Health)
                local maxHp = math.floor(hum.MaxHealth)
                tag.NameLabel.Text = p.DisplayName
                tag.NameLabel.TextColor3 = Settings.ThemeColor

                -- Health color: green > yellow > red
                local ratio = hum.Health / math.max(hum.MaxHealth, 1)
                local hpColor = Color3.fromRGB(
                    math.floor(255 * (1 - ratio)),
                    math.floor(255 * ratio),
                    50
                )
                tag.HPLabel.Text = hp .. " / " .. maxHp
                tag.HPLabel.TextColor3 = hpColor
            elseif tag then
                tag:Destroy()
            end
        end
    end

    -- Tracers (Drawing API)
    for _, line in pairs(TracerLines) do
        pcall(function() line:Remove() end)
    end
    TracerLines = {}

    if Settings.Tracers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local line = Drawing.new("Line")
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Color = Settings.ThemeColor
                        line.Thickness = 1.5
                        line.Transparency = 0.7
                        line.Visible = true
                        table.insert(TracerLines, line)
                    end
                end
            end
        end
    end
end)

-- // FOV Circle Update
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Color = Settings.ThemeColor
    FOVCircle.Visible = Settings.ShowFOVCircle and Settings.Aimbot
end)

-- // Aimbot Loop
RunService.RenderStepped:Connect(function()
    if not Settings.Aimbot then return end

    local isPressed = false
    if typeof(Settings.AimbotKey) == "EnumItem" then
        if Settings.AimbotKey.EnumType == Enum.KeyCode then
            isPressed = UserInputService:IsKeyDown(Settings.AimbotKey)
        elseif Settings.AimbotKey.EnumType == Enum.UserInputType then
            isPressed = UserInputService:IsMouseButtonPressed(Settings.AimbotKey)
        end
    end

    if isPressed then
        local target, minDist = nil, Settings.AimbotFOV
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < minDist then
                            minDist = dist
                            target = p
                        end
                    end
                end
            end
        end

        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetCF = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.AimbotSmooth)
        end
    end
end)

-- // Trigger Bot
task.spawn(function()
    while true do
        task.wait(Settings.TriggerDelay)
        if Settings.TriggerBot then
            local target = Mouse.Target
            if target then
                local model = target:FindFirstAncestorOfClass("Model")
                if model then
                    local p = Players:GetPlayerFromCharacter(model)
                    if p and p ~= LocalPlayer then
                        mouse1click()
                    end
                end
            end
        end
    end
end)

-- // Fullbright
RunService.RenderStepped:Connect(function()
    if Settings.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

-- // Anti-AFK
task.spawn(function()
    while true do
        task.wait(60)
        if Settings.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

-- // Chat Spam
task.spawn(function()
    while true do
        task.wait(Settings.ChatSpamDelay)
        if Settings.ChatSpam then
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.ChatSpamMsg, "All")
            end)
        end
    end
end)

-- ================================================================
-- // KEYBIND INPUT HANDLER
-- ================================================================
UserInputService.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if Settings.Binding then return end

    for featureName, key in pairs(Keybinds) do
        local match = false
        if i.KeyCode ~= Enum.KeyCode.Unknown and i.KeyCode == key then match = true end
        if i.UserInputType == key then match = true end

        if match and ToggleFunctions[featureName] then
            ToggleFunctions[featureName]()
        end
    end
end)

-- ================================================================
-- // POPULATE PAGES
-- ================================================================

-- ==================== COMBAT ====================
AddSection(Pages.Combat, "Targeting", 1)
AddToggle(Pages.Combat, "Aimbot", "Aimbot", function(v) Settings.Aimbot = v end, 2)
AddSlider(Pages.Combat, "Aim Smoothing", 1, 100, 50, function(v) Settings.AimbotSmooth = v / 100 end, 3)
AddSlider(Pages.Combat, "Aim FOV", 50, 800, 200, function(v) Settings.AimbotFOV = v end, 4)
AddToggle(Pages.Combat, "Show FOV Circle", "ShowFOV", function(v) Settings.ShowFOVCircle = v end, 5)
AddToggle(Pages.Combat, "Trigger Bot", "TriggerBot", function(v) Settings.TriggerBot = v end, 6)

AddSection(Pages.Combat, "Hitbox", 7)
AddToggle(Pages.Combat, "Big Head", "BigHead", function(v) Settings.BigHead = v end, 8)

-- ==================== VISUALS ====================
AddSection(Pages.Visuals, "Players", 1)
AddToggle(Pages.Visuals, "ESP Chams", "ESP", function(v) Settings.ESP = v end, 2)
AddToggle(Pages.Visuals, "Tracers", "Tracers", function(v) Settings.Tracers = v end, 3)
AddToggle(Pages.Visuals, "Name Tags", "NameTags", function(v) Settings.NameTags = v end, 4)

AddSection(Pages.Visuals, "World", 5)
AddToggle(Pages.Visuals, "Fullbright", "Fullbright", function(v)
    Settings.Fullbright = v
    if not v then
        -- Reset lighting
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
    end
end, 6)

-- ==================== MOVE ====================
AddSection(Pages.Move, "Speed & Jump", 1)
AddToggle(Pages.Move, "Speed Boost", "Speed", function(v)
    Settings.SpeedEnabled = v
    if not v then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and OriginalWalkSpeed then
            char.Humanoid.WalkSpeed = OriginalWalkSpeed
        end
    end
end, 2)
AddSlider(Pages.Move, "Speed Value", 16, 500, 50, function(v) Settings.WalkSpeed = v end, 3)

AddToggle(Pages.Move, "Jump Boost", "Jump", function(v)
    Settings.JumpEnabled = v
    if not v then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and OriginalJumpPower then
            char.Humanoid.JumpPower = OriginalJumpPower
        end
    end
end, 4)
AddSlider(Pages.Move, "Jump Value", 50, 1000, 100, function(v) Settings.JumpPower = v end, 5)

AddSection(Pages.Move, "Movement", 6)
AddToggle(Pages.Move, "Fly", "Fly", function(v) Settings.Fly = v end, 7)
AddSlider(Pages.Move, "Fly Speed", 20, 500, 80, function(v) Settings.FlySpeed = v end, 8)
AddToggle(Pages.Move, "Noclip", "Noclip", function(v) Settings.Noclip = v end, 9)
AddToggle(Pages.Move, "No Fall Damage", "NoFallDmg", function(v)
    Settings.NoFallDamage = v
    if not v then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end
end, 10)
AddToggle(Pages.Move, "Low Gravity", "LowGrav", function(v)
    Settings.LowGravity = v
    if not v then workspace.Gravity = OriginalGravity end
end, 11)

-- ==================== PLAYER ====================
AddSection(Pages.Player, "Survival", 1)
AddToggle(Pages.Player, "God Mode", "GodMode", function(v)
    Settings.GodMode = v
    if not v then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            pcall(function()
                char.Humanoid.MaxHealth = 100
                char.Humanoid.Health = 100
            end)
        end
        local ff = char and char:FindFirstChild("VespFF")
        if ff then ff:Destroy() end
    end
end, 2)
AddToggle(Pages.Player, "Invisible", "Invisible", function(v)
    Settings.Invisible = v
    if not v then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    if part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0
                    end
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = 0
                end
            end
        end
    end
end, 3)

AddSection(Pages.Player, "Misc", 4)
AddToggle(Pages.Player, "Anti-AFK", "AntiAFK", function(v) Settings.AntiAFK = v end, 5)
AddToggle(Pages.Player, "Chat Spam", "ChatSpam", function(v) Settings.ChatSpam = v end, 6)

AddSection(Pages.Player, "Actions", 7)
AddButton(Pages.Player, "Respawn", function()
    local char = LocalPlayer.Character
    if char then char:BreakJoints() end
    Notify("Respawning...", 1.5)
end, 8)
AddButton(Pages.Player, "Server Hop", function()
    Notify("Finding new server...", 2)
    pcall(function()
        local placeId = game.PlaceId
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, server.id)
                return
            end
        end
        Notify("No servers found", 2)
    end)
end, 9)
AddButton(Pages.Player, "Rejoin Server", function()
    Notify("Rejoining...", 1.5)
    TeleportService:Teleport(game.PlaceId)
end, 10)
AddButton(Pages.Player, "Infinite Yield", function()
    Notify("Loading IY...", 2)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end, 11)

-- ==================== CONFIG ====================
AddSection(Pages.Config, "Theme", 1)
AddHueSlider(Pages.Config, 2)
AddToggle(Pages.Config, "Notifications", "Notifs", function(v) Settings.Notifications = v end, 3)

AddSection(Pages.Config, "Aimbot Key", 4)
do
    local bFrame = Instance.new("Frame", Pages.Config)
    bFrame.Size = UDim2.new(1, 0, 0, 38)
    bFrame.BackgroundColor3 = Color3.fromRGB(20, 17, 28)
    bFrame.LayoutOrder = 5
    bFrame.ZIndex = 3
    AddCorner(bFrame, 8)

    local bLabel = Instance.new("TextLabel", bFrame)
    bLabel.Size = UDim2.new(0.55, 0, 1, 0)
    bLabel.Position = UDim2.new(0, 14, 0, 0)
    bLabel.Text = "Aim Hold Key"
    bLabel.TextColor3 = Color3.fromRGB(180, 175, 200)
    bLabel.Font = Enum.Font.GothamSemibold
    bLabel.TextSize = 12
    bLabel.BackgroundTransparency = 1
    bLabel.TextXAlignment = Enum.TextXAlignment.Left
    bLabel.ZIndex = 4

    local bKey = Instance.new("TextButton", bFrame)
    bKey.Size = UDim2.new(0, 80, 0, 24)
    bKey.Position = UDim2.new(1, -90, 0.5, -12)
    bKey.BackgroundColor3 = Color3.fromRGB(30, 27, 42)
    bKey.Text = Settings.AimbotKey.Name
    bKey.TextColor3 = Color3.fromRGB(160, 155, 180)
    bKey.Font = Enum.Font.GothamSemibold
    bKey.TextSize = 10
    bKey.ZIndex = 5
    bKey.AutoButtonColor = false
    AddCorner(bKey, 6)

    bKey.MouseButton1Click:Connect(function()
        Settings.Binding = true
        bKey.Text = "..."
        bKey.TextColor3 = Settings.ThemeColor

        local conn
        conn = UserInputService.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 then return end

            Settings.AimbotKey = (i.KeyCode ~= Enum.KeyCode.Unknown) and i.KeyCode or i.UserInputType
            bKey.Text = Settings.AimbotKey.Name
            bKey.TextColor3 = Color3.fromRGB(160, 155, 180)
            Settings.Binding = false
            Notify("Aim key → " .. Settings.AimbotKey.Name, 1.5)
            conn:Disconnect()
        end)
    end)
end

AddSection(Pages.Config, "Toggle Keybinds", 6)
AddKeybindButton(Pages.Config, "Aimbot", "Aimbot", 7)
AddKeybindButton(Pages.Config, "ESP", "ESP Chams", 8)
AddKeybindButton(Pages.Config, "Tracers", "Tracers", 9)
AddKeybindButton(Pages.Config, "NameTags", "Name Tags", 10)
AddKeybindButton(Pages.Config, "BigHead", "Big Head", 11)
AddKeybindButton(Pages.Config, "Speed", "Speed Boost", 12)
AddKeybindButton(Pages.Config, "Jump", "Jump Boost", 13)
AddKeybindButton(Pages.Config, "Fly", "Fly", 14)
AddKeybindButton(Pages.Config, "Noclip", "Noclip", 15)
AddKeybindButton(Pages.Config, "NoFallDmg", "No Fall Dmg", 16)
AddKeybindButton(Pages.Config, "LowGrav", "Low Gravity", 17)
AddKeybindButton(Pages.Config, "GodMode", "God Mode", 18)
AddKeybindButton(Pages.Config, "Invisible", "Invisible", 19)
AddKeybindButton(Pages.Config, "TriggerBot", "Trigger Bot", 20)
AddKeybindButton(Pages.Config, "Fullbright", "Fullbright", 21)

-- // Startup notification
task.delay(1, function()
    Notify("VESP v3 loaded", 3)
    Notify("Press Left Alt to hide", 3)
end)
