local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid",10)
local animator = hum["Animator"]
local uis = game:GetService("UserInputService")
local rs = game:GetService("ReplicatedStorage")
local remotes = rs["Remotes"]
local combatRemote = remotes["Combat"]
local animations = rs["Animations"]
local carryTrack = animator:LoadAnimation(animations.Carry)
local effects = char:WaitForChild("Effects",100)
--local shankTrack = animator:LoadAnimation(animations.ShankGrip)
local gripTrack = animator:LoadAnimation(animations.Grip)
--local carryTrack = animator:LoadAnimation(animations.Carry)
local parryTrack = animator:LoadAnimation(animations.Block)
local weaveTrack = animator:LoadAnimation(animations.Weave)
local Combo = 1
local LastBlocked = tick()
local LastHit = tick()
local CanPunch = true
local isBlocking = false
local carrying = false
local runningPocket = false
local carryingPlayer = ""
local gripping = false
local canGrip = false
local auraCD = false
local isAura = false
local shiftLock = false
local parryCD = false
local effects = char:WaitForChild("Effects",5)
local nos = {"Stunned","Parrying","Carrying","Carried","Knocked","Gripping","Ragdoll","WepAttacking"}
local shaking
local carryDb = false
local downDb = false
local function Carry(down)
	if down then
		if effects:FindFirstChild("Carrying") then return end
		if effects:FindFirstChild("Carried") then return end
		if effects:FindFirstChild("Stunned") then return end
		if hum.Sit == true then return end
		if carryDb == true then return end
		if downDb == true then return end
		carryDb = true
		local found = false
		for _,v in ipairs(workspace:GetChildren()) do
			if v:FindFirstChild("Humanoid") and v ~= char and v:FindFirstChild("Effects") then
				if v.Effects:FindFirstChild("Knocked") and (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude <= 10 and not effects:FindFirstChild("Carrying") and not effects:FindFirstChild("Ragdoll") then
					if found == true then return end
					found = true
					carryTrack:Play()	
					carryingPlayer = v.Name
					game.ReplicatedStorage.Remotes.Carry:FireServer(v,"on")
				end
			end
		end
		wait(1)
		carryDb = false
	else
		if carryDb == true then return end
		if downDb == true then return end
		downDb = true
		if carryTrack.IsPlaying and effects:FindFirstChild("Carrying") then
			carryTrack:Stop()
			--			if carryingPlayer then
			game.ReplicatedStorage.Remotes.Carry:FireServer(carryingPlayer,"off")
			--			else
			--			end	
		end
		wait(1)
		downDb = false
	end
end	
local function Shake(size)
	shaking = true
	coroutine.resume(coroutine.create(function()
		while shaking do
			wait()
			local x,y,z = math.random(-(1*size),(1*size))/100,math.random(-(1*size),(1*size))/100,math.random(-(1*size),(1*size))/100
			hum.CameraOffset = Vector3.new(x,y,z)
		end
	end))
end
local function checkForNo()
	for _,v in ipairs(nos) do
		if effects:FindFirstChild(v) then
			return true
		end
	end
	for _,v in ipairs(char:GetChildren()) do 
		if v:IsA("Tool") then 
			return true
		end
	end
	return false
end
uis:GetPropertyChangedSignal("MouseBehavior"):Connect(function(input)
	if uis.MouseBehavior == Enum.MouseBehavior.LockCenter then
		shiftLock = true
	else
		shiftLock = false
	end
end)
local function stopPlayer(amt)
	local stunned = Instance.new("BoolValue")
	stunned.Name = "Stunned"
	stunned.Parent = effects 
	hum.WalkSpeed = 0
	hum.JumpHeight = 0
	coroutine.resume(coroutine.create(function()
		wait(amt)
		stunned:Destroy()
		repeat task.wait() until not effects:FindFirstChild("Stunned") 
		hum.WalkSpeed = 16	
		hum.JumpHeight = 7.2
		
	end))
end

local function Grip(down)

	if effects:FindFirstChild("Blocking") then return end
	if effects:FindFirstChild("Parrying") then return end
	if effects:FindFirstChild("Carried") then return end
	local cantSave = false

	local c = effects.ChildAdded:Connect(function(new)
		if new.Name == "Stunned" then
			if gripTrack.IsPlaying then
				cantSave = true
				if effects:FindFirstChild("Gripping") then
					effects["Gripping"]:Destroy()
				end
				if effects:FindFirstChild("CantRun") then
					effects["CantRun"]:Destroy()
				end
				gripTrack:Stop()

			end
		end
	end)
	if down then
		for _,v in ipairs(workspace:GetChildren()) do
			if v:FindFirstChild("Humanoid") and v ~= char and v:FindFirstChild("Effects") then
				if v.Effects:FindFirstChild("Knocked") and (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude  <= 10 and not v.Effects:FindFirstChild("GettingGripped") then
					local gripping = Instance.new("BoolValue",char.Effects)
					gripping.Name = "Gripping"
					canGrip = true
			--		stopPlayer(gripTrack.Length)
					wait(.1)
					gripTrack:Play()
					game.ReplicatedStorage.Remotes.Gripv:FireServer(v)
					gripTrack.Stopped:Wait()
					if cantSave then return end
					wait(.1)
					if gripping then
						gripping:Destroy()
					end	
					if canGrip then
						game.ReplicatedStorage.Remotes.Grip:FireServer(v,false)
					end
				end
			end
		end

	else
		if gripTrack.IsPlaying then

			gripTrack:Stop()
			canGrip = false
		end

	end
end
local parryTimer = 6
local weaveCD = false
local blessing = game.ReplicatedStorage.Requests.Get:InvokeServer("Blessing")
local race = game.ReplicatedStorage.Requests.Get:InvokeServer("Race")
if race == "Host" then 
	char.Animate.walk.WalkAnim.AnimationId = "rbxassetid://9414049806"
	char.Animate.idle.Animation1.AnimationId = "rbxassetid://9414042717"
end
local blessingcd = false
local blessingTrack
local cloakOn =false
local track = animator:LoadAnimation(game.ReplicatedStorage.Animations.CloakDo)
if blessing == "Transmissioner" or blessing == "V" then
	blessingTrack = animator:LoadAnimation(game.ReplicatedStorage.Animations.InstantTransmission)
elseif blessing == "Chrono's Touch" then
	blessingTrack = animator:LoadAnimation(game.ReplicatedStorage.Animations.ShinraTensei)
elseif blessing == "A Radio..?" then
	blessingTrack = animator:LoadAnimation(game.ReplicatedStorage.Animations.RadioAnimation)
elseif blessing == "Headcannon" then
	blessingTrack = animator:LoadAnimation(game.ReplicatedStorage.Animations.HeadThrow)
elseif blessing == "Touch of the Dead" then 
	blessingTrack = animator:LoadAnimation(game.ReplicatedStorage.Animations.TouchSummon)
end
local mouse = plr:GetMouse()
game.ReplicatedStorage.Remotes.getPos.OnClientInvoke = function()
	return mouse.Hit
end
local cam = workspace.CurrentCamera
local headBack = false

game.ReplicatedStorage.Remotes.cameraChange.OnClientEvent:Connect(function(to,dur,what)
	if what == "On" then
		cam.CameraSubject = to 
		task.wait(dur)
		cam.CameraSubject = char.Humanoid
	elseif what == "Back" then
		cam.CameraSubject = char.Humanoid		
	end
end)
if blessing == "Undying Willpower" then
	char.Humanoid.HealthChanged:Connect(function()
		
		print("new hp is " .. char.Humanoid.Health)
		local per = (char.Humanoid.Health/char.Humanoid.MaxHealth)*100
		if per<=30 and not char:FindFirstChild("WillCD") then
			print("Found")
			game.Lighting.Willpower.Enabled = true
			game.ReplicatedStorage.Remotes.ActivateBlessing:FireServer()
			wait(10)
			game.Lighting.Willpower.Enabled = false
		end
	end)
end
local delays = {0.1,0.1,0.1,0.1,0.1}
uis.InputBegan:Connect(function(key,gpe)
	
	if key.UserInputType == Enum.UserInputType.MouseButton1 and not gpe and (tick()-LastHit)>0.45 and CanPunch and not checkForNo() then
		LastHit=tick()
		if checkForNo() then
			return
		end
		local Attacking = Instance.new("StringValue",char.Effects)
		Attacking.Name = "Attacking"
		game.Debris:AddItem(Attacking,.4)
		local WepAttacking = Instance.new("IntValue")
		WepAttacking.Name = "FistAttacking"
		WepAttacking.Parent = char.Effects
		game.Debris:AddItem(WepAttacking,2)
		if Combo >= 1 and Combo<=5 then
			
			local punchAnim = animator:LoadAnimation(animations["Punch"..Combo])
			punchAnim:Play()
			wait(delays[Combo]) if Combo >= 5 then --[[wait(.1)]] end
			combatRemote:FireServer("COMBAT",Combo)
			coroutine.resume(coroutine.create(function()
				local cC = Combo
				wait(1)
				if cC == Combo-1 then
					Combo = 1
				end
			end))
		end
		if Combo >= 5 then
	--		stopPlayer(1)
			Combo = 1
			CanPunch = false
			wait(1.4)
			CanPunch = true
		else
			Combo = Combo + 1
		end
	
	elseif key.KeyCode == Enum.KeyCode.V and not gpe then
		carrying = not carrying
		Carry(carrying)	
	elseif key.KeyCode == Enum.KeyCode.B and not gpe then
		gripping = not gripping
		Grip(gripping)
	elseif key.KeyCode == Enum.KeyCode.F and not gpe and parryCD == false and not checkForNo() then
		if char.Effects:FindFirstChild("WepParry") then return end
		parryCD = true
		local NormalParrying = Instance.new("IntValue")
		NormalParrying.Name = "NormalParry"
		NormalParrying.Parent = char.Effects
		game.Debris:AddItem(NormalParrying,6)
		parryTrack:Play()
		combatRemote:FireServer("PARRY",0)
		parryTimer = 6
		repeat 
			wait(1)
			parryTimer = parryTimer - 1 
			if char:FindFirstChild("Parried") then
				parryTimer = 0
			end
			
		until parryTimer <= 0 
	--	wait(6)
		parryCD = false
	elseif key.KeyCode == Enum.KeyCode.R and not gpe and weaveCD == false and effects:FindFirstChild("Stunned") then
		weaveCD = true
		combatRemote:FireServer("WEAVE",0)
		weaveTrack:Play()
		if blessing == "Professionalist" then
			task.wait(2)
		elseif blessing == "V" then
			task.wait(5)
		else
			task.wait(10)
		end
		weaveCD = false
	elseif key.KeyCode == Enum.KeyCode.H and not gpe and not checkForNo() then
		if blessingcd == true then return end
		blessingcd = true
		if game.Workspace:FindFirstChild("RadioCD") and blessing == "A Radio..?" then return end
		if game.Workspace:FindFirstChild("TimeCD") and blessing == "Chrono's Touch" then return end
		game.ReplicatedStorage.Remotes.ActivateBlessing:FireServer()
		
		if blessing == "Transmissioner" then
			blessingTrack:Play()
			task.wait(30)
		elseif blessing == "V" then
			blessingTrack:Play()
			task.wait(60)
		elseif blessing == "Chrono's Touch" then
			task.wait(.3)
			blessingTrack:Play()
			task.wait(120)
		elseif blessing == "A Radio..?" then
			blessingTrack:Play()
			task.wait(120)
		elseif blessing == "Headcannon" then
			blessingTrack:Play()
			task.wait(20)
		elseif blessing == "Touch of the Dead" then
			blessingTrack:Play()
			if plr.Name ~= "Yuukisnoob" then 
				task.wait(60)
			end
			
		else
			blessingTrack:Play()
			task.wait(10)
		end
		blessingcd= false 
	elseif key.KeyCode == Enum.KeyCode.Home and not gpe and blessing == "V" then
		cloakOn = not cloakOn
		track:Play()
		game.ReplicatedStorage.Remotes.VC:FireServer(cloakOn)
	end 
end)


effects.ChildAdded:Connect(function(child)
	if child.Name == "Stunned" and effects:FindFirstChild("Carrying") then
		carrying = false
		Carry(false)
	end
end)

--[[
uis.InputEnded:Connect(function(key,gpe)
	if key.KeyCode == Enum.KeyCode.G and not gpe then
		ChargeAura(false)
		charging = false
		
	end
end)
]]
