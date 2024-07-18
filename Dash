local plr = game.Players.LocalPlayer
repeat wait() until plr:FindFirstChild("Loaded",10)
local Char= plr.Character or plr.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local deb
local key = "W"

local hmr = Char:WaitForChild("HumanoidRootPart")
local RS = game:GetService("ReplicatedStorage")
local Effects = RS:WaitForChild("Effects",10)
local DustParticle = hmr:WaitForChild("DustAttachment",100):WaitForChild("DustEffect",100)
local AnimFolder = game.ReplicatedStorage.Animations
local s = Char.Humanoid:LoadAnimation(AnimFolder:WaitForChild("DashBack"))
local a = Char.Humanoid:LoadAnimation(AnimFolder:WaitForChild("DashLeft"))
local d = Char.Humanoid:LoadAnimation(AnimFolder:WaitForChild("DashRight"))
local w = Char.Humanoid:LoadAnimation(AnimFolder:WaitForChild("DashFront"))
local Camera = game.Workspace.CurrentCamera
local dashsize = 75
local cannot = {
	"Blocking",
	"Attacking",
	"Hanging",
	"Stunned",
	"RagDoll",
	"CantDash",
	"Carrying"
	
}
local function rayUnder()
	local rayp = RaycastParams.new()
	rayp.FilterDescendantsInstances = {Char}
	rayp.FilterType = Enum.RaycastFilterType.Blacklist
	local ray = workspace:Raycast(hmr.Position,hmr.CFrame.upVector*-7,rayp)
	if ray then
		return ray
	end
end

local function IsWKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.W)
end
local function IsDKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.D)
end
local function IsSKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.S)
end
local function IsAKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.A)
end
UserInputService.InputBegan:Connect(function(Input, GameStuff)
	if plr.Character.Effects:FindFirstChild("Parrying") then return end
	if plr.Character.HumanoidRootPart:FindFirstChild("swimBP") then return end
	if plr.Character.Effects:FindFirstChild("Carrying") then return end
	if plr.Character.Effects:FindFirstChild("CantRun") then return end
	if plr.Character.Effects:FindFirstChild("CantDash") then return end
	if plr.Character.Effects:FindFirstChild("Carried") then return end
	if plr.Character.Effects:FindFirstChild("Ragdoll") then return end
	if plr.Character.Effects:FindFirstChild("Knocked") then return end
	if plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then return end
	if Char:FindFirstChild("Hit") then return end
	if GameStuff then return end	
	 if Input.KeyCode == Enum.KeyCode.Q then
		local CameraCFrame = {
			CCFrame = Camera.CFrame;
			CLookVector = Camera.CFrame.LookVector;
			CRightVector = Camera.CFrame.RightVector;
		}
		local CLookVector = CameraCFrame.CLookVector
		local CRightVector = CameraCFrame.CRightVector
		local MovementDirection = CameraCFrame.CCFrame:VectorToObjectSpace(Char.Humanoid.MoveDirection)
	if deb == true then return end
	if Char.Humanoid.WalkSpeed <= 4 then return end
		for _,v in pairs(cannot) do
			if plr.Character:FindFirstChild(v) then 
				return
			end
		end
		--if math.abs(hmr.Velocity.y) > 1 then return end
	--	staminaVal.Value = staminaVal.Value - staminaReq
		deb = true
		local rayResult = rayUnder()
		if rayResult then
			DustParticle.Color =ColorSequence.new({ColorSequenceKeypoint.new(0,rayResult.Instance.Color);ColorSequenceKeypoint.new(1,rayResult.Instance.Color)}) 
		end
		DustParticle:Emit(math.random(25,35))
    local vb = Instance.new("BodyVelocity")
    vb.Parent = Char.HumanoidRootPart
    vb.MaxForce = Vector3.new(25000,0,25000)
	if key == "W" then
    vb.Velocity = CLookVector * dashsize
    script.RemoteEvent:FireServer()
    w:Play()
    end
    if key == "S" then
	s:Play()
	script.RemoteEvent:FireServer()
    vb.Velocity = CLookVector * -dashsize
    end
    if key == "D" then
	d:Play()
	script.RemoteEvent:FireServer()
    vb.Velocity = CRightVector * dashsize
    end
    if key == "A" then
	a:Play()
	script.RemoteEvent:FireServer()
    vb.Velocity = CRightVector* -dashsize
    end
    game.Debris:AddItem(vb,.2)
    wait(2)
    deb = false
 end
 if Input.KeyCode == Enum.KeyCode.W then
  key = "W"	
 end
 if Input.KeyCode == Enum.KeyCode.D then
  key = "D"	
 end
 if Input.KeyCode == Enum.KeyCode.S then
  key = "S"	
 end
 if Input.KeyCode == Enum.KeyCode.A then
  key = "A"	
 end
 
end)

UserInputService.InputEnded:Connect(function(Input, GameStuff)
 if GameStuff then return end
      if Input.KeyCode == Enum.KeyCode.W then
         if IsDKeyDown() then
		 key = "D"
	     end
	     if IsSKeyDown() then
		 key = "S"
	     end	
	     if IsAKeyDown() then
		 key = "A"
	     end
      end
       if Input.KeyCode == Enum.KeyCode.D then
         if IsWKeyDown() then
		 key = "W"
	     end
	     if IsSKeyDown() then
		 key = "S"
	     end	
	     if IsAKeyDown() then
		 key = "A"
	     end
      end
       if Input.KeyCode == Enum.KeyCode.S then
         if IsDKeyDown() then
		 key = "D"
	     end
	     if IsWKeyDown() then
		 key = "W"
	     end	
	     if IsAKeyDown() then
		 key = "A"
	     end
      end
       if Input.KeyCode == Enum.KeyCode.A then
         if IsDKeyDown() then
		 key = "D"
	     end
	     if IsSKeyDown() then
		 key = "S"
	     end	
	     if IsWKeyDown() then
		 key = "W"
	     end
      end
end)
