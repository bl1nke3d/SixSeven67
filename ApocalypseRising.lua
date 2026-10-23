local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local HP_COLOR   = Color3.fromRGB(127, 219, 30)
local BOX_COLOR  = Color3.fromRGB(166, 166, 166)
local NAME_COLOR = Color3.fromRGB(255, 255, 255) 
local DIST_COLOR = Color3.fromRGB(200, 210, 200)

local config = {
     Esp = false,
     Highlight = false,
     Fullbright = false,
     NoFog = false
}

local origLighting = {
	Brightness     = Lighting.Brightness,
	ClockTime      = Lighting.ClockTime,
	FogEnd         = Lighting.FogEnd,
	FogStart       = Lighting.FogStart,
	GlobalShadows  = Lighting.GlobalShadows,
	Ambient        = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
  Title = "Apocalypse Rising 2",
  SubTitle = "by 67",
  TabWidth = 160,
  Size = UDim2.fromOffset(580, 460),
  Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
  Theme = "Dark",
  MinimizeKey = Enum.KeyCode.Home -- Used when theres no MinimizeKeybind
})

local Tabs = {
  Visuals = Window:AddTab({ Title = "Visuals", Icon = "" });
}

Window:SelectTab(1)






local function CreateEspIsrael(char, displayName)
	local root = char:WaitForChild("HumanoidRootPart", 5)
	local hum = char:WaitForChild("Humanoid", 5)
    local camera = workspace.CurrentCamera
	if not root or not hum then return end
	if root:FindFirstChild("IsraelEsp") then return end

    if not displayName then
        displayName = hum.DisplayName
    end

    local currentTime = tick()

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "IsraelEsp"
	billboard:SetAttribute("IsraelEsp", true)
	billboard.Adornee = root
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = math.huge
	billboard.ResetOnSpawn = false
	billboard.Size = UDim2.new(5, 0, 6.5, 0)
	billboard.Parent = root

	local obvodka = Instance.new("Frame")
	obvodka.Name = "obvodka"
	obvodka.LayoutOrder = 1
	obvodka.BackgroundTransparency = 1
	obvodka.Position = UDim2.new(0, 0, 0.07, 0)
	obvodka.Size = UDim2.new(1, 0, 0.93, 0)
	obvodka.Parent = billboard

	local obvodkastroke = Instance.new("UIStroke")
	obvodkastroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	obvodkastroke.Color = BOX_COLOR
	obvodkastroke.Thickness = 1
	obvodkastroke.Parent = obvodka

	local HealthThing = Instance.new("Frame")
	HealthThing.Name = "Health"
	HealthThing.LayoutOrder = 2
	HealthThing.BorderSizePixel = 0
	HealthThing.BackgroundColor3 = HP_COLOR
	HealthThing.AnchorPoint = Vector2.new(0, 1)
	HealthThing.Position = UDim2.new(0, 0, 1, 0)
	HealthThing.Size = UDim2.new(0.04, 0, 1, 0)
	HealthThing.Parent = obvodka

	local textGui = Instance.new("BillboardGui")
	textGui.Name = "IsraelEspText"
	textGui.Adornee = root
	textGui.AlwaysOnTop = true
	textGui.MaxDistance = math.huge
	textGui.ResetOnSpawn = false
	textGui.Size = UDim2.fromOffset(220, 44)
	textGui.StudsOffsetWorldSpace = Vector3.new(0, 3.9, 0)
	textGui.Parent = root

	local nametext = Instance.new("TextLabel")
	nametext.BackgroundTransparency = 1
	nametext.AnchorPoint = Vector2.new(0.5, 1)
	nametext.Position = UDim2.fromScale(0.5, 0.55)
	nametext.Size = UDim2.fromScale(1, 0.5)
	nametext.Font = Enum.Font.GothamMedium
	nametext.TextSize = 15
	nametext.TextColor3 = NAME_COLOR
	nametext.TextStrokeTransparency = 0.3
	nametext.Text = displayName or char.Name
	nametext.Parent = textGui

	local distLabel = Instance.new("TextLabel")
	distLabel.BackgroundTransparency = 1
	distLabel.AnchorPoint = Vector2.new(0.5, 0)
	distLabel.Position = UDim2.fromScale(0.5, 0.55)
	distLabel.Size = UDim2.fromScale(1, 0.45)
	distLabel.Font = Enum.Font.Gotham
	distLabel.TextSize = 13
	distLabel.TextColor3 = DIST_COLOR
	distLabel.TextStrokeTransparency = 0.5
	distLabel.Parent = textGui

    print("Time spent: "..tick() - currentTime.."s")


    if not billboard or not char:FindFirstChildOfClass("Humanoid") then
        return
    end
    local function updateHealth()
        if not hum then
            return
        end
		local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
		HealthThing.Size = UDim2.new(0.04, 0, ratio, 0)
	end
	updateHealth()

	local conns = {}
	table.insert(conns, hum.HealthChanged:Connect(updateHealth))
    table.insert(conns, RunService.RenderStepped:Connect(function()
		distLabel.Text = string.format("[%d]", (camera.CFrame.Position - root.Position).Magnitude)
	end))

    local function cleanup()
		for _, c in ipairs(conns) do c:Disconnect() end
		billboard:Destroy()
		textGui:Destroy()
	end
	table.insert(conns, hum.Died:Connect(cleanup))
	table.insert(conns, char.AncestryChanged:Connect(function(_, parent)
		if not parent then cleanup() end
	end))
end

local function CreateHighlightIsrael(char)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    local camera = workspace.CurrentCamera
    local highlight = Instance.new("Highlight", char)
    highlight.Adornee = root.Parent
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.FillColor = Color3.fromRGB(166, 255, 128)
    highlight.FillTransparency = .3
    highlight.Name = "PuzoHighlight"
    highlight:SetAttribute("IsraelHighlight", true)
    highlight.OutlineTransparency = 1
end

local lp = Players.LocalPlayer

local function ChangeFov(fov: number)
	workspace.CurrentCamera.FieldOfView = fov
end

local active = {}
local highlighted = {}

local function applyHighlight(char)
	if highlighted[char] then return end
	CreateHighlightIsrael(char) 
	highlighted[char] = true
end

local function removeHighlight(char)
	local hl = char:FindFirstChild("PuzoHighlight")
	if hl then hl:Destroy() end
	highlighted[char] = nil
end

local function applyEsp(char, player)
	if active[char] then return end
	local data = CreateEspIsrael(char, player.DisplayName)
	if not data then return end
	active[char] = data
end
local ESP_NAMES = { "IsraelEsp", "IsraelEspText", "IsraelEspBottom" }

local function removeEsp(char)
	local data = active[char]
	if data and data.cleanup then
		pcall(data.cleanup)
	end
	active[char] = nil

	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		for _, name in ipairs(ESP_NAMES) do
			local gui = root:FindFirstChild(name)
			if gui then gui:Destroy() end
		end
	end
end

local function onChar(char, player)
	if config.Highlight then applyHighlight(char) end
	if config.Esp then applyEsp(char, player) end
    if config.NoFog and lp.PlayerGui.DamageCorners:FindFirstChild("FogBlock") then lp.PlayerGui.DamageCorners.FogBlock:Destroy() end

	char.AncestryChanged:Connect(function(_, parent)
		if not parent then
			removeEsp(char)
			highlighted[char] = nil
		end
	end)
end

local function track(player)
	if player == lp then return end
	if player.Character then task.spawn(onChar, player.Character, player) end
	player.CharacterAdded:Connect(function(char)
		onChar(char, player)
	end)
end

local function refreshAll()
	for _, p in ipairs(Players:GetPlayers()) do
		local char = p.Character
		if p ~= lp and char then
			if config.Esp then applyEsp(char, p) else removeEsp(char) end
			if config.Highlight then applyHighlight(char) else removeHighlight(char) end
		end
	end
end

for _, p in ipairs(Players:GetPlayers()) do track(p) end
Players.PlayerAdded:Connect(track)

local acc = 0
RunService.Heartbeat:Connect(function(dt)
	if not config.Esp then return end
	acc += dt
	if acc < 0.1 then return end
	acc = 0

	local camPos = workspace.CurrentCamera.CFrame.Position
	for char, d in pairs(active) do
		if d.root.Parent then
			local text = string.format("[%dm]", (camPos - d.root.Position).Magnitude)
			if d.distLabel.Text ~= text then d.distLabel.Text = text end

			local tool = char:FindFirstChildOfClass("Tool")
			local w = tool and tool.Name or "NONE"
			if d.weaponText.Text ~= w then d.weaponText.Text = w end
		end
	end
end)

local function setNoFog(val:boolean)
    if val == true then
        Lighting.FogEnd     = 100000
        game.Lighting.FogStart = 0
        if game.Lighting:FindFirstChild("Atmosphere") then
            game.Lighting.Atmosphere.Density = 0
            game.Lighting.Atmosphere.Haze = 0
        end
    else
        Lighting.FogEnd     = origLighting.FogEnd
    end 
end

local function setFullbright(val:boolean)
    if val == true then
        Lighting.Brightness     = 2
        -- Lighting.ClockTime      = 14
        Lighting.GlobalShadows  = false
        Lighting.Ambient        = Color3.fromRGB(255, 255, 255)
	    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness     = origLighting.Brightness
        -- Lighting.ClockTime      = origLighting.ClockTime
        Lighting.GlobalShadows  = origLighting.GlobalShadows
        Lighting.Ambient        = origLighting.Ambient
	    Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
    end
end

local EspToggle = Tabs.Visuals:AddToggle("ESP", { Title = "ESP", Default = false })
EspToggle:OnChanged(function(val)
	config.Esp = val 
	refreshAll() 
end)

local HlToggle = Tabs.Visuals:AddToggle("Highlight", { Title = "Highlight", Default = false })
HlToggle:OnChanged(function(val)
	config.Highlight = val
	refreshAll()
end)

local FullbrightToggle = Tabs.Visuals:AddToggle("Fullbright", { Title = "Fullbright", Default = false })
FullbrightToggle:OnChanged(function(val)
    config.Fullbright = val
    setFullbright(val)
end)
-- local NoFogToggle = Tabs.Visuals:AddToggle("No Fog", { Title = "No Fog", Default = false })
-- NoFogToggle:OnChanged(function(val)
--     setNoFog(val)
--     if lp.PlayerGui.DamageCorners:FindFirstChild("FogBlock") then lp.PlayerGui.DamageCorners.FogBlock:Destroy() end
-- end)

local sixseven = RunService.RenderStepped:Connect(function(dt)
    if config.Fullbright == true then
        setFullbright(true)
    end

    -- if config.NoFog == true then
    --     setNoFog(true)
    -- end
end)

-- local Slider = Tabs.Visuals:AddSlider("Fov", {
--         Title = "Fov",
--         Description = "677777777777777777",
--         Default = 70,
--         Min = 40,
--         Max = 120,
--         Rounding = 0,
--         Callback = function(Value)
--             ChangeFov(Value)
--             -- print("Slider was changed:", Value)
--         end
--     })

--     -- Slider:OnChanged(function(Value)
--     --     print("Slider changed:", Value)
--     -- end)

--     Slider:SetValue(workspace.CurrentCamera.FieldOfView)