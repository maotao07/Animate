local plr = game.Players.LocalPlayer
local char = nil
local UIS = game:GetService("UserInputService")
repeat wait()
	char = plr.Character
until char
local hmr = char["HumanoidRootPart"]
local pullUp = game.ReplicatedStorage.Animations.PullUp
function createHitbox(x,y,z)
	local part = Instance.new("Part",char)
	part.Name = "dk2dorlhmvn2dowexv1yzx"; 
	part.CanCollide = false
	part.Anchored = true
	part.Transparency = 1
	part.Color = Color3.fromRGB(255,0,0); 
	part.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
	part.Size = Vector3.new(x,y,z)
	part.Touched:Connect(function()
		
	end)
	game.Debris:AddItem(part,0.5)
	for _,v in ipairs(part:GetTouchingParts()) do 
		if v:FindFirstChild("Ledge") and v:FindFirstChild("Ledge"):IsA("BoolValue") then
			return v
		end
	end
end;
function createSecond()
	local detect1 = Ray.new(char.Head.Position+Vector3.new(0,3,0),char.HumanoidRootPart.CFrame.lookVector*4)
	local hit1,pos1 = game.Workspace:FindPartOnRay(detect1,char,false)
	local detect2 = Ray.new(char.HumanoidRootPart.Position+Vector3.new(0,-1,0),char.HumanoidRootPart.CFrame.lookVector*4)
	local detect3 = Ray.new(char.HumanoidRootPart.Position+Vector3.new(0,0,0),char.HumanoidRootPart.CFrame.lookVector*4)
	local detect4 = Ray.new(char.HumanoidRootPart.Position+Vector3.new(0,1,0),char.HumanoidRootPart.CFrame.lookVector*4) 
	local hit2,pos2 = game.Workspace:FindPartOnRay(detect2,char,false)
	local hit3,pos3 = game.Workspace:FindPartOnRay(detect3,char,false)
	local hit4,pos4 = game.Workspace:FindPartOnRay(detect4,char,false)
	
	if hit1 then

	end
	if hit2 then

	end
	if hit2 and not hit1 then 
		return hit2
	else if hit3 and not hit1 then 
		return hit3 
	else if hit4 and not hit1 then 
		return hit4 
	else 
		return false 
	end end end
	
	
end;
local cd = false
local hanging = false
local rechit = false
local vaulting = false
local now = tick()
UIS.InputBegan:Connect(function(key,gpe)
	if key.KeyCode == Enum.KeyCode.Space and not gpe then
		
		
--		UIS.InputBegan:Connect(function(key,gpe)
--			if key.KeyCode == Enum.KeyCode.Space and not gpe then
		if tick()-now <= .75 then
			if char:FindFirstChild("Stunned") then return end
			if char:FindFirstChild("Carrying") then return end
			if cd == true then return end
			if hanging then return end
			cd = true
			--doing the thingies lol
			local hit = createHitbox(5,7.5,5)
			local hit2 = createSecond()
			if hit2 then
				if vaulting then return end 
				if hit2.Parent:FindFirstChild("Humanoid") then return end
				vaulting = true
				local track2 =  char["Humanoid"].Animator:LoadAnimation(pullUp)				
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = hit
				weld.Part1 = hmr
				weld.Parent = hmr
				game.Debris:AddItem(weld,.1)
				track2:Play()
				local bp = Instance.new("BodyPosition")
				bp.P = 100000000
				bp.MaxForce = Vector3.new(10000,10000,10000)
				bp.Position = hmr.Position + hmr.CFrame.lookVector*2.5+Vector3.new(0,5.5,0)
				bp.Parent = hmr
				game.Debris:AddItem(bp,.1)
				wait(.3)
				track2:Stop()

									
				wait(.5)
				cd = false
				vaulting = false
			else
				cd = false	
			end	
		else
			now = tick()			
		end

	end
end)
