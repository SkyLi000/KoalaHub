local HttpService = game:GetService("HttpService")
---@diagnostic disable: undefined-global

if not getgenv().TotalServers then
    getgenv().TotalServers = 0
    getgenv.TotalServersMerchant = 0
    getgenv().ItemsBought = 0
end

spawn(function()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local FoundAnything = ""
    local ActualHOur = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if FoundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100"))()
        else
            Site = game.HttpService:JSONDecode(game:HttpService("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor="..FoundAnything))()
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			FoundAnything = Site.nextPageCursor
		end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayer) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(ActualHOur) ~= tonumber(Existing) then
                            local delfile = pcall(function()
                                delfile("KoalaHub/PetSimX_MerchantHop.json")
                                AllIDs = {}
                                table.insert(AllIDs, ActualHOur)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible==true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile("KoalaHub/PetSimX_MerchantHop.json", game:GetService("HttpService"):JSONEncode(AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    function Teleport()
		while wait() do
			pcall(function()
				TPReturner()
				if FoundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local console = loadstring(game:HttpGet("https://raw.githubusercontent.com/SkyLi000/PetSimXScripts/main/Console.lua"))()
console.clear()
console.log("New Server Joined: Loading Script")

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
        getgenv().TotalServers = ]]..TotalServers..[[
        getgenv().TotalServersMerchant = ]]..TotalServersMerchant..[[
        getgenv().ItemsBought = ]]..ItemsBought..[[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SkyLi000/PetSimXScripts/main/MerchantHop.lua"))()
    ]])
    Teleport()
end

console.new()
console.windowname('Merchant Hop')
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
				getgenv().ItemsBought = getgenv().ItemsBought + 1
			end
		end
	end

    getgenv().TotalServers = getgemv().TotalServers + 1
    getgenv().TotalServersMerchant = getgenv().TotalServersMerchant + 1
    useTeleport()
else
    console.formatcolors(" - &4Merchant Not Found")
    getgenv().TotalServers = getgenv().TotalServers + 1
    useTeleport()
end
