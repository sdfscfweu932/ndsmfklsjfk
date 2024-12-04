local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Hub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "MM2 Script Hub",
   LoadingSubtitle = "by CarLoOoOo",
   Theme = "Light", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "MM2 Hub | Key",
      Subtitle = "Key System",
      Note = "Complete the linkvertise to get the perma key", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/BrsbnBem"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Player", nil) -- Title, Image
local MainSection =  MainTab:CreateSection("Jump and Speed Boost")

local Slider = MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Jumpboost",
   Range = {50, 400},
   Increment = 1,
   Suffix = "Jump",
   CurrentValue = 50,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
           game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Value)
   end,
})

local JumpSection =  MainTab:CreateSection("Infinite Jump")

local Button = MainTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
  local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
local InfiniteJump = CreateButton("Infinite Jump: On", StuffFrame)
InfiniteJump.Position = UDim2.new(0,10,0,130)
InfiniteJump.Size = UDim2.new(0,150,0,30)
InfiniteJump.MouseButton1Click:connect(function()
	local state = InfiniteJump.Text:sub(string.len("Infinite Jump: ") + 1) --too lazy to count lol
	local new = state == "Off" and "On" or state == "On" and "Off"
	InfiniteJumpEnabled = new == "On"
	InfiniteJump.Text = "Infinite Jump: " .. new
end)
   end,
})

local ClipSection =  MainTab:CreateSection("Noclip")

local Button = MainTab:CreateButton({
   Name = "Noclip",
   Callback = function()
   local Noclip = nil
local Clip = nil

function noclip()
	Clip = false
	local function Nocl()
		if Clip == false and game.Players.LocalPlayer.Character ~= nil then
			for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
					v.CanCollide = false
				end
			end
		end
		wait(0.21) -- basic optimization
	end
	Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end

function clip()
	if Noclip then Noclip:Disconnect() end
	Clip = true
end

noclip() -- to toggle noclip() and clip()
   end,
})

local MainTab = Window:CreateTab("Visuals", nil) 
local VisualsSection =  MainTab:CreateSection("ESP")

local Button = MainTab:CreateButton({
   Name = "ESP All Roles",
   Callback = function()
   --[[
    Credits to Kiriot22 for the Role getter <3
        - poorly coded by FeIix <3
]]

-- > Declarations < --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local roles

-- > Functions <--

function CreateHighlight() -- make any new highlights for new players
	for i, v in pairs(Players:GetChildren()) do
		if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight") then
			Instance.new("Highlight", v.Character)           
		end
	end
end

function UpdateHighlights() -- Get Current Role Colors (messy)
	for _, v in pairs(Players:GetChildren()) do
		if v ~= LP and v.Character and v.Character:FindFirstChild("Highlight") then
			Highlight = v.Character:FindFirstChild("Highlight")
			if v.Name == Sheriff and IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(0, 0, 225)
			elseif v.Name == Murder and IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(225, 0, 0)
			elseif v.Name == Hero and IsAlive(v) and not IsAlive(game.Players[Sheriff]) then
				Highlight.FillColor = Color3.fromRGB(255, 250, 0)
			else
				Highlight.FillColor = Color3.fromRGB(0, 225, 0)
			end
		end
	end
end	

function IsAlive(Player) -- Simple sexy function
	for i, v in pairs(roles) do
		if Player.Name == i then
			if not v.Killed and not v.Dead then
				return true
			else
				return false
			end
		end
	end
end


-- > Loops < --

RunService.RenderStepped:connect(function()
	roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
	for i, v in pairs(roles) do
		if v.Role == "Murderer" then
			Murder = i
		elseif v.Role == 'Sheriff'then
			Sheriff = i
		elseif v.Role == 'Hero'then
			Hero = i
		end
	end
	CreateHighlight()
	UpdateHighlights()
end)
   end,
})

local MainTab = Window:CreateTab("Auto Farm", nil) 
local FarmSection =  MainTab:CreateSection("Candy Farm")

local Button = MainTab:CreateButton({
   Name = "Candy Farm 2024",
   Callback = function()
  local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Variable to track if teleportation is enabled
local teleportEnabled = false

-- Function to find the CoinContainer
local function findCoinContainer()
    for _, child in pairs(workspace:GetChildren()) do
        local coinContainer = child:FindFirstChild("CoinContainer")
        if coinContainer then
            return coinContainer
        end
    end
    return nil
end

-- Function to find the nearest coin within a certain radius
local function findNearestCoin(radius)
    local coinContainer = findCoinContainer()
    if not coinContainer then
        print("CoinContainer not found")
        return nil
    end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local nearestCoin = nil
    local nearestDistance = radius
    for _, coin in pairs(coinContainer:GetChildren()) do
        local distance = (coin.Position - humanoidRootPart.Position).Magnitude
        if distance < nearestDistance then
            nearestCoin = coin
            nearestDistance = distance
        end
    end
    return nearestCoin
end

-- Function to teleport to a coin
local function teleportToCoin(coin)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = coin.CFrame})
    tween:Play()
    return tween
end

-- Variable to track if a teleport is in progress
local isTeleporting = false

-- Function to teleport to a nearby coin or a random coin
local function teleportToNearbyOrRandomCoin()
    if not teleportEnabled or isTeleporting then return end
    local nearbyRadius = 50 -- Adjust this value to change the "nearby" distance
    local nearbyCoin = findNearestCoin(nearbyRadius)
    if nearbyCoin then
        print("Teleporting to nearby coin")
        isTeleporting = true
        local tween = teleportToCoin(nearbyCoin)
        tween.Completed:Wait()
        isTeleporting = false
    else
        local coinContainer = findCoinContainer()
        if not coinContainer then
            print("CoinContainer not found")
            return
        end
        local coins = coinContainer:GetChildren()
        if #coins == 0 then
            print("No coins found")
            return
        end
        local randomCoin = coins[math.random(1, #coins)]
        print("Teleporting to random coin")
        isTeleporting = true
        local tween = teleportToCoin(randomCoin)
        tween.Completed:Wait()
        isTeleporting = false
    end
end

-- Function to create GUI
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MM2CandyAutoFarmGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player.PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true
    Frame.Selectable = true

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "MM2 Candy Auto Farm"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 18
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = Frame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ToggleButton.Text = "Teleport OFF"
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.Parent = Frame

    -- Function to toggle teleportation
    local function toggleTeleport()
        teleportEnabled = not teleportEnabled
        if teleportEnabled then
            ToggleButton.Text = "Teleport ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            ToggleButton.Text = "Teleport OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    end

    -- Connect the toggle button
    ToggleButton.MouseButton1Click:Connect(toggleTeleport)

    return ScreenGui
end

-- Create initial GUI
local gui = createGUI()

-- Function to handle character spawning
local function onCharacterAdded(newCharacter)
    character = newCharacter
    -- Check if GUI exists, if not, recreate it
    if not player.PlayerGui:FindFirstChild("MM2CandyAutoFarmGUI") then
        gui = createGUI()
    end
end

-- Connect to current and future characters
player.CharacterAdded:Connect(onCharacterAdded)

-- Start the continuous teleportation loop
RunService.Heartbeat:Connect(function()
    if teleportEnabled and character and character:FindFirstChild("HumanoidRootPart") then
        teleportToNearbyOrRandomCoin()
    end
end)

print("MM2 Candy Auto Farm script with persistent GUI and fixed toggle loaded.")
   end,
})

local MainTab = Window:CreateTab("Settings", nil) -- Title, Image
local IYSection = MainTab:CreateSection("Infinite Yeild")

local Button = MainTab:CreateButton({
   Name = "Infinte Yeild",
   Callback = function()
  loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})
