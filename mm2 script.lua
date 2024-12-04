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