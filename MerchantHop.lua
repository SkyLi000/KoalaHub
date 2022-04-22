if not getgenv().totalServers then
	getgenv().totalServers = 0
    getgenv().totalServersMerchant = 0
    getgenv().itemsBought = 0
end

spawn(function()
	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	function Teleport()
		wait(5)
		game:GetService("TeleportService"):Teleport(6284583030, game.Players.LocalPlayer)
	end)
    end
end)


if not game:IsLoaded() then
    game.Loaded:Wait()
end
local console = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lve/SynapseXConsole/main/maine.lua"))()
console.clear()
console.log('New Server Joined. Waiting For Script To Load')
local Lib = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not Lib.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end

nextTeleport = queue_on_teleport or syn.queue_on_teleport

function useTeleport()
    console.newline()
    console.newline()
    console.log('Teleporting To New Server')
    nextTeleport([[
		getgenv().mode = ]]..mode..[[
        getgenv().totalServers = ]]..totalServers..[[
        getgenv().totalServersMerchant = ]]..totalServersMerchant..[[
        getgenv().itemsBought = ]]..itemsBought..[[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SkyLi000/KoalaHub/main/MerchantHop.lua"))()
    ]])
    Teleport()
end


console.new()
console.windowname('Merchant Hop Created By 4lve#0001')
console.clear()

console.log("Server Info:")
console.newline()
console.formatcolors(" - Current Job ID: &a"..game.JobId)
console.newline()
console.formatcolors(" - Total Servers Joined: &a"..totalServers)
console.newline()
console.formatcolors(" - Total Servers With Merchant: &a"..totalServersMerchant)
console.newline()
console.formatcolors(" - Total Pets Bought: &a"..itemsBought)
console.newline()
console.newline()
console.log("Activity:")
console.newline()

if (Lib.Network.Invoke("get merchant items")["Level 3"]) then
    console.formatcolors(" - &aMerchant Found")
	if (getgenv().mode == 1) then
		notOutOfStock = true
		while notOutOfStock do
			notOutOfStock = Lib.Network.Invoke("buy merchant item", 3)
			if notOutOfStock then
				console.newline()
				console.formatcolors(" - &aMerchant Pet Bought")
				getgenv().itemsBought = getgenv().itemsBought + 1
			end
		end
	else

		for i,v in pairs(Lib.Network.Invoke("get merchant items")) do
			if ((v.petId == "288") and v.petExtra.r) then
				notOutOfStock = Lib.Network.Invoke("buy merchant item", tonumber(i:split(" ")[2]))
				if notOutOfStock then
					console.newline()
					console.formatcolors(" - &aBought Rainbow Santa Paws")
					getgenv().itemsBought = getgenv().itemsBought + 1
				end
			end
		end

	end
    getgenv().totalServers = getgenv().totalServers + 1
    getgenv().totalServersMerchant = getgenv().totalServersMerchant + 1
    useTeleport()
else
    console.formatcolors(" - &4Merchant Not Found")
    getgenv().totalServers = getgenv().totalServers + 1
    useTeleport()
end
