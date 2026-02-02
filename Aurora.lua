-- Aurora UI Library
-- 现代化 Roblox UI 库
-- 特性：响应式设计、主题系统、动画引擎、模块化架构

local Aurora = {}
Aurora.__index = Aurora

-- 服务引用
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

-- 工具函数
local function deepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function createSignal()
    local connections = {}
    local signal = {}
    
    function signal:Connect(callback)
        local connection = {
            Connected = true,
            Disconnect = function(self)
                self.Connected = false
                for i, conn in ipairs(connections) do
                    if conn == self then
                        table.remove(connections, i)
                        break
                    end
                end
            end
        }
        connection.callback = callback
        table.insert(connections, connection)
        return connection
    end
    
    function signal:Fire(...)
        for _, connection in ipairs(connections) do
            if connection.Connected then
                task.spawn(connection.callback, ...)
            end
        end
    end
    
    function signal:Wait()
        local thread = coroutine.running()
        local connection
        connection = self:Connect(function(...)
            connection:Disconnect()
            coroutine.resume(thread, ...)
        end)
        return coroutine.yield()
    end
    
    return signal
end

-- 响应式系统
Aurora.Responsive = {}
Aurora.Responsive.__index = Aurora.Responsive

function Aurora.Responsive:New()
    local self = setmetatable({
        Breakpoints = {
            Mobile = 600,
            Tablet = 900,
            Desktop = 1200
        },
        CurrentBreakpoint = "Desktop",
        Listeners = {},
        Connections = {}
    }, Aurora.Responsive)
    
    self:SetupViewportListener()
    return self
end

function Aurora.Responsive:SetupViewportListener()
    local camera = workspace.CurrentCamera
    if not camera then
        camera = workspace:WaitForChild("Camera")
    end
    
    self.Connections.viewport = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self:CheckBreakpoint()
    end)
    
    self:CheckBreakpoint()
end

function Aurora.Responsive:CheckBreakpoint()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local viewportSize = camera.ViewportSize
    local width = viewportSize.X
    
    local newBreakpoint
    if width <= self.Breakpoints.Mobile then
        newBreakpoint = "Mobile"
    elseif width <= self.Breakpoints.Tablet then
        newBreakpoint = "Tablet"
    else
        newBreakpoint = "Desktop"
    end
    
    if newBreakpoint ~= self.CurrentBreakpoint then
        local oldBreakpoint = self.CurrentBreakpoint
        self.CurrentBreakpoint = newBreakpoint
        self:NotifyListeners(oldBreakpoint, newBreakpoint)
    end
end

function Aurora.Responsive:OnBreakpointChange(callback)
    local id = #self.Listeners + 1
    self.Listeners[id] = callback
    return id
end

function Aurora.Responsive:NotifyListeners(oldBreakpoint, newBreakpoint)
    for _, listener in pairs(self.Listeners) do
        task.spawn(listener, newBreakpoint, oldBreakpoint)
    end
end

function Aurora.Responsive:Destroy()
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    self.Listeners = {}
end

-- 主题系统
Aurora.ThemeManager = {}
Aurora.ThemeManager.__index = Aurora.ThemeManager

function Aurora.ThemeManager:New()
    local self = setmetatable({
        CurrentTheme = "Dark",
        Themes = {
            Dark = {
                Primary = Color3.fromRGB(25, 25, 35),
                Secondary = Color3.fromRGB(40, 40, 50),
                Accent = Color3.fromRGB(100, 150, 255),
                Text = Color3.fromRGB(240, 240, 240),
                TextMuted = Color3.fromRGB(180, 180, 180),
                Success = Color3.fromRGB(85, 200, 100),
                Warning = Color3.fromRGB(255, 180, 60),
                Error = Color3.fromRGB(255, 100, 100),
                Background = Color3.fromRGB(20, 20, 30),
                Surface = Color3.fromRGB(35, 35, 45),
                Border = Color3.fromRGB(60, 60, 70)
            },
            Light = {
                Primary = Color3.fromRGB(250, 250, 255),
                Secondary = Color3.fromRGB(230, 230, 240),
                Accent = Color3.fromRGB(80, 130, 235),
                Text = Color3.fromRGB(30, 30, 40),
                TextMuted = Color3.fromRGB(100, 100, 120),
                Success = Color3.fromRGB(65, 180, 80),
                Warning = Color3.fromRGB(235, 160, 40),
                Error = Color3.fromRGB(235, 80, 80),
                Background = Color3.fromRGB(245, 245, 250),
                Surface = Color3.fromRGB(255, 255, 255),
                Border = Color3.fromRGB(220, 220, 230)
            },
            Modern = {
                Primary = Color3.fromRGB(15, 20, 30),
                Secondary = Color3.fromRGB(30, 35, 45),
                Accent = Color3.fromRGB(120, 200, 255),
                Text = Color3.fromRGB(220, 230, 240),
                TextMuted = Color3.fromRGB(140, 150, 160),
                Success = Color3.fromRGB(100, 220, 120),
                Warning = Color3.fromRGB(255, 200, 80),
                Error = Color3.fromRGB(255, 120, 120),
                Background = Color3.fromRGB(10, 15, 25),
                Surface = Color3.fromRGB(25, 30, 40),
                Border = Color3.fromRGB(50, 55, 65)
            }
        },
        Subscribers = {},
        ThemeChanged = createSignal()
    }, Aurora.ThemeManager)
    
    return self
end

function Aurora.ThemeManager:SetTheme(themeName)
    if not self.Themes[themeName] then
        warn(`[Aurora] Theme '{themeName}' not found`)
        return false
    end
    
    local oldTheme = self.CurrentTheme
    self.CurrentTheme = themeName
    
    self.ThemeChanged:Fire(oldTheme, themeName)
    return true
end

function Aurora.ThemeManager:GetTheme()
    return deepCopy(self.Themes[self.CurrentTheme])
end

function Aurora.ThemeManager:AddTheme(name, themeData)
    self.Themes[name] = themeData
end

function Aurora.ThemeManager:OnThemeChange(callback)
    return self.ThemeChanged:Connect(callback)
end

-- 动画系统
Aurora.Animation = {}
Aurora.Animation.__index = Aurora.Animation

function Aurora.Animation:New(target, properties, options)
    local self = setmetatable({
        Target = target,
        Properties = properties,
        Options = options or {
            Duration = 0.3,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDirection = Enum.EasingDirection.Out
        },
        IsPlaying = false,
        CurrentTime = 0,
        Completed = createSignal()
    }, Aurora.Animation)
    
    return self
end

function Aurora.Animation:Play()
    if self.IsPlaying then return self end
    
    self.IsPlaying = true
    self.CurrentTime = 0
    
    local startProperties = {}
    local endProperties = {}
    
    for property, value in pairs(self.Properties) do
        startProperties[property] = self.Target[property]
        endProperties[property] = value
    end
    
    local tweenInfo = TweenInfo.new(
        self.Options.Duration,
        self.Options.EasingStyle,
        self.Options.EasingDirection,
        self.Options.RepeatCount or 0,
        self.Options.Reverses or false,
        self.Options.DelayTime or 0
    )
    
    self.Tween = TweenService:Create(self.Target, tweenInfo, endProperties)
    self.Tween:Play()
    
    if self.Options.RepeatCount and self.Options.RepeatCount > 0 then
        self.Tween.Completed:Connect(function()
            self.IsPlaying = false
            self.Completed:Fire()
        end)
    else
        task.delay(self.Options.Duration, function()
            self.IsPlaying = false
            self.Completed:Fire()
        end)
    end
    
    return self
end

function Aurora.Animation:Stop()
    if self.Tween then
        self.Tween:Cancel()
    end
    self.IsPlaying = false
    return self
end

function Aurora.Animation:OnComplete(callback)
    self.Completed:Connect(callback)
    return self
end

-- 基础组件类
Aurora.Component = {}
Aurora.Component.__index = Aurora.Component

function Aurora.Component:New(elementType, properties)
    local self = setmetatable({
        Element = Instance.new(elementType),
        Properties = properties or {},
        Children = {},
        Events = {},
        States = {},
        Animations = {},
        ReactiveProperties = {},
        ComputedValues = {},
        Destroyed = false
    }, Aurora.Component)
    
    self:ApplyProperties()
    return self
end

function Aurora.Component:ApplyProperties()
    for property, value in pairs(self.Properties) do
        if type(value) == "function" then
            self.Events[property] = self.Element[property]:Connect(value)
        else
            self.Element[property] = value
        end
    end
end

function Aurora.Component:Mount(parent)
    if self.Destroyed then
        error("Cannot mount a destroyed component")
    end
    
    if parent then
        if typeof(parent) == "Instance" then
            self.Element.Parent = parent
        elseif parent.Element then
            self.Element.Parent = parent.Element
        end
    end
    
    self:OnMount()
    return self
end

function Aurora.Component:Unmount()
    self:OnUnmount()
    return self
end

function Aurora.Component:Destroy()
    if self.Destroyed then return end
    
    self:Unmount()
    
    for _, connection in pairs(self.Events) do
        connection:Disconnect()
    end
    
    for _, animation in pairs(self.Animations) do
        animation:Stop()
    end
    
    if self.Element then
        self.Element:Destroy()
    end
    
    self.Destroyed = true
end

function Aurora.Component:OnMount()
    -- 可由子类重写
end

function Aurora.Component:OnUnmount()
    -- 可由子类重写
end

function Aurora.Component:AddChild(component)
    table.insert(self.Children, component)
    component:Mount(self)
    return self
end

function Aurora.Component:SetProperty(property, value)
    self.Element[property] = value
    return self
end

function Aurora.Component:GetProperty(property)
    return self.Element[property]
end

function Aurora.Component:Animate(properties, options)
    local animation = Aurora.Animation:New(self.Element, properties, options)
    table.insert(self.Animations, animation)
    return animation
end

-- UI 组件
Aurora.Window = setmetatable({}, {__index = Aurora.Component})

function Aurora.Window:New(config)
    local self = Aurora.Component.New(self, "Frame")
    
    self.Config = {
        Title = config.Title or "Aurora Window",
        Size = config.Size or UDim2.fromOffset(500, 400),
        Position = config.Position or UDim2.fromScale(0.5, 0.5),
        Theme = config.Theme or "Dark",
        Resizable = config.Resizable ~= false,
        Minimizable = config.Minimizable ~= false,
        Modal = config.Modal or false,
        CornerRadius = config.CornerRadius or 8
    }
    
    self:SetupWindow()
    return self
end

function Aurora.Window:SetupWindow()
    -- 窗口样式
    self:SetProperty("BackgroundColor3", Color3.fromRGB(30, 30, 40))
    self:SetProperty("BorderSizePixel", 0)
    self:SetProperty("Position", self.Config.Position)
    self:SetProperty("Size", self.Config.Size)
    self:SetProperty("ClipsDescendants", true)
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    corner.Parent = self.Element
    
    -- 阴影
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Transparency = 0.8
    shadow.Parent = self.Element
    
    -- 标题栏
    self:CreateTitleBar()
    
    -- 内容区域
    self:CreateContentArea()
    
    -- 标签页系统
    self:CreateTabSystem()
end

function Aurora.Window:CreateTitleBar()
    local titleBar = Aurora.Component.New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0
    })
    
    local titleLabel = Aurora.Component.New("TextLabel", {
        Text = self.Config.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local closeButton = Aurora.Component.New("TextButton", {
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        BorderSizePixel = 0
    })
    
    closeButton.Element.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    titleBar:AddChild(titleLabel)
    titleBar:AddChild(closeButton)
    self:AddChild(titleBar)
    
    self.TitleBar = titleBar
end

function Aurora.Window:CreateContentArea()
    local contentArea = Aurora.Component.New("Frame", {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0
    })
    
    self:AddChild(contentArea)
    self.ContentArea = contentArea
end

function Aurora.Window:CreateTabSystem()
    local tabContainer = Aurora.Component.New("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        BorderSizePixel = 0
    })
    
    local tabList = Aurora.Component.New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5)
    })
    
    tabContainer:AddChild(tabList)
    self:AddChild(tabContainer)
    
    self.TabContainer = tabContainer
    self.Tabs = {}
end

function Aurora.Window:AddTab(title, icon)
    local tabButton = Aurora.Component.New("TextButton", {
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        BorderSizePixel = 0
    })
    
    local tabContent = Aurora.Component.New("Frame", {
        Size = UDim2.new(1, 0, 1, -90),
        Position = UDim2.new(0, 0, 0, 90),
        BackgroundTransparency = 1,
        Visible = false
    })
    
    tabButton.Element.MouseButton1Click:Connect(function()
        self:SwitchToTab(title)
    end)
    
    self.TabContainer:AddChild(tabButton)
    self.ContentArea:AddChild(tabContent)
    
    local tab = {
        Button = tabButton,
        Content = tabContent,
        Title = title
    }
    
    self.Tabs[title] = tab
    
    if #self.TabContainer.Children == 1 then
        self:SwitchToTab(title)
    end
    
    return tab.Content
end

function Aurora.Window:SwitchToTab(tabName)
    for title, tab in pairs(self.Tabs) do
        tab.Content.Element.Visible = (title == tabName)
        tab.Button:SetProperty("BackgroundColor3", 
            title == tabName and Color3.fromRGB(70, 70, 80) or Color3.fromRGB(50, 50, 60))
    end
end

-- 控件组件
Aurora.Button = setmetatable({}, {__index = Aurora.Component})

function Aurora.Button:New(config)
    local self = Aurora.Component.New(self, "TextButton")
    
    self.Config = {
        Text = config.Text or "Button",
        Size = config.Size or UDim2.fromOffset(100, 40),
        OnClick = config.OnClick or function() end
    }
    
    self:SetupButton()
    return self
end

function Aurora.Button:SetupButton()
    self:SetProperty("Text", self.Config.Text)
    self:SetProperty("Size", self.Config.Size)
    self:SetProperty("BackgroundColor3", Color3.fromRGB(60, 120, 255))
    self:SetProperty("TextColor3", Color3.fromRGB(255, 255, 255))
    self:SetProperty("Font", Enum.Font.Gotham)
    self:SetProperty("TextSize", 14)
    self:SetProperty("BorderSizePixel", 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Element
    
    self.Element.MouseButton1Click:Connect(function()
        self.Config.OnClick()
    end)
    
    -- 悬停效果
    self.Element.MouseEnter:Connect(function()
        self:Animate({BackgroundColor3 = Color3.fromRGB(80, 140, 255)})
    end)
    
    self.Element.MouseLeave:Connect(function()
        self:Animate({BackgroundColor3 = Color3.fromRGB(60, 120, 255)})
    end)
end

Aurora.Label = setmetatable({}, {__index = Aurora.Component})

function Aurora.Label:New(config)
    local self = Aurora.Component.New(self, "TextLabel")
    
    self.Config = {
        Text = config.Text or "Label",
        Size = config.Size or UDim2.fromOffset(200, 40),
        TextColor = config.TextColor or Color3.fromRGB(255, 255, 255)
    }
    
    self:SetupLabel()
    return self
end

function Aurora.Label:SetupLabel()
    self:SetProperty("Text", self.Config.Text)
    self:SetProperty("Size", self.Config.Size)
    self:SetProperty("TextColor3", self.Config.TextColor)
    self:SetProperty("Font", Enum.Font.Gotham)
    self:SetProperty("TextSize", 14)
    self:SetProperty("BackgroundTransparency", 1)
    self:SetProperty("TextXAlignment", Enum.TextXAlignment.Left)
end

Aurora.Slider = setmetatable({}, {__index = Aurora.Component})

function Aurora.Slider:New(config)
    local self = Aurora.Component.New(self, "Frame")
    
    self.Config = {
        Text = config.Text or "Slider",
        Min = config.Min or 0,
        Max = config.Max or 100,
        Default = config.Default or 50,
        OnChange = config.OnChange or function() end
    }
    
    self.Value = self.Config.Default
    self:SetupSlider()
    return self
end

function Aurora.Slider:SetupSlider()
    self:SetProperty("Size", UDim2.fromOffset(200, 60))
    self:SetProperty("BackgroundTransparency", 1)
    
    local label = Aurora.Label:New({
        Text = self.Config.Text .. ": " .. self.Value,
        Size = UDim2.new(1, 0, 0, 20)
    })
    
    local track = Aurora.Component.New("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        BorderSizePixel = 0
    })
    
    local fill = Aurora.Component.New("Frame", {
        Size = UDim2.new((self.Value - self.Config.Min) / (self.Config.Max - self.Config.Min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(60, 120, 255),
        BorderSizePixel = 0
    })
    
    local thumb = Aurora.Component.New("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new((self.Value - self.Config.Min) / (self.Config.Max - self.Config.Min), -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = thumb.Element
    
    local function updateValue(value)
        self.Value = math.clamp(value, self.Config.Min, self.Config.Max)
        local ratio = (self.Value - self.Config.Min) / (self.Config.Max - self.Config.Min)
        
        fill:SetProperty("Size", UDim2.new(ratio, 0, 1, 0))
        thumb:SetProperty("Position", UDim2.new(ratio, -8, 0.5, -8))
        label:SetProperty("Text", self.Config.Text .. ": " .. math.floor(self.Value))
        
        self.Config.OnChange(self.Value)
    end
    
    local dragging = false
    track.Element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mousePosition = input.Position.X
            local trackPosition = track.Element.AbsolutePosition.X
            local trackWidth = track.Element.AbsoluteSize.X
            
            local ratio = (mousePosition - trackPosition) / trackWidth
            updateValue(self.Config.Min + ratio * (self.Config.Max - self.Config.Min))
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePosition = input.Position.X
            local trackPosition = track.Element.AbsolutePosition.X
            local trackWidth = track.Element.AbsoluteSize.X
            
            local ratio = math.clamp((mousePosition - trackPosition) / trackWidth, 0, 1)
            updateValue(self.Config.Min + ratio * (self.Config.Max - self.Config.Min))
        end
    end)
    
    track:AddChild(fill)
    track:AddChild(thumb)
    self:AddChild(label)
    self:AddChild(track)
end

-- 主 Aurora 类
function Aurora:Init(config)
    local self = setmetatable({
        Config = {
            DPIScale = 1,
            CornerRadius = 8,
            AnimationSpeed = 0.15,
            Theme = "Dark",
            Language = "en"
        },
        Components = {},
        Windows = {},
        ThemeManager = Aurora.ThemeManager:New(),
        Responsive = Aurora.Responsive:New(),
        Initialized = true
    }, Aurora)
    
    self:MergeConfig(config)
    
    -- 设置全局主题
    self.ThemeManager:SetTheme(self.Config.Theme)
    
    return self
end

function Aurora:MergeConfig(config)
    if not config then return end
    
    for key, value in pairs(config) do
        if self.Config[key] ~= nil then
            if type(value) == "table" and type(self.Config[key]) == "table" then
                for k, v in pairs(value) do
                    self.Config[key][k] = v
                end
            else
                self.Config[key] = value
            end
        end
    end
end

function Aurora:CreateWindow(config)
    local windowConfig = deepCopy(self.Config)
    for k, v in pairs(config or {}) do
        windowConfig[k] = v
    end
    
    local window = Aurora.Window:New(windowConfig)
    table.insert(self.Windows, window)
    
    return window
end

function Aurora:CreateButton(config)
    return Aurora.Button:New(config)
end

function Aurora:CreateLabel(config)
    return Aurora.Label:New(config)
end

function Aurora:CreateSlider(config)
    return Aurora.Slider:New(config)
end

function Aurora:Destroy()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    
    self.ThemeManager = nil
    self.Responsive:Destroy()
    self.Initialized = false
end

-- 导出全局访问
getgenv().Aurora = Aurora

return Aurora