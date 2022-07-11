local env = getrenv()

env.options = {}
local options = env.options
options["Jail"] = {}
options["Cuffs"] = {}
options["Self"] = {}
options["Others"] = {}
options["Server"] = {}
options["Car"] = {}
options.Car["id"] = "8389041427"
options.Car["pitch"] = 1
options.Car["volume"] = 10
options["Map"] = {}

local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/0x00A7AFBC/amogussussysus/main/Library.lua"))()

local RunService = game:GetService("RunService")
 
RunService.RenderStepped:Connect(function(step)
	if options.Self["nocuff"] then
		uncuffPlayer(game:GetService("Players").LocalPlayer.Name)
	end
	if options.Self["nofollow"] then
		unfollowPlayer(game:GetService("Players").LocalPlayer.Name)
	end
end)

game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(instance)
	if instance.Name == "A-Chassis Interface" and options.Car["disable script"] then
		game:GetService("Players").LocalPlayer.PlayerGui["A-Chassis Interface"]["AC6_Sound_Mod"].Disabled = true
	end
end)

local weapons = {}
weapons["Glock 19"] = 11
weapons["Glock 17"] = 10
weapons["AUG A3"] = 2
weapons["Taser"] = 7


--[[
function updateDropdown(t, n, newOptions)
	local DropdownArray = newOptions or {}
	local uiList = Player:WaitForChild("PlayerGui") or CoreGuiService
	uiList = uiList:FindFirstChild(t).NewInstance.ContainerFrame.MainFrame.DisplayFrame.DisplayPage
	local name = n.."DROPDOWN"
	local dropdown = uiList:FindFirstChild(name)
	local DropdownFrame = dropdown.DropdownForeground.DropdownFrame

	for OptionIndex, Option in next, DropdownArray do

end
]]--

--game:GetService(\"Players\").LocalPlayer.Backpack.USP.ShellDrop:FireServer(game:GetService(\"Players\").LocalPlayer.Character );

local s = "while true do game:GetService(\"Players\").LocalPlayer.Character.USP.ShellDrop:FireServer(game:GetService(\"Players\").LocalPlayer.Character ); wait(); end"

function giveWeapon(wi)
	local t = 0

	for i,v in pairs(game.workspace.Polizei:GetChildren()) do
	
		if v.Name == "Tool-Giver" then
	
			t = t+1

			if t == wi then
				fireclickdetector(v.Part.ClickDetector)
			end
		end
	end
end

function checkTT()
	local t
	local guisAtPosition = COREGUI:GetGuiObjectsAtPosition(IYMouse.X, IYMouse.Y)

	for _, gui in pairs(guisAtPosition) do
		if gui.Parent == CMDsF then
			t = gui
		end
	end

	if t ~= nil and t:GetAttribute("Title") ~= nil then
		local x = IYMouse.X
		local y = IYMouse.Y
		local xP
		local yP
		if IYMouse.X > 200 then
			xP = x - 201
		else
			xP = x + 21
		end
		if IYMouse.Y > (IYMouse.ViewSizeY-96) then
			yP = y - 97
		else
			yP = y
		end
		Tooltip.Position = UDim2.new(0, xP, 0, yP)
		Description.Text = t:GetAttribute("Desc")
		if t:GetAttribute("Title") ~= nil then
			Title_3.Text = t:GetAttribute("Title")
		else
			Title_3.Text = ''
		end
		Tooltip.Visible = true
	else
		Tooltip.Visible = false
	end
end

function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end

function GetInTable(Table, Name)
	for i = 1, #Table do
		if Table[i] == Name then
			return i
		end
	end
	return false
end

function respawn(plr)
	if invisRunning then TurnVisible() end
	local char = plr.Character
	if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
	char:ClearAllChildren()
	local newChar = Instance.new("Model")
	newChar.Parent = workspace
	plr.Character = newChar
	wait()
	plr.Character = char
	newChar:Destroy()
end

local refreshCmd = false
function refresh(plr)
	refreshCmd = true
	local Human = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid", true)
	local pos = Human and Human.RootPart and Human.RootPart.CFrame
	local pos1 = workspace.CurrentCamera.CFrame
	respawn(plr)
	task.spawn(function()
		plr.CharacterAdded:Wait():WaitForChild("Humanoid").RootPart.CFrame, workspace.CurrentCamera.CFrame = pos, wait() and pos1
		refreshCmd = false
	end)
end

local lastDeath

function onDied()
	task.spawn(function()
		if pcall(function() Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') end) and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
			Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
				if getRoot(Players.LocalPlayer.Character) then
					lastDeath = getRoot(Players.LocalPlayer.Character).CFrame
				end
			end)
		else
			wait(2)
			onDied()
		end
	end)
end

function getstring(begin)
	local start = begin-1
	local AA = '' for i,v in pairs(cargs) do
		if i > start then
			if AA ~= '' then
				AA = AA .. ' ' .. v
			else
				AA = AA .. v
			end
		end
	end
	return AA
end

findCmd=function(cmd_name)
	for i,v in pairs(cmds)do
		if v.NAME:lower()==cmd_name:lower() or FindInTable(v.ALIAS,cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
end

function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end

cmdHistory = {}
local lastCmds = {}
local historyCount = 0
local split=" "
local lastBreakTime = 0
function execCmd(cmdStr,speaker,store)
	cmdStr = cmdStr:gsub("%s+$","")
	task.spawn(function()
		local rawCmdStr = cmdStr
		cmdStr = string.gsub(cmdStr,"\\\\","%%BackSlash%%")
		local commandsToRun = splitString(cmdStr,"\\")
		for i,v in pairs(commandsToRun) do
			v = string.gsub(v,"%%BackSlash%%","\\")
			local x,y,num = v:find("^(%d+)%^")
			local cmdDelay = 0
			local infTimes = false
			if num then
				v = v:sub(y+1)
				local x,y,del = v:find("^([%d%.]+)%^")
				if del then
					v = v:sub(y+1)
					cmdDelay = tonumber(del) or 0
				end
			else
				local x,y = v:find("^inf%^")
				if x then
					infTimes = true
					v = v:sub(y+1)
					local x,y,del = v:find("^([%d%.]+)%^")
					if del then
						v = v:sub(y+1)
						del = tonumber(del) or 1
						cmdDelay = (del > 0 and del or 1)
					else
						cmdDelay = 1
					end
				end
			end
			num = tonumber(num or 1)

			if v:sub(1,1) == "!" then
				local chunks = splitString(v:sub(2),split)
				if chunks[1] and lastCmds[chunks[1]] then v = lastCmds[chunks[1]] end
			end

			local args = splitString(v,split)
			local cmdName = args[1]
			local cmd = findCmd(cmdName)
			if cmd then
				table.remove(args,1)
				cargs = args
				if not speaker then speaker = Players.LocalPlayer end
				if store then
					if speaker == Players.LocalPlayer then
						if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1,11) ~= 'lastcommand' and rawCmdStr:sub(1,7) ~= 'lastcmd' then
							table.insert(cmdHistory,1,rawCmdStr)
						end
					end
					if #cmdHistory > 30 then table.remove(cmdHistory) end

					lastCmds[cmdName] = v
				end
				local cmdStartTime = tick()
				if infTimes then
					while lastBreakTime < cmdStartTime do
						local success,err = pcall(cmd.FUNC,args, speaker)
						if not success and _G.IY_DEBUG then
							warn("Command Error:", cmdName, err)
						end
						wait(cmdDelay)
					end
				else
					for rep = 1,num do
						if lastBreakTime > cmdStartTime then break end
						local success,err = pcall(function()
							cmd.FUNC(args, speaker)
						end)
						if not success and _G.IY_DEBUG then
							warn("Command Error:", cmdName, err)
						end
						if cmdDelay ~= 0 then wait(cmdDelay) end
					end
				end
			end
		end
	end)
end	

function addcmd(name,alias,func,plgn)
	cmds[#cmds+1]=
		{
			NAME=name;
			ALIAS=alias or {};
			FUNC=func;
			PLUGIN=plgn;
		}
end

function removecmd(cmd)
	if cmd ~= " " then
		for i = #cmds,1,-1 do
			if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS,cmd) then
				table.remove(cmds, i)
				for a,c in pairs(CMDsF:GetChildren()) do
					if string.find(c.Text, "^"..cmd.."$") or string.find(c.Text, "^"..cmd.." ") or string.find(c.Text, " "..cmd.."$") or string.find(c.Text, " "..cmd.." ") then
						c.TextTransparency = 0.7
						c.MouseButton1Click:Connect(function()
							notify(c.Text, "Command has been disabled by you or a plugin")
						end)
					end
				end
			end
		end
	end
end

function addbind(cmd,key,iskeyup,toggle)
	if toggle then
	binds[#binds+1]=
	{
		COMMAND=cmd;
		KEY=key;
		ISKEYUP=iskeyup;
		TOGGLE = toggle;
	}
	else
		binds[#binds+1]=
		{
			COMMAND=cmd;
			KEY=key;
			ISKEYUP=iskeyup;
		}
	end
end

function addcmdtext(text,name,desc)
	local newcmd = Example:Clone()
	local tooltipText = tostring(text)
	local tooltipDesc = tostring(desc)
	newcmd.Parent = CMDsF
	newcmd.Visible = false
	newcmd.Text = text
	newcmd.Name = 'PLUGIN_'..name
	table.insert(text1,newcmd)
	if desc and desc ~= '' then
		newcmd:SetAttribute("Title", tooltipText)
		newcmd:SetAttribute("Desc", tooltipDesc)
		newcmd.MouseButton1Down:Connect(function()
			if newcmd.Visible and newcmd.TextTransparency == 0 then
				Cmdbar:CaptureFocus()
				autoComplete(newcmd.Text)
				maximizeHolder()
			end
		end)
	end
end

local WTS = function(Object)
	local ObjectVector = workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
	return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local MousePositionToVector2 = function()
	return Vector2.new(IYMouse.X, IYMouse.Y)
end

local GetClosestPlayerFromCursor = function()
	local found = nil
    local ClosestDistance = math.huge
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
            for k, x in pairs(v.Character:GetChildren()) do
				if string.find(x.Name, "Torso") then
					local Distance = (WTS(x) - MousePositionToVector2()).Magnitude
					if Distance < ClosestDistance then
						ClosestDistance = Distance
						found = v
					end
				end
            end
        end
    end
	return found
end

SpecialPlayerCases = {
	["all"] = function(speaker) return Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs,v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker)return {speaker} end,
	["#(%d+)"] = function(speaker,args,currentList)
		local returns = {}
		local randAmount = tonumber(args[1])
		local players = {unpack(currentList)}
		for i = 1,randAmount do
			if #players == 0 then break end
			local randIndex = math.random(1,#players)
			table.insert(returns,players[randIndex])
			table.remove(players,randIndex)
		end
		return returns
	end,
	["random"] = function(speaker,args,currentList)
		local players = Players:GetPlayers()
		local localplayer = Players.LocalPlayer
		table.remove(players, table.find(players, localplayer))
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker,args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character:FindFirstChild('Pal Hair') or plr.Character:FindFirstChild('Kate Hair') then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker,args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local lowest = math.huge
		local NearestPlayer = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance < lowest then
					lowest = distance
					NearestPlayer = {plr}
				end
			end
		end
		return NearestPlayer
	end,
	["farthest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local highest = 0
		local Farthest = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance > highest then
					highest = distance
					Farthest = {plr}
				end
			end
		end
		return Farthest
	end,
	["group(%d+)"] = function(speaker,args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker,args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and getRoot(plr.Character) then
				local magnitude = (getRoot(plr.Character).Position-getRoot(speakerChar).Position).magnitude
				if magnitude <= radius then table.insert(returns,plr) end
			end
		end
		return returns
	end,
	["cursor"] = function(speaker)
		local plrs = {}
		local v = GetClosestPlayerFromCursor()
		if v ~= nil then table.insert(plrs, v) end
		return plrs
	end,
}

function toTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end

function onlyIncludeInTable(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function removeTableMatches(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function getPlayersByName(Name)
	local Name,Len,Found = string.lower(Name),#Name,{}
	for _,v in pairs(Players:GetPlayers()) do
		if Name:sub(0,1) == '@' then
			if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
				table.insert(Found,v)
			end
		else
			if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
				table.insert(Found,v)
			end
		end
	end
	return Found
end

Players = game:GetService("Players")

function getPlayers(list,speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list,",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = onlyIncludeInTable(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
end

function spawnCarAndEmptyIt()
	-- clear owned cars locally (change name)
	if game:GetService("Workspace"):FindFirstChild(game:GetService("Players").LocalPlayer.Name.."Car") then
		game:GetService("Workspace")[game:GetService("Players").LocalPlayer.Name.."Car"].Name = "Amongussycar"
	end
	-- open spawn gui
	fireclickdetector(game:GetService("Workspace").Polizei["Polizei Wache"]["Polizeiwache "]["Parking Gate"].HingeGroup.Trigger.ClickDetector)
	-- click spawn
	game:GetService("Players").LocalPlayer.PlayerGui.Gui.BG.Visible = true
	-- spawn
	local clickpos = game:GetService("Players").LocalPlayer.PlayerGui.Gui.BG.S.AbsolutePosition
	mousemoveabs(clickpos.X + 50, clickpos.Y + 50)
	mousemoverel(2, 2)
	mouse1click()
	-- Teleport in car seed
	-- wait 3 seconds
	-- presss w for some time
	-- press space (exit car seed)

end

function getPlayerList()
    ret = {}
    for i,v in pairs(game:GetService("Players"):GetChildren()) do
            table.insert(ret, v.Name)
    end
	return ret
end

function getCars()
	ret = {}
	local players = getPlayerList()
	for _,v in pairs(players) do
		if game:GetService("Workspace"):FindFirstChild(v.."Car") or game:GetService("Workspace"):FindFirstChild(v.."'s Car") then
			table.insert(ret, v.."Car")
		end
	end
	return ret
end

function cuffPlayer(n)
	local target = game:GetService("Players")[n]
	local ohString2 = "Tie"
	
	game:GetService("ReplicatedStorage").CarbonEvents.TieEvent:FireServer(target, ohString2)
end

function uncuffPlayer(n)
	local target = game:GetService("Players")[n]
	local ohString2 = "Untie"
	
	game:GetService("ReplicatedStorage").CarbonEvents.TieEvent:FireServer(target, ohString2)
end

function followPlayer(n, t)
	local target = game:GetService("Players")[n]
	local ohString2 = "Follow"
	local tofollow = game:GetService("Players")[t]
	
	game:GetService("ReplicatedStorage").CarbonEvents.TieEvent:FireServer(target, ohString2, tofollow)
end

function unfollowPlayer(n)
	local target = game:GetService("Players")[n]
	local ohString2 = "Stop"
	
	game:GetService("ReplicatedStorage").CarbonEvents.TieEvent:FireServer(target, ohString2)
end

function teleportVehicle(position)
	local speaker = game:GetService("Players").LocalPlayer
	for i,v in pairs(game:GetService("Players"):GetChildren())do
		if v.Character ~= nil then
			local seat = speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart
			local vehicleModel = seat.Parent
			repeat
				if vehicleModel.ClassName ~= "Model" then
					vehicleModel = vehicleModel.Parent
				end
			until vehicleModel.ClassName == "Model"
			wait(0.1)
			vehicleModel:MoveTo(position)
		end
	end
end

function enablegod()
    local netboost = Vector3.new(0, 45, 0) --velocity 
--netboost usage: 
--set to false to disable
--set to a vector3 value if you dont want the velocity to change
--set to a number to change the velocity in real time with magnitude equal to the number
local idleMag = 0.01 --used only in case netboost is set to a number value
--if magnitude of the real velocity of a part is lower than this
--then the fake velocity is being set to Vector3.new(0, netboost, 0)
local noRotVel = true --parts rotation velocity set to Vector3.new(0, 0, 0)
local simradius = "shp" --simulation radius (net bypass) method
--"shp" - sethiddenproperty
--"ssr" - setsimulationradius
--false - disable
local antiragdoll = true --removes hingeConstraints and ballSocketConstraints from your character
local newanimate = true --disables the animate script and enables after reanimation
local discharscripts = true --disables all localScripts parented to your character before reanimation
local R15toR6 = true --tries to convert your character to r6 if its r15
local addtools = false --puts all tools from backpack to character and lets you hold them after reanimation
local loadtime = game:GetService("Players").RespawnTime + 0.5 --anti respawn delay
local method = 3 --reanimation method
--methods:
--0 - breakJoints (takes [loadtime] seconds to laod)
--1 - limbs
--2 - limbs + anti respawn
--3 - limbs + breakJoints after [loadtime] seconds
--4 - remove humanoid + breakJoints
--5 - remove humanoid + limbs
local alignmode = 2 --AlignPosition mode
--modes:
--1 - AlignPosition rigidity enabled true
--2 - 2 AlignPositions rigidity enabled both true and false
--3 - AlignPosition rigidity enabled false
local hedafterneck = true --disable aligns for head and enable after neck is removed

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local stepped = rs.Stepped
local heartbeat = rs.Heartbeat
local renderstepped = rs.RenderStepped
local sg = game:GetService("StarterGui")
local ws = game:GetService("Workspace")
local cf = CFrame.new
local v3 = Vector3.new
local v3_0 = v3(0, 0, 0)
local inf = math.huge

local c = lp.Character

if not (c and c.Parent) then
	return
end

c:GetPropertyChangedSignal("Parent"):Connect(function()
	if not (c and c.Parent) then
		c = nil
	end
end)

local function gp(parent, name, className)
	local ret = nil
	pcall(function()
		for i, v in pairs(parent:GetChildren()) do
			if (v.Name == name) and v:IsA(className) then
				ret = v
				break
			end
		end
	end)
	return ret
end

local function align(Part0, Part1)
	Part0.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.0001, 0.0001, 0.0001, 0.0001)

	local att0 = Instance.new("Attachment", Part0)
	att0.Orientation = v3_0
	att0.Position = v3_0
	att0.Name = "att0_" .. Part0.Name
	local att1 = Instance.new("Attachment", Part1)
	att1.Orientation = v3_0
	att1.Position = v3_0
	att1.Name = "att1_" .. Part1.Name

	if (alignmode == 1) or (alignmode == 2) then
		local ape = Instance.new("AlignPosition", att0)
		ape.ApplyAtCenterOfMass = false
		ape.MaxForce = inf
		ape.MaxVelocity = inf
		ape.ReactionForceEnabled = false
		ape.Responsiveness = 200
		ape.Attachment1 = att1
		ape.Attachment0 = att0
		ape.Name = "AlignPositionRtrue"
		ape.RigidityEnabled = true
	end

	if (alignmode == 2) or (alignmode == 3) then
		local apd = Instance.new("AlignPosition", att0)
		apd.ApplyAtCenterOfMass = false
		apd.MaxForce = inf
		apd.MaxVelocity = inf
		apd.ReactionForceEnabled = false
		apd.Responsiveness = 200
		apd.Attachment1 = att1
		apd.Attachment0 = att0
		apd.Name = "AlignPositionRfalse"
		apd.RigidityEnabled = false
	end

	local ao = Instance.new("AlignOrientation", att0)
	ao.MaxAngularVelocity = inf
	ao.MaxTorque = inf
	ao.PrimaryAxisOnly = false
	ao.ReactionTorqueEnabled = false
	ao.Responsiveness = 200
	ao.Attachment1 = att1
	ao.Attachment0 = att0
	ao.RigidityEnabled = false

	if netboost then
        local steppedcon = nil
        local heartbeatcon = nil
        Part0:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (Part0 and Part0.Parent) then
                Part0 = nil
                steppedcon:Disconnect()
                heartbeatcon:Disconnect()
            end
        end)
        local vel = v3_0
        local rotvel = noRotVel and v3_0
        if typeof(netboost) == "Vector3" then
            steppedcon = stepped:Connect(function()
                Part0.Velocity = vel
                if rotvel then
                    Part0.RotVelocity = rotvel
                end
            end)
            heartbeatcon = heartbeat:Connect(function()
                vel = Part0.Velocity
                Part0.Velocity = netboost
                if rotvel then
                    rotvel = Part0.RotVelocity
                    Part0.RotVelocity = v3_0
                end
            end)
        elseif typeof(netboost) == "number" then
    	    steppedcon = stepped:Connect(function()
                Part0.Velocity = vel
                if rotvel then
                    Part0.RotVelocity = rotvel
                end
            end)
            heartbeatcon = heartbeat:Connect(function()
                vel = Part0.Velocity
                local newvel = vel
                local mag = newvel.Magnitude
                if mag < idleMag then
                    newvel = v3(0, netboost, 0)
                else
                    local multiplier = netboost / mag
                    newvel *= v3(multiplier,  multiplier, multiplier)
                end
                Part0.Velocity = newvel
                if rotvel then
                    rotvel = Part0.RotVelocity
                    Part0.RotVelocity = v3_0
                end
            end)
    	end
    end
end

local function respawnrequest()
	local ccfr = ws.CurrentCamera.CFrame
	local c = lp.Character
	lp.Character = nil
	lp.Character = c
	ws.CurrentCamera:GetPropertyChangedSignal("CFrame"):Wait()
	ws.CurrentCamera.CFrame = ccfr
end

local destroyhum = (method == 4) or (method == 5)
local breakjoints = (method == 0) or (method == 4)
local antirespawn = (method == 0) or (method == 2) or (method == 3)

addtools = addtools and gp(lp, "Backpack", "Backpack")

if simradius == "shp" then
	local shp = sethiddenproperty or set_hidden_property or set_hidden_prop or sethiddenprop
	if shp then
		spawn(function()
			while c and heartbeat:Wait() do
				shp(lp, "SimulationRadius", inf)
			end
		end)
	end
elseif simradius == "ssr" then
	local ssr = setsimulationradius or set_simulation_radius or set_sim_radius or setsimradius or set_simulation_rad or setsimulationrad
	if ssr then
		spawn(function()
			while c and heartbeat:Wait() do
				ssr(inf)
			end
		end)
	end
end

antiragdoll = antiragdoll and function(v)
	if v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint") then
		v.Parent = nil
	end
end

if antiragdoll then
	for i, v in pairs(c:GetDescendants()) do
		antiragdoll(v)
	end
	c.DescendantAdded:Connect(antiragdoll)
end

if antirespawn then
	respawnrequest()
end

if method == 0 then
	wait(loadtime)
	if not c then
		return
	end
end

if discharscripts then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("LocalScript") then
			v.Disabled = true
		end
	end
elseif newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate and (not animate.Disabled) then
		animate.Disabled = true
	else
		newanimate = false
	end
end

local hum = c:FindFirstChildOfClass("Humanoid")
if hum then
	for i, v in pairs(hum:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end

if addtools then
	for i, v in pairs(addtools:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = c
		end
	end
end

pcall(function()
	settings().Physics.AllowSleep = false
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
end)

local OLDscripts = {}

for i, v in pairs(c:GetDescendants()) do
	if v.ClassName == "Script" then
		table.insert(OLDscripts, v)
	end
end

local scriptNames = {}

for i, v in pairs(c:GetDescendants()) do
	if v:IsA("BasePart") then
		local newName = tostring(i)
		local exists = true
		while exists do
			exists = false
			for i, v in pairs(OLDscripts) do
				if v.Name == newName then
					exists = true
				end
			end
			if exists then
				newName = newName .. "_"    
			end
		end
		table.insert(scriptNames, newName)
		Instance.new("Script", v).Name = newName
	end
end

c.Archivable = true
local cl = c:Clone()
for i, v in pairs(cl:GetDescendants()) do
	pcall(function()
		v.Transparency = 1
		v.Anchored = false
	end)
end

local model = Instance.new("Model", c)
model.Name = model.ClassName

model:GetPropertyChangedSignal("Parent"):Connect(function()
	if not (model and model.Parent) then
		model = nil
	end
end)

for i, v in pairs(c:GetChildren()) do
	if v ~= model then
		if destroyhum and v:IsA("Humanoid") then
			v:Destroy()
		else
			if addtools and v:IsA("Tool") then
				for i1, v1 in pairs(v:GetDescendants()) do
					if v1 and v1.Parent and v1:IsA("BasePart") then
						local bv = Instance.new("BodyVelocity", v1)
						bv.Velocity = v3_0
						bv.MaxForce = v3(1000, 1000, 1000)
						bv.P = 1250
						bv.Name = "bv_" .. v.Name
					end
				end
			end
			v.Parent = model
		end
	end
end
local head = gp(model, "Head", "BasePart")
local torso = gp(model, "Torso", "BasePart") or gp(model, "UpperTorso", "BasePart")
if breakjoints then
	model:BreakJoints()
else
	if head and torso then
		for i, v in pairs(model:GetDescendants()) do
			if v:IsA("Weld") or v:IsA("Snap") or v:IsA("Glue") or v:IsA("Motor") or v:IsA("Motor6D") then
				local save = false
				if (v.Part0 == torso) and (v.Part1 == head) then
					save = true
				end
				if (v.Part0 == head) and (v.Part1 == torso) then
					save = true
				end
				if save then
					if hedafterneck then
						hedafterneck = v
					end
				else
					v:Destroy()
				end
			end
		end
	end
	if method == 3 then
		spawn(function()
			wait(loadtime)
			if model then
				model:BreakJoints()
			end
		end)
	end
end

cl.Parent = c
for i, v in pairs(cl:GetChildren()) do
	v.Parent = c
end
cl:Destroy()

local modelDes = {}
for i, v in pairs(model:GetDescendants()) do
	if v:IsA("BasePart") then
		i = tostring(i)
		local con = nil
		con = v:GetPropertyChangedSignal("Parent"):Connect(function()
			if not (v and v.Parent) then
				con:Disconnect()
				modelDes[i] = nil
			end
		end)
		modelDes[i] = v
	end
end
local modelcolcon = nil
local function modelcolf()
	if model then
		for i, v in pairs(modelDes) do
			v.CanCollide = false
		end
	else
		modelcolcon:Disconnect()
	end
end
modelcolcon = stepped:Connect(modelcolf)
modelcolf()

for i, scr in pairs(model:GetDescendants()) do
	if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
		local Part0 = scr.Parent
		if Part0:IsA("BasePart") then
			for i1, scr1 in pairs(c:GetDescendants()) do
				if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
					local Part1 = scr1.Parent
					if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
						align(Part0, Part1)
						break
					end
				end
			end
		end
	end
end

if (typeof(hedafterneck) == "Instance") and head and head.Parent then
	local aligns = {}
	for i, v in pairs(head:GetDescendants()) do
		if v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
			table.insert(aligns, v)
			v.Enabled = false
		end
	end
	spawn(function()
		while c and hedafterneck and hedafterneck.Parent do
			stepped:Wait()
		end
		if not (c and head and head.Parent) then
			return
		end
		for i, v in pairs(aligns) do
			pcall(function()
				v.Enabled = true
			end)
		end
	end)
end

for i, v in pairs(c:GetDescendants()) do
	if v and v.Parent then
		if v.ClassName == "Script" then
			if table.find(scriptNames, v.Name) then
				v:Destroy()
			end
		elseif not v:IsDescendantOf(model) then
			if v:IsA("Decal") then
				v.Transparency = 1
			elseif v:IsA("ForceField") then
				v.Visible = false
			elseif v:IsA("Sound") then
				v.Playing = false
			elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			end
		end
	end
end

if newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate then
		animate.Disabled = false
	end
end

if addtools then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = addtools
		end
	end
end

local hum0 = model:FindFirstChildOfClass("Humanoid")
local hum1 = c:FindFirstChildOfClass("Humanoid")
if hum1 then
	ws.CurrentCamera.CameraSubject = hum1
	local camSubCon = nil
	local function camSubFunc()
		camSubCon:Disconnect()
		if c and hum1 and (hum1.Parent == c) then
			ws.CurrentCamera.CameraSubject = hum1
		end
	end
	camSubCon = renderstepped:Connect(camSubFunc)
	if hum0 then
		hum0.Changed:Connect(function(prop)
			if (prop == "Jump") and hum1 and hum1.Parent then
				hum1.Jump = hum0.Jump
			end
		end)
	else
		lp.Character = nil
		lp.Character = c
	end
end

local rb = Instance.new("BindableEvent", c)
rb.Event:Connect(function()
	rb:Destroy()
	sg:SetCore("ResetButtonCallback", true)
	if destroyhum then
		c:BreakJoints()
		return
	end
	if antirespawn then
		if hum0 and hum0.Parent and (hum0.Health > 0) then
			model:BreakJoints()
			hum0.Health = 0
		end
		respawnrequest()
	else
		if hum0 and hum0.Parent and (hum0.Health > 0) then
			model:BreakJoints()
			hum0.Health = 0
		end
	end
end)
sg:SetCore("ResetButtonCallback", rb)

spawn(function()
	while c do
		if hum0 and hum0.Parent and hum1 and hum1.Parent then
			hum1.Jump = hum0.Jump
		end
		wait()
	end
	sg:SetCore("ResetButtonCallback", true)
end)

R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
if R15toR6 then
    local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
	if part then
	    local cfr = part.CFrame
		local R6parts = { 
			head = {
				Name = "Head",
				Size = v3(2, 1, 1),
				R15 = {
					Head = 0
				}
			},
			torso = {
				Name = "Torso",
				Size = v3(2, 2, 1),
				R15 = {
					UpperTorso = 0.2,
					LowerTorso = -0.8
				}
			},
			root = {
				Name = "HumanoidRootPart",
				Size = v3(2, 2, 1),
				R15 = {
					HumanoidRootPart = 0
				}
			},
			leftArm = {
				Name = "Left Arm",
				Size = v3(1, 2, 1),
				R15 = {
					LeftHand = -0.85,
					LeftLowerArm = -0.2,
					LeftUpperArm = 0.4
				}
			},
			rightArm = {
				Name = "Right Arm",
				Size = v3(1, 2, 1),
				R15 = {
					RightHand = -0.85,
					RightLowerArm = -0.2,
					RightUpperArm = 0.4
				}
			},
			leftLeg = {
				Name = "Left Leg",
				Size = v3(1, 2, 1),
				R15 = {
					LeftFoot = -0.85,
					LeftLowerLeg = -0.15,
					LeftUpperLeg = 0.6
				}
			},
			rightLeg = {
				Name = "Right Leg",
				Size = v3(1, 2, 1),
				R15 = {
					RightFoot = -0.85,
					RightLowerLeg = -0.15,
					RightUpperLeg = 0.6
				}
			}
		}
		for i, v in pairs(c:GetChildren()) do
			if v:IsA("BasePart") then
				for i1, v1 in pairs(v:GetChildren()) do
					if v1:IsA("Motor6D") then
						v1.Part0 = nil
					end
				end
			end
		end
		part.Archivable = true
		for i, v in pairs(R6parts) do
			local part = part:Clone()
			part:ClearAllChildren()
			part.Name = v.Name
			part.Size = v.Size
			part.CFrame = cfr
			part.Anchored = false
			part.Transparency = 1
			part.CanCollide = false
			for i1, v1 in pairs(v.R15) do
				local R15part = gp(c, i1, "BasePart")
				local att = gp(R15part, "att1_" .. i1, "Attachment")
				if R15part then
					local weld = Instance.new("Weld", R15part)
					weld.Name = "Weld_" .. i1
					weld.Part0 = part
					weld.Part1 = R15part
					weld.C0 = cf(0, v1, 0)
					weld.C1 = cf(0, 0, 0)
					R15part.Massless = true
					R15part.Name = "R15_" .. i1
					R15part.Parent = part
					if att then
						att.Parent = part
						att.Position = v3(0, v1, 0)
					end
				end
			end
			part.Parent = c
			R6parts[i] = part
		end
		local R6joints = {
			neck = {
				Parent = R6parts.torso,
				Name = "Neck",
				Part0 = R6parts.torso,
				Part1 = R6parts.head,
				C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rootJoint = {
				Parent = R6parts.root,
				Name = "RootJoint" ,
				Part0 = R6parts.root,
				Part1 = R6parts.torso,
				C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rightShoulder = {
				Parent = R6parts.torso,
				Name = "Right Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightArm,
				C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftShoulder = {
				Parent = R6parts.torso,
				Name = "Left Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.leftArm,
				C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			},
			rightHip = {
				Parent = R6parts.torso,
				Name = "Right Hip",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightLeg,
				C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftHip = {
				Parent = R6parts.torso,
				Name = "Left Hip" ,
				Part0 = R6parts.torso,
				Part1 = R6parts.leftLeg,
				C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			}
		}
		for i, v in pairs(R6joints) do
			local joint = Instance.new("Motor6D")
			for prop, val in pairs(v) do
				joint[prop] = val
			end
			R6joints[i] = joint
		end
		hum1.RigType = Enum.HumanoidRigType.R6
		hum1.HipHeight = 0
	end
end
end



function loadUI()

	local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/0x00A7AFBC/amogussussysus/main/Library.lua"))()

	local MainUI = UILibrary.Load("Traun RIP v1")
	local Jail = MainUI.AddPage("Jail")
	local Cuffs = MainUI.AddPage("Cuffs")
	local Self = MainUI.AddPage("Self")
	local Car = MainUI.AddPage("Car")
	local Map = MainUI.AddPage("Map")
	local Server = MainUI.AddPage("Server")
	local Misc = MainUI.AddPage("Misc")
	local Info = MainUI.AddPage("Info")

	local jPlayerSelector = Jail.AddDropdown("Player", getPlayerList(), function(v)
		options.Jail["player"] = v
	end)
	
	local jInfoLabel = Jail.AddLabel("0 = infinite")
	
	local jTime = Jail.AddSlider("Time (in seconds)", {Min = 0, Max = 1000, Def = 60}, function(v)
		options.Jail["time"] = v
	end)
	
	local jStart = Jail.AddButton("Jail player", function()
		game:GetService("ReplicatedStorage").CarbonEvents.ToJail:FireServer(options.Jail["player"], options.Jail["time"])
	end)
	
	local cPlayerSelector = Cuffs.AddDropdown("Player", getPlayerList(), function(v)
		options.Cuffs["player"] = v
	end)
	
	local cPlayerSelector2 = Cuffs.AddDropdown("Target (For follow action)", getPlayerList(), function(v)
		options.Cuffs["target"] = v
	end)
	
	local cActionSelector = Cuffs.AddDropdown("Action", {"Cuff", "Uncuff", "Follow", "Unfollow"}, function(v)
		options.Cuffs["action"] = v
	end)
	
	local cPerform = Cuffs.AddButton("Perform action", function()
		local action = options.Cuffs["action"]
		local target1 = options.Cuffs["player"]
		local target2 = options.Cuffs["target"]
	
		if action == "Cuff" then
			cuffPlayer(target1)
		elseif action == "Uncuff" then
			uncuffPlayer(target1)
		elseif action == "Follow" then
			followPlayer(target1, target2)
		elseif action == "Unfollow" then
			unfollowPlayer(target1)
		end
	end)
	
	local sUncuffable = Self.AddToggle("No cuff", false, function(v)
		options.Self["nocuff"] = v
	end)
	
	local sNofollow = Self.AddToggle("No follow", false, function(v)
		options.Self["nofollow"] = v
	end)
	
	local sGodmode = Self.AddButton("Godmode", enablegod)

	local cPlaysoundVolumeSlider = Car.AddSlider("Volume", {Min = 0, Max = 100, Def = 10}, function(v)
		options.Car["volume"] = v
	end) 

	local cPlaysoundPitchSlider = Car.AddSlider("Pitch", {Min = 1, Max = 20, Def = 1}, function(v)
		options.Car["pitch"] = v
	end)

	--[[
	local cTargetCar = Car.AddDropdown("Users car", getCars(), function(v)
		options.Car["target"] = velocity
	end)
	]]--

	local cPlaySoundSetId = Car.AddButton("Set sound id", function()
		-- Gui to Lua
-- Version: 3.2

-- Instances:

local Amongussy = Instance.new("ScreenGui")
local Frame = Instance.new("ImageLabel")
local TextBox = Instance.new("TextBox")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local TextButton_Roundify_12px = Instance.new("ImageLabel")
local ImageLabel = Instance.new("ImageLabel")
local TextLabel_2 = Instance.new("TextLabel")

--Properties:

Amongussy.Parent = game.CoreGui

Frame.Name = "Frame"
Frame.Parent = Amongussy
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.Position = UDim2.new(0.404619932, 0, 0.353558928, 0)
Frame.Size = UDim2.new(0, 256, 0, 83)
Frame.Image = "rbxassetid://3570695787"
Frame.ImageColor3 = Color3.fromRGB(20, 20, 20)
Frame.ScaleType = Enum.ScaleType.Slice
Frame.SliceCenter = Rect.new(100, 100, 100, 100)
Frame.SliceScale = 0.120

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0, 0, 0.352869093, 0)
TextBox.Size = UDim2.new(0, 256, 0, 24)
TextBox.Font = Enum.Font.SourceSans
TextBox.PlaceholderText = "sound id"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Size = UDim2.new(0, 256, 0, 26)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Sound id selector"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 14.000

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0, 0, 0.714314997, 0)
TextButton.Size = UDim2.new(0, 256, 0, 23)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Set id"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14.000
TextButton.MouseButton1Click:Connect(function()
	if TextBox.Text ~= "" then
		options.Car["id"] = TextBox.Text
		game:GetService("CoreGui").ScreenGui:Destroy()
	end
	
end)

TextButton_Roundify_12px.Name = "TextButton_Roundify_12px"
TextButton_Roundify_12px.Parent = TextButton
TextButton_Roundify_12px.Active = true
TextButton_Roundify_12px.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton_Roundify_12px.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton_Roundify_12px.BackgroundTransparency = 1.000
TextButton_Roundify_12px.Position = UDim2.new(0.5, 0, 0.5, 0)
TextButton_Roundify_12px.Selectable = true
TextButton_Roundify_12px.Size = UDim2.new(1, 0, 1, 0)
TextButton_Roundify_12px.Image = "rbxassetid://3570695787"
TextButton_Roundify_12px.ImageColor3 = Color3.fromRGB(35, 35, 35)
TextButton_Roundify_12px.ScaleType = Enum.ScaleType.Slice
TextButton_Roundify_12px.SliceCenter = Rect.new(100, 100, 100, 100)
TextButton_Roundify_12px.SliceScale = 0.120

ImageLabel.Parent = TextButton
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.56640625, 0, -0.0838132128, 0)
ImageLabel.Size = UDim2.new(0, 24, 0, 24)
ImageLabel.Image = "http://www.roblox.com/asset/?id=6031094667"

TextLabel_2.Parent = TextButton
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Size = UDim2.new(0, 256, 0, 23)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "Set id"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 14.000
	end)

	local cPlaySoundPlay = Car.AddButton("Play sound", function()
		local ohString1 = "updateSound"
		local ohString2 = "Rev"
		local ohString3 = "rbxassetid://"..options.Car["id"]
		local ohNumber4 = options.Car["pitch"]
		local ohNumber5 = options.Car["volume"]
		car = game:GetService("Players").LocalPlayer.Name.."Car"

		workspace[car].AC6_FE_Sounds:FireServer(ohString1, ohString2, ohString3, ohNumber4, ohNumber5)
	end)

	local cDisableSoundScript = Car.AddToggle("Disable car sound script", false, function(v)
		options.Car["disable script"] = v
		if v == false then
			--game:GetService("Players").PlayerGui["A-Chassis Interface"]["AC6_Sound_Mod"].Disabled = true
			if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("A-Chassis Interface") then
				game:GetService("Players").LocalPlayer.PlayerGui["A-Chassis Interface"]["AC6_Sound_Mod"].Disabled = false
			end
		elseif v == true then
			if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("A-Chassis Interface") then
				game:GetService("Players").LocalPlayer.PlayerGui["A-Chassis Interface"]["AC6_Sound_Mod"].Disabled = true
			end
		end
	end)

	local cOpenCarSpawnerMenu = Car.AddButton("Open civi spawn menu", function()
		fireclickdetector(game:GetService("Workspace")["Car spawner"]["Car spwaner Bürger"].GuiThing.ClickDetector)
	end)

	local cOpenCarSpawnerMenu = Car.AddButton("Open cop spawn menu", function()
		fireclickdetector(game:GetService("Workspace")["Car spawner"]["Car spwaner Polizei"].GuiThing.ClickDetector)
	end)

	local mOpenPoliceGate = Map.AddButton("Toggle police gate", function()
		fireclickdetector(game:GetService("Workspace").Polizei["Polizei Wache"]["Polizeiwache "]["Parking Gate"].HingeGroup.Trigger.ClickDetector)
	end)

	local mMassspawnPolice = Map.AddToggle("Spam spawn police cars", false, function(v)
		options.Map["spawn"] = v
	end)

	local mReload = Misc.AddButton("Reload", function() 
		loadUI()
	end)

	local sWeaponLabel = Self.AddLabel("--- Weapon giver ---")

	local sWeaponSelector = Self.AddDropdown("Weapon", {"USP", "Glock 17", "Glock 19", "AUG A3", "Taser"}, function(v)
		options.Self["weapon"] = v
	end)

	local sGive = Self.AddButton("Give weapon", function()
		local weapon = options.Self["weapon"]

		if weapon == "USP" then
			fireclickdetector(game.workspace.idk["Tool-Giver"].Part.ClickDetector)
		elseif weapon == "Glock 17" then
			giveWeapon(weapons[weapon])
		elseif weapon == "Glock 19" then
			giveWeapon(weapons[weapon])
		elseif weapon == "AUG A3" then
			giveWeapon(weapons[weapon])
		elseif weapon == "Taser" then
			giveWeapon(weapons[weapon])
		end
	end)

	local sGiveAll = Self.AddButton("Give all weapons", function()
		giveWeapon(weapons["Glock 17"])
		giveWeapon(weapons["Glock 19"])
		giveWeapon(weapons["AUG A3"])
		giveWeapon(weapons["Taser"])
		fireclickdetector(game.workspace.idk["Tool-Giver"].Part.ClickDetector)
	end)

	local mUpdate = Misc.AddButton("Update UI", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/0x00A7AFBC/amogussussysus/main/amogussy.lua"))();
	end)

	local jInfoLabel = Server.AddLabel("0 = infinite")

	local sJailTime = Server.AddSlider("Time", {Min = 0, Max = 1000, Def = 60}, function(v)
		options.Server["time"] = v
	end)

	local sJailAll = Server.AddButton("Jail all", function()
		for _,v in pairs(getPlayerList()) do
			print(v)
			--if v ~= game:GetService("Players").LocalPlayer.Name then
				game:GetService("ReplicatedStorage").CarbonEvents.ToJail:FireServer(v, options.Server["time"])
			--end
		end
	end)

	local sCLabel = Server.AddLabel("Click multible times to crash server and wait")

	local sCrash = Server.AddButton("Crash", function()
		fireclickdetector(game.workspace.idk["Tool-Giver"].Part.ClickDetector)
		local lPlayer = game:GetService("Players").LocalPlayer
		local char = lPlayer.Character
		local Humanoid

		if char  then
			Humanoid = char:FindFirstChild("Humanoid")
		end

		wait(2)

		Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack.USP)

		
		loadstring(s)()
	end)

	local iLabel = Info.AddLabel("Made with love by SkidHub")
	local iLabel2 = Info.AddLabel("Dev: Genycs")
	local iLabel3 = Info.AddLabel("SkidHub forever")
	local iLabel4 = Info.AddLabel("TAKE MY CUMSHOT")

end
loadUI()
--[[
local FirstLabel = FirstPage.AddLabel("Section 1")
local FirstButton = FirstPage.AddButton("Hello", function()
print("Hello")
end)
local FirstToggle = FirstPage.AddToggle("Hello", false, function(Value)
print(Value)
end)
local FirstSlider = FirstPage.AddSlider("Hello", {Min = 0, Max = 255, Def = 50}, function(Value)
print(Value)
end)
local FirstPicker = FirstPage.AddColourPicker("Hello", "white", function(Value)
print(Value)
end)
local FirstDropdown = FirstPage.AddDropdown("Hello", {
"Hello",
"Goodbye"
}, function(Value)
print(Value)
end)
]]--
