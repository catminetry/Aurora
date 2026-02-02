-- Aurora UI Library 完整使用示例
-- 展示所有功能和组件的使用方法

local Aurora = require(script.Aurora)

-- 初始化 UI 系统
local ui = Aurora:Init({
    Theme = "Modern",
    DPIScale = 1.2,
    AnimationSpeed = 0.2,
    Language = "zh" -- 支持多语言
})

-- 创建主窗口
local mainWindow = ui:CreateWindow({
    Title = "Aurora UI 演示",
    Size = UDim2.fromOffset(800, 600),
    Position = UDim2.fromScale(0.5, 0.5),
    Resizable = true,
    Minimizable = true,
    CornerRadius = 12
})

-- 将窗口添加到玩家 GUI
mainWindow:Mount(game.Players.LocalPlayer.PlayerGui)

-- 添加标签页
local homeTab = mainWindow:AddTab("首页", "🏠")
local settingsTab = mainWindow:AddTab("设置", "⚙️")
local toolsTab = mainWindow:AddTab("工具", "🛠️")
local aboutTab = mainWindow:AddTab("关于", "ℹ️")

-- ========== 首页标签页内容 ==========
print("设置首页标签页内容...")

-- 创建欢迎面板
local welcomePanel = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 120),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60)
})
homeTab:AddChild(welcomePanel)

local welcomeLabel = Aurora.Label:New({
    Text = "欢迎使用 Aurora UI",
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 10),
    TextColor = Color3.fromRGB(255, 255, 255)
})
welcomePanel:AddChild(welcomeLabel)

local descriptionLabel = Aurora.Label:New({
    Text = "这是一个现代化的 Roblox UI 库，具有响应式设计和丰富的组件。",
    Size = UDim2.new(1, -20, 0, 60),
    Position = UDim2.new(0, 10, 0, 50),
    TextColor = Color3.fromRGB(200, 200, 200)
})
welcomePanel:AddChild(descriptionLabel)

-- 创建功能按钮网格
local buttonGrid = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 200),
    Position = UDim2.new(0, 10, 0, 140),
    BackgroundTransparency = 1
})
homeTab:AddChild(buttonGrid)

local buttonLayout = Aurora.Component.New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 10)
})
buttonGrid:AddChild(buttonLayout)

-- 创建多个功能按钮
local function createFeatureButton(text, color, onClick)
    local button = Aurora.Button:New({
        Text = text,
        Size = UDim2.new(0.3, -10, 0, 80),
        OnClick = onClick
    })
    button:SetProperty("BackgroundColor3", color)
    return button
end

local feature1 = createFeatureButton("快速开始", Color3.fromRGB(70, 130, 250), function()
    print("快速开始功能被点击")
    ui:Notify("开始你的 Aurora UI 之旅！")
end)

local feature2 = createFeatureButton("组件演示", Color3.fromRGB(250, 180, 50), function()
    print("组件演示功能被点击")
    mainWindow:SwitchToTab("工具")
end)

local feature3 = createFeatureButton("主题切换", Color3.fromRGB(150, 220, 100), function()
    print("主题切换功能被点击")
    -- 切换主题
    local currentTheme = ui.ThemeManager.CurrentTheme
    local newTheme = currentTheme == "Dark" and "Light" or "Dark"
    ui.ThemeManager:SetTheme(newTheme)
end)

buttonGrid:AddChild(feature1)
buttonGrid:AddChild(feature2)
buttonGrid:AddChild(feature3)

-- ========== 设置标签页内容 ==========
print("设置设置标签页内容...")

-- 主题设置
local themeSection = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 180),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60)
})
settingsTab:AddChild(themeSection)

local themeLabel = Aurora.Label:New({
    Text = "主题设置",
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    TextColor = Color3.fromRGB(255, 255, 255)
})
themeSection:AddChild(themeLabel)

-- 主题选择按钮
local themeButtons = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundTransparency = 1
})
themeSection:AddChild(themeButtons)

local themeLayout = Aurora.Component.New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 10)
})
themeButtons:AddChild(themeLayout)

local darkThemeBtn = Aurora.Button:New({
    Text = "深色主题",
    Size = UDim2.new(0.3, 0, 1, 0),
    OnClick = function()
        ui.ThemeManager:SetTheme("Dark")
    end
})

local lightThemeBtn = Aurora.Button:New({
    Text = "浅色主题",
    Size = UDim2.new(0.3, 0, 1, 0),
    OnClick = function()
        ui.ThemeManager:SetTheme("Light")
    end
})

local modernThemeBtn = Aurora.Button:New({
    Text = "现代主题",
    Size = UDim2.new(0.3, 0, 1, 0),
    OnClick = function()
        ui.ThemeManager:SetTheme("Modern")
    end
})

themeButtons:AddChild(darkThemeBtn)
themeButtons:AddChild(lightThemeBtn)
themeButtons:AddChild(modernThemeBtn)

-- 界面设置
local uiSection = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 150),
    Position = UDim2.new(0, 10, 0, 200),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60)
})
settingsTab:AddChild(uiSection)

local uiLabel = Aurora.Label:New({
    Text = "界面设置",
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    TextColor = Color3.fromRGB(255, 255, 255)
})
uiSection:AddChild(uiLabel)

-- DPI 缩放设置
local dpiSlider = Aurora.Slider:New({
    Text = "界面缩放",
    Min = 50,
    Max = 200,
    Default = 120,
    OnChange = function(value)
        print("DPI 缩放设置为:", value)
        -- 这里可以添加实际的 DPI 缩放逻辑
    end
})
dpiSlider:SetProperty("Position", UDim2.new(0, 10, 0, 50))
uiSection:AddChild(dpiSlider)

-- 动画速度设置
local animSlider = Aurora.Slider:New({
    Text = "动画速度",
    Min = 0,
    Max = 100,
    Default = 20,
    OnChange = function(value)
        print("动画速度设置为:", value)
    end
})
animSlider:SetProperty("Position", UDim2.new(0, 10, 0, 120))
uiSection:AddChild(animSlider)

-- ========== 工具标签页内容 ==========
print("设置工具标签页内容...")

-- 组件演示区域
local demoSection = Aurora.Component.New("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -20),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(30, 35, 45),
    ScrollBarThickness = 6,
    CanvasSize = UDim2.new(0, 0, 0, 800) -- 可滚动内容高度
})
toolsTab:AddChild(demoSection)

-- 按钮组件演示
local buttonDemo = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 120),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60)
})
demoSection:AddChild(buttonDemo)

local buttonDemoLabel = Aurora.Label:New({
    Text = "按钮组件演示",
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    TextColor = Color3.fromRGB(255, 255, 255)
})
buttonDemo:AddChild(buttonDemoLabel)

-- 不同样式的按钮
local demoButtons = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 60),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundTransparency = 1
})
buttonDemo:AddChild(demoButtons)

local buttonLayout = Aurora.Component.New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 10)
})
demoButtons:AddChild(buttonLayout)

local primaryBtn = Aurora.Button:New({
    Text = "主要按钮",
    Size = UDim2.new(0.3, 0, 0, 40),
    OnClick = function()
        print("主要按钮被点击")
    end
})

local successBtn = Aurora.Button:New({
    Text = "成功按钮",
    Size = UDim2.new(0.3, 0, 0, 40),
    OnClick = function()
        print("成功按钮被点击")
    end
})
successBtn:SetProperty("BackgroundColor3", Color3.fromRGB(100, 200, 100))

local warningBtn = Aurora.Button:New({
    Text = "警告按钮",
    Size = UDim2.new(0.3, 0, 0, 40),
    OnClick = function()
        print("警告按钮被点击")
    end
})
warningBtn:SetProperty("BackgroundColor3", Color3.fromRGB(255, 180, 50))

demoButtons:AddChild(primaryBtn)
demoButtons:AddChild(successBtn)
demoButtons:AddChild(warningBtn)

-- 滑块组件演示
local sliderDemo = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 180),
    Position = UDim2.new(0, 10, 0, 150),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60)
})
demoSection:AddChild(sliderDemo)

local sliderDemoLabel = Aurora.Label:New({
    Text = "滑块组件演示",
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    TextColor = Color3.fromRGB(255, 255, 255)
})
sliderDemo:AddChild(sliderDemoLabel)

-- 多个滑块演示
local volumeSlider = Aurora.Slider:New({
    Text = "音量控制",
    Min = 0,
    Max = 100,
    Default = 75,
    OnChange = function(value)
        print("音量设置为:", value)
    end
})
volumeSlider:SetProperty("Position", UDim2.new(0, 10, 0, 50))
sliderDemo:AddChild(volumeSlider)

local brightnessSlider = Aurora.Slider:New({
    Text = "亮度调节",
    Min = 0,
    Max = 100,
    Default = 50,
    OnChange = function(value)
        print("亮度设置为:", value)
    end
})
brightnessSlider:SetProperty("Position", UDim2.new(0, 10, 0, 120))
sliderDemo:AddChild(brightnessSlider)

-- 动画演示
local animationDemo = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 0, 120),
    Position = UDim2.new(0, 10, 0, 350),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60)
})
demoSection:AddChild(animationDemo)

local animationLabel = Aurora.Label:New({
    Text = "动画效果演示",
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    TextColor = Color3.fromRGB(255, 255, 255)
})
animationDemo:AddChild(animationLabel)

local animateButton = Aurora.Button:New({
    Text = "点击动画",
    Size = UDim2.new(0.4, 0, 0, 40),
    OnClick = function()
        -- 创建动画效果
        animateButton:Animate({
            Size = UDim2.new(0.45, 0, 0, 45),
            BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        }, {
            Duration = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDirection = Enum.EasingDirection.Out
        })
        
        -- 动画完成后恢复
        task.wait(0.3)
        animateButton:Animate({
            Size = UDim2.new(0.4, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        })
    end
})
animateButton:SetProperty("Position", UDim2.new(0.3, 0, 0, 50))
animationDemo:AddChild(animateButton)

-- ========== 关于标签页内容 ==========
print("设置关于标签页内容...")

local aboutContent = Aurora.Component.New("Frame", {
    Size = UDim2.new(1, -20, 1, -20),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(40, 45, 60)
})
aboutTab:AddChild(aboutContent)

local aboutTitle = Aurora.Label:New({
    Text = "Aurora UI Library",
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 20),
    TextColor = Color3.fromRGB(120, 180, 255),
    TextSize = 24
})
aboutContent:AddChild(aboutTitle)

local versionLabel = Aurora.Label:New({
    Text = "版本: 1.0.0",
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 70),
    TextColor = Color3.fromRGB(200, 200, 200)
})
aboutContent:AddChild(versionLabel)

local description = Aurora.Label:New({
    Text = "Aurora UI 是一个现代化的 Roblox UI 库，具有以下特性：\n\n• 响应式设计，支持移动端和桌面端\n• 丰富的组件库和动画效果\n• 灵活的主题系统\n• 易于使用的 API 设计\n• 高性能和可扩展性",
    Size = UDim2.new(1, -20, 0, 120),
    Position = UDim2.new(0, 10, 0, 110),
    TextColor = Color3.fromRGB(180, 180, 200),
    TextSize = 14
})
aboutContent:AddChild(description)

local featuresLabel = Aurora.Label:New({
    Text = "主要功能",
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 250),
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 18
})
aboutContent:AddChild(featuresLabel)

local featuresList = Aurora.Label:New({
    Text = "✓ 窗口管理系统\n✓ 主题切换\n✓ 动画引擎\n✓ 响应式布局\n✓ 组件化设计\n✓ 事件系统",
    Size = UDim2.new(1, -20, 0, 120),
    Position = UDim2.new(0, 10, 0, 290),
    TextColor = Color3.fromRGB(200, 220, 255),
    TextSize = 14
})
aboutContent:AddChild(featuresList)

-- ========== 响应式设计演示 ==========
print("设置响应式设计...")

-- 监听屏幕尺寸变化
ui.Responsive:OnBreakpointChange(function(newBreakpoint, oldBreakpoint)
    print("屏幕尺寸变化:", oldBreakpoint, "->", newBreakpoint)
    
    -- 根据屏幕尺寸调整布局
    if newBreakpoint == "Mobile" then
        -- 移动端布局
        mainWindow:SetProperty("Size", UDim2.fromOffset(350, 500))
        welcomeLabel:SetProperty("TextSize", 16)
        descriptionLabel:SetProperty("TextSize", 12)
    elseif newBreakpoint == "Tablet" then
        -- 平板端布局
        mainWindow:SetProperty("Size", UDim2.fromOffset(600, 500))
        welcomeLabel:SetProperty("TextSize", 18)
        descriptionLabel:SetProperty("TextSize", 14)
    else
        -- 桌面端布局
        mainWindow:SetProperty("Size", UDim2.fromOffset(800, 600))
        welcomeLabel:SetProperty("TextSize", 20)
        descriptionLabel:SetProperty("TextSize", 16)
    end
end)

-- ========== 主题切换演示 ==========
print("设置主题切换...")

-- 监听主题变化
ui.ThemeManager:OnThemeChange(function(oldTheme, newTheme)
    print("主题已切换:", oldTheme, "->", newTheme)
    
    -- 根据主题更新界面元素
    local theme = ui.ThemeManager:GetTheme()
    
    -- 更新窗口颜色
    mainWindow:SetProperty("BackgroundColor3", theme.Background)
    
    -- 更新面板颜色
    local panels = {welcomePanel, themeSection, uiSection, buttonDemo, sliderDemo, animationDemo, aboutContent}
    for _, panel in ipairs(panels) do
        panel:SetProperty("BackgroundColor3", theme.Surface)
    end
    
    -- 更新文本颜色
    local labels = {welcomeLabel, descriptionLabel, themeLabel, uiLabel, buttonDemoLabel, sliderDemoLabel, animationLabel, aboutTitle, versionLabel, description, featuresLabel, featuresList}
    for _, label in ipairs(labels) do
        label:SetProperty("TextColor3", theme.Text)
    end
end)

-- ========== 高级功能演示 ==========
print("设置高级功能...")

-- 创建浮动操作按钮
local fab = Aurora.Button:New({
    Text = "+",
    Size = UDim2.fromOffset(60, 60),
    OnClick = function()
        print("浮动按钮被点击")
        -- 显示快速操作菜单
        showQuickActions()
    end
})
fab:SetProperty("Position", UDim2.new(1, -80, 1, -80))
fab:SetProperty("BackgroundColor3", Color3.fromRGB(120, 180, 255))
fab:Mount(mainWindow.Element) -- 添加到窗口

-- 为 FAB 添加圆角
local fabCorner = Instance.new("UICorner")
fabCorner.CornerRadius = UDim.new(1, 0)
fabCorner.Parent = fab.Element

-- 快速操作菜单函数
local function showQuickActions()
    local quickMenu = Aurora.Component.New("Frame", {
        Size = UDim2.fromOffset(150, 200),
        Position = UDim2.new(1, -160, 1, -260),
        BackgroundColor3 = Color3.fromRGB(50, 55, 70),
        Visible = false
    })
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = quickMenu.Element
    
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Transparency = 0.7
    shadow.Parent = quickMenu.Element
    
    quickMenu:Mount(mainWindow.Element)
    quickMenu:SetProperty("Visible", true)
    
    -- 添加快速操作选项
    local actions = {
        {"新建项目", function() print("新建项目") end},
        {"保存设置", function() print("保存设置") end},
        {"导出配置", function() print("导出配置") end},
        {"帮助", function() print("显示帮助") end}
    }
    
    for i, action in ipairs(actions) do
        local actionBtn = Aurora.Button:New({
            Text = action[1],
            Size = UDim2.new(1, -10, 0, 40),
            Position = UDim2.new(0, 5, 0, 10 + (i-1)*45),
            OnClick = function()
                action[2]()
                quickMenu:Destroy()
            end
        })
        actionBtn:SetProperty("BackgroundColor3", Color3.fromRGB(70, 75, 90))
        quickMenu:AddChild(actionBtn)
    end
    
    -- 点击外部关闭菜单
    local closeConnection
    closeConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local menuPos = quickMenu.Element.AbsolutePosition
            local menuSize = quickMenu.Element.AbsoluteSize
            
            if mousePos.X < menuPos.X or mousePos.X > menuPos.X + menuSize.X or
               mousePos.Y < menuPos.Y or mousePos.Y > menuPos.Y + menuSize.Y then
                quickMenu:Destroy()
                closeConnection:Disconnect()
            end
        end
    end)
end

-- ========== 通知系统演示 ==========
print("设置通知系统...")

-- 模拟通知函数
local function showNotification(title, message, duration)
    -- 这里可以扩展实现通知系统
    print("通知:", title, "-", message)
    
    -- 简单的文本通知
    local notification = Aurora.Label:New({
        Text = title .. ": " .. message,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 1, -50),
        TextColor = Color3.fromRGB(255, 255, 255)
    })
    notification:SetProperty("BackgroundColor3", Color3.fromRGB(60, 120, 255))
    notification:SetProperty("TextXAlignment", Enum.TextXAlignment.Center)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification.Element
    
    notification:Mount(mainWindow.Element)
    
    -- 自动隐藏通知
    task.delay(duration or 3, function()
        notification:Destroy()
    end)
end

-- 演示通知
task.delay(2, function()
    showNotification("欢迎", "Aurora UI 已成功加载！", 3)
end)

-- ========== 最终设置 ==========
print("Aurora UI 演示界面加载完成！")

-- 返回 UI 实例供外部使用
return {
    UI = ui,
    Window = mainWindow,
    
    -- 公共方法
    ShowNotification = showNotification,
    SwitchToTab = function(tabName)
        mainWindow:SwitchToTab(tabName)
    end,
    
    -- 主题控制
    SetTheme = function(themeName)
        return ui.ThemeManager:SetTheme(themeName)
    end
}
