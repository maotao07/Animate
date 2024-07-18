local plr = game.Players.LocalPlayer
local plrgui = plr:WaitForChild("PlayerGui")
local ui = plrgui:WaitForChild("UI")
local pdenabled = ui:WaitForChild("PDFrame")
wait(5)
print("Starting quest!")
for _,v in ipairs(workspace.Spawns:GetDescendants()) do if v:IsA("BillboardGui") then v.Enabled = false end end
for _,v in ipairs(workspace.NPCs:GetDescendants()) do if v:IsA("BillboardGui") then v.Enabled = false end end
game.Lighting.ColorCorrection.Saturation = .2
game.Lighting.ColorCorrection.TintColor = Color3.fromRGB(255,255,255)

local pdVal = game.ReplicatedStorage.PD
if pdVal.Value == true then
	pdenabled.Visible = true
end
local MusicObject = game.Workspace:FindFirstChild("ClientMusic")
if not MusicObject then
	MusicObject = Instance.new("Sound")
	MusicObject.Name = "ClientMusic"
	MusicObject.Parent = game.Workspace
	MusicObject.Looped = true
	MusicObject.MaxDistance = 10000
	MusicObject.Volume = 0.5
	MusicObject.PlaybackSpeed = 1
end
local cmdCore = require(script:WaitForChild("CommandCore",100))
plr.Chatted:Connect(function(Message)
	cmdCore:ParseCommand(Message)
end)
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid",10)
local shaking = true
local camera = workspace.CurrentCamera
local function Shake(duration,size)
	shaking = true
	coroutine.resume(coroutine.create(function()
		while shaking do
			wait()
			local x,y,z = math.random(-(1*size),(1*size))/100,math.random(-(1*size),(1*size))/100,math.random(-(1*size),(1*size))/100
			hum.CameraOffset = Vector3.new(x,y,z)
		end
	end))
	if duration ~= -1 then
		wait(duration)
		shaking = false
		wait(.2)
		hum.CameraOffset=Vector3.new(0,0,0)
	end	
end
local RunService = game:GetService("RunService")
local function PlayMusic(VID,Opt)
	if Opt == "Music" then
		--		print("Got music")
		local Volume = 0.5
		local Object = game.Workspace:FindFirstChild("ClientMusic")
		if (not VID) then return end	
		print("Playing Song.")
		if Object.Volume ~= 0 then game.TweenService:Create(Object, TweenInfo.new(3), {Volume = 0}):Play() end
		repeat RunService.Heartbeat:Wait() until Object.Volume == 0
		Object:Stop()
		Object.SoundId = "rbxassetid://"..VID
		Object:Play()
		Object.PlaybackSpeed = 1
		Object.Volume = Volume
		game.TweenService:Create(Object, TweenInfo.new(1.5), {Volume = Volume}):Play()
	elseif Opt == "Volume" then
		--		print("Got volume")
		if workspace:FindFirstChild("ClientMusic") then
			workspace["ClientMusic"].Volume = VID
		end
	end
end
local connection
local function cameraSpin(duration)
	coroutine.resume(coroutine.create(function()
		connection = RunService.RenderStepped:Connect(function()
			camera.CFrame = camera.CFrame* CFrame.Angles(0,0.1,0)
	--		plr.CameraMaxZoomDistance = 16
		end)
	end))
	wait(duration)
	if connection then
		connection:Disconnect()
	end
end

local function Tethered(duration)
	coroutine.resume(coroutine.create(function() Shake(duration,100) end))
	game.TweenService:Create(game.Lighting.ColorCorrection,TweenInfo.new(duration),{TintColor = Color3.fromRGB(255,0,0), Saturation = -10}):Play()

	game.ReplicatedStorage.Sounds.Tethered:Play()
	wait(duration+1)
	game.ReplicatedStorage.Sounds.Tethered:Stop()
	game.Lighting.ColorCorrection.TintColor = Color3.fromRGB(255,255,255)
	game.Lighting.ColorCorrection.Saturation = 0.2
end

game.ReplicatedStorage.Remotes.PlayMusic.OnClientEvent:Connect(function(VID,Opt)
	PlayMusic(VID,Opt)
end)
game.ReplicatedStorage.Remotes.CameraShake.OnClientEvent:Connect(function(duration,size)
	Shake(duration,size)
end)

game.ReplicatedStorage.Remotes.ScreenSpin.OnClientEvent:Connect(function(duration)
	cameraSpin(duration)
end)

game.ReplicatedStorage.Remotes.Tethered.OnClientEvent:Connect(function(duration)
	Tethered(duration)
end)


game:GetService("UserInputService").InputBegan:Connect(function(key,gpe)
	if gpe then return end	
end)
