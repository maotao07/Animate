--//Client Definitions
local Player = game.Players.LocalPlayer

repeat wait() until Player:FindFirstChild("Loaded")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart",10)
local Animator = Humanoid.Animator
local Camera = workspace.CurrentCamera
--//Service Definitions
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local runser = game:GetService("RunService")
--//Folder Definitions
local Animations = RS:WaitForChild("Animations",10)
local Effects = RS:WaitForChild("Effects",10)
local dustAttach = RootPart:WaitForChild("DustAttachment",25)
local DustParticle = dustAttach:WaitForChild("DustEffect",205)
--//Animation Loaders
local Running = Animations:WaitForChild("Sprint")
--local StaminaBoost = playerData["Swiftness"]
local animations = {}
--// super super basic example
local playAnim = RS.Remotes.PlayAnimation
playAnim.OnClientEvent:Connect(function(animation)
	local animationobj = animations[animation.Name]
	if animationobj == nil then
		animations[animation.Name] = Animator:LoadAnimation(animation)
		animationobj = animations[animation.Name]
	end
	animationobj:Play()
end)
local dJump = Animator:LoadAnimation(Animations.DoubleJump)
Running = Animator:LoadAnimation(Running)
local get = RS.Requests.Get
local RUN_SPEED = 26 + (1+(get:InvokeServer("Agility"))/10)
if not RootPart:FindFirstChild("BGM") then
	local bgm = Instance.new("Sound")
	bgm.Parent = RootPart
	bgm.Name = "BGM"
	bgm.Looped = true
	bgm.RollOffMode = Enum.RollOffMode.Linear
end
--//etc...
local dJumpCd = false
local jumpUsage = 1
UIS.InputBegan:Connect(function(key,gpe)
	if key.KeyCode == Enum.KeyCode.Space and not gpe then
		if RootPart and Humanoid then
			if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
				if jumpUsage >= 1 and not dJumpCd then
					local agilAmount = get:InvokeServer("Agility")
					if agilAmount < 200 then return end
					dJumpCd = true
					jumpUsage-=1
					dJump:Play()
					Humanoid:ChangeState(Enum.HumanoidStateType.Jumping,true)
					Humanoid.StateChanged:Connect(function(old,new)
						if new == Enum.HumanoidStateType.Landed then
							jumpUsage = 1
						end
					end)
					task.wait(3)
					dJumpCd = false
				end
			end
		end
	end
end)
local lastRan = 0
local isRunning = false
local SpeedBuff = Character:WaitForChild("SpeedBuff",10)
local shaketimer = 0
local range = 0.0010
local speed = 0.2
local effects = Character:WaitForChild("Effects",10)
Humanoid.StateChanged:Connect(function(p17, p18)
	if p18 == Enum.HumanoidStateType.Jumping and isRunning then
		Running:AdjustSpeed(0.3);
	end;
	if p18 == Enum.HumanoidStateType.Freefall and isRunning then
		Running:AdjustSpeed(0.3);
	end;
	if p18 == Enum.HumanoidStateType.Landed and isRunning then
		Running:AdjustSpeed(1);
	end;
end);
local function zoom(amount,timen)
	Tween:Create(Camera,TweenInfo.new(timen),{FieldOfView=amount}):Play()
end
local function rayUnder()
	local rayp = RaycastParams.new()
	rayp.FilterDescendantsInstances = {Character}
	rayp.FilterType = Enum.RaycastFilterType.Blacklist
	local ray = workspace:Raycast(RootPart.Position,RootPart.CFrame.upVector*-7,rayp)
	if ray then
		return ray
	end
end
function runscreen()
	if isRunning == false then return end;
	shaketimer = shaketimer + speed 
	workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(math.cos(shaketimer*2)*range,math.sin(shaketimer+math.pi/4)*range,0)
	wait()
end
runser.Heartbeat:Connect(runscreen); 
--//Controller
effects.ChildAdded:Connect(function(child)
	if child.Name == "Attacking" and Humanoid.WalkSpeed > 4 then
		Humanoid.WalkSpeed = 6
		Humanoid.JumpHeight = 0
	elseif child.Name == "Stunned" or child.Name == "Parrying" and not effects:FindFirstChild("Frozen") then
		Humanoid.WalkSpeed = 2
		Humanoid.JumpHeight = 0
	elseif child.Name == "Frozen" then
		Humanoid.WalkSpeed = 0
		Humanoid.JumpHeight = 0
		if isRunning then
			isRunning = false
			lastRan = 0
			zoom(70,.3)
			Running:Stop()
		end
	elseif (child.Name == "Stunned" or child.Name == "CantRun" or child.Name == "Blocking" or child.Name == "Frozen") and isRunning  then
		isRunning = false
		if not effects:FindFirstChild("Attacking") and not effects:FindFirstChild("Stunned") then
			Humanoid.WalkSpeed = 16
		end
		if child.Name == "Blocking" then
			Humanoid.WalkSpeed = 3
			
		end
		
		lastRan = 0
		zoom(70,.3)
		Running:Stop()
	end
end)
game.ReplicatedStorage.Remotes.ApplyInjury.OnClientEvent:Connect(function(injury)
	print("got v - " .. injury)
	if injury == "Blind" then
		coroutine.resume(coroutine.create(function()
			while wait(1) do 
				game.Lighting.ColorCorrection.Brightness = -99999998430674944
				game.Lighting.ColorCorrection.Contrast = 200000
				game.Lighting.ColorCorrection.Saturation = -1999999991808
			end
		end))
	elseif injury == "BrokenLeg" then
		local ntv = Instance.new("IntValue")
		ntv.Name = "BrokenLeg"
		ntv.Parent = Character
	end
end)
effects.ChildRemoved:Connect(function(child)
	if child.Name == "Attacking" and not effects:FindFirstChild("Stunned") and not effects:FindFirstChild("Attacking") and Character.Humanoid.WalkSpeed ~= 0 then
		Humanoid.WalkSpeed = 16
		Humanoid.JumpHeight = 7.2
	elseif (child.Name == "Stunned" or child.Name == "Parrying") and not effects:FindFirstChild("Stunned") and not effects:FindFirstChild("Attacking") and not effects:FindFirstChild("Parrying")  then
		Humanoid.WalkSpeed = 16
		Humanoid.JumpHeight = 7.2
	elseif child.Name == "Frozen" and not effects:FindFirstChild("Stunned") and not effects:FindFirstChild("Attacking") then
		Humanoid.WalkSpeed = 16
		Humanoid.JumpHeight = 7.2
	end
end)
local function stopAll()
	local cantRun = Instance.new("BoolValue",Character.Effects)
	local stunned=  Instance.new("BoolValue",Character.Effects)
	cantRun.Name = "CantRun"
	stunned.Name = "Stunned"
	Humanoid.WalkSpeed = 0
	Humanoid.JumpHeight = 0
end
local function unStopAll()
	if Character.Effects:FindFirstChild("CantRun") then 
		Character.Effects["CantRun"]:Destroy()
	end
	if Character.Effects:FindFirstChild("Stunned") then 
		Character.Effects["Stunned"]:Destroy()
	end
	Humanoid.WalkSpeed = 16
	Humanoid.JumpHeight = 7.2
end
local function updateRun()
	local agilAmount = get:InvokeServer("Agility")/10
	if agilAmount >= 12 then 
		agilAmount = 12
	end
	RUN_SPEED = 26 + agilAmount
	
end
UIS.InputBegan:Connect(function(key,gpe)
	if key.KeyCode == Enum.KeyCode.W and not gpe then
		if lastRan ~= 0 and (tick()-lastRan)<=.6 and not isRunning and not Character.Effects:FindFirstChild("Attacking") and not Character.Effects:FindFirstChild("Stunned") and not Character.Effects:FindFirstChild("Parrying") and not Character.Effects:FindFirstChild("Ragdoll") and not Character.Effects:FindFirstChild("Carried") and not Character.Effects:FindFirstChild("Charging") then
			if Character:FindFirstChild("BrokenLeg") then return end 
			Running:Play()
			updateRun()
			Humanoid.WalkSpeed = RUN_SPEED  * SpeedBuff.Value
			Humanoid.JumpHeight = 7.2
			Humanoid.JumpPower = 50
			if Humanoid.Health <= (Humanoid.MaxHealth/3) then
				Humanoid.WalkSpeed = 20
			end
			local rayResult = rayUnder()
			
			if rayResult then
				DustParticle.Color =ColorSequence.new({ColorSequenceKeypoint.new(0,rayResult.Instance.Color);ColorSequenceKeypoint.new(1,rayResult.Instance.Color)}) 
			end
			DustParticle:Emit(math.random(5,10))
			zoom(62,.3)
			isRunning = true
		else
			lastRan = tick()
		end
	end
end)

UIS.InputEnded:Connect(function(key,gpe)
	if key.KeyCode == Enum.KeyCode.W and not gpe then
		if isRunning then
			isRunning = false
			Humanoid.WalkSpeed = 16
			lastRan = 0
			zoom(70,.3)
			Running:Stop()
		end
	end
end)
