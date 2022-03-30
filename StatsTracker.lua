local Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
local Save = Library.Save.Get
local Commas = Library.Functions.Commas 
local Types = {} 
local Menus = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Right") 
for i, v in pairs(Menus:GetChildren()) do 
	if v.ClassName == 'Frame' and v.Name ~= 'Rank' and not string.find(v.Name, "2") then 
		table.insert(Types, v.Name) 
	end 
end 

function Get(ThisType) 
	return Save()[ThisType] 
end 
succ, err = pcall(function() 
	Menus["Diamonds"].LayoutOrder = 99988 
end)
if err then 
	print(err) 
end 
succ, err = pcall(function() 
	Menus['Rainbow Coins'].LayoutOrder = 99992 
end) 
if err then 
	print(err) 
end 
succ, err = pcall(function() 
	Menus['Tech Coins'].LayoutOrder = 99992 
end) 
if err then 
	print(err) 
end 
succ, err = pcall(function() 
	Menus['Gingerbread'].LayoutOrder = 99994 
end) 
if err then 
	print(err) 
end 
succ, err = pcall(function() 
	Menus['Fantasy Coins'].LayoutOrder = 99996 
end) 
if err then 
	print(err) 
end 
succ, err = pcall(function() 
	Menus.Coins.LayoutOrder = 99998 end) 
if err then 
	print(err) 
end 
Menus.UIListLayout.HorizontalAlignment = 2 
_G.MyTypes = {} 
for i,v in pairs(Types) do 
	if Menus:FindFirstChild(v.."2") then 
		Menus:FindFirstChild(v.."2"):Destroy() 
	end 
end 
local Oops = 0 
for i,v in pairs(Types) do 
	if not Menus:FindFirstChild(v.."2") then 
		Oops += 1 
		Menus:FindFirstChild(v).LayoutOrder = Oops 
		local tempmaker = Menus:FindFirstChild(v):Clone() 
		tempmaker.Name = tostring(tempmaker.Name .. "2") 
		tempmaker.Parent = Menus 
		tempmaker.Size = UDim2.new(0, 175, 0, 30) 
		tempmaker.LayoutOrder = tempmaker.LayoutOrder + 1 
		_G.MyTypes[v] = tempmaker 
	end 
end 
Menus.Diamonds2.Add.Visible = false 
for i,v in pairs(Types) do 
	spawn(function() 
		local megatable = {} 
		local imaginaryi = 1 
		local ptime = 0 
		local last = tick() 
		local now = last 
		local TICK_TIME = 0.5 
		while true do 
			if ptime >= TICK_TIME then 
				while ptime >= TICK_TIME do 
					ptime = ptime - TICK_TIME 
				end 
				local currentbal = get(v) 
				megatable[imaginaryi] = currentbal 
				local diffy = currentbal - (megatable[imaginaryi-120] or megatable[1]) 
				imaginaryi = imaginaryi + 1 
				_G.MyTypes[v].Amount.Text = tostring(Commas(diffy).." in 60s") 
				_G.MyTypes[v]["Amount_odometerGUIFX"].Text = tostring(Commas(diffy).." in 60s") 
			end 
			task.wait(0.001) 
			now = tick() 
			ptime = ptime + (now - last) 
			last = now 
		end 
	end) 
end
