function santitise(string)
    return string:gsub('%@', '')
end

exports('sanitise', function(string)
    sanitise(string)
end)

RegisterNetEvent('discordLogs')
AddEventHandler('discordLogs', function(message, colour, channel)
    discordLog(message, colour, channel)
end)

for k, v in pairs(Config.Colours) do
	if string.find(v,"#") then
		Config.Colours[k] = tonumber(v:gsub("#",""),16)
	else
		Config.Colours[k] = v
	end
end

--Serversided Export:
exports('discord', function(message, id, id2, colour, channel, super)
--[[
    print("Debug: ")
    print("Message : ".. message)
    print("ID: ".. id)
    print("ID2: ".. id2)
    print("Colour: ".. colour)
    print("Channel: ".. channel)
    print("Super: ".. tostring(super)) ]]
    local _message = message

    if message == nil then print("^1Export Error: Message was nil.^0") return end
    if id == nil or id == "PLAYER_ID" or not tonumber(id) then print("^1Export Error: Invalid Player ID.^0") return end
    if id2 == nil or id2 == "PLAYER_2_ID" or not tonumber(id) then print("^1Export Error: Invalid 2nd Player ID.^0") return end
    if colour == nil then print("^1Export Error: Invalid Colour.^0") return end
    if channel == nil or channel == "" then print("^1Export Error: Invalid Channel.^0") return end
    if super == nil then print("^1Export Error: Super boolean not found.^0") return end

    -- Check if Colour is Hex or decimal
    if string.find(colour, '#') then _colour = tonumber(colour:gsub("#",""),16) else _colour = colour end

    if id2 ~= 0 then 
        if not super then
            TwoPlayerLog(message, _colour, id, id2, channel)
        else
            SuperTwoPlayerLog(message, _colour, id, id2, channel)
        end
    else
        if not super then
            RegularLog(message, _colour, id , channel)
        else 
            SuperLog(message, _colour, id, channel)
        end
    end
end)

function RegularLog(message, colour, field1, channel)
    local PlayerDetails = SimpleGetPlayerDetails(field1)
    PerformHttpRequest(Config.WebHooks[channel], function(error, text, headers) end, 'POST', json.encode({
        username = Config.Username,
        embeds = {{
            ["color"] = Config.Colours[colour],
            ["author"] = {
                ["name"] = Config.CommunityName,
                ["icon_url"] = Config.CommuntiyLogo
            },
            ["title"] = GetTitle(channel),
            ["description"] = "".. message .. "",
            ["footer"] = {
                ["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
            },
            ["fields"] = {
                {
                    ["name"] = "Player Details: " .. GetPlayerName(field1),
                    ["value"] = PlayerDetails,
                    ["inline"] = true
                }
            },
        }},
        avatar_url = Config.Avatar
    }), {
        ["Content-Type"] = "application/json"
    })
end

function SuperLog(message, colour, field1, channel)
    local PlayerDetails = AdminGetPlayerDetails(field1)
    --print(PlayerDetails)
    --print("Channel: " .. Config.WebHooks[channel])
    PerformHttpRequest(Config.WebHooks[channel], function(error, text, headers) end, "POST", json.encode({
        useranme = Config.Username,
        embeds = {{
            ["color"] = Config.Colours[colour],
            ["author"] = {
                ["name"] = Config.CommunityName,
                ["icon_url"] = Config.CommuntiyLogo
            },
            ["title"] = GetTitle(channel),
            ["description"] = "".. message .. "",
            ["footer"] = {
                ["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
            },
            ["fields"] = {
                {
                    ["name"] = "Player Details: " .. GetPlayerName(field1),
                    ["value"] = PlayerDetails,
                    ["inline"] = true
                }
            },
        }},
        avatar_url = Config.Avatar
    }), {
        ["Content-Type"] = "application/json"
    })
end

function SuperTwoPlayerLog(message, colour, field1, field2, channel)
    local PlayerDetails = AdminGetPlayerDetails(field1)
    local PlayerDetails2 = AdminGetPlayerDetails(field2)
    PerformHttpRequest(Config.WebHooks[channel], function(err, text, headers) end, 'POST', json.encode({
        username = Config.Username,
        embeds = {{
            ["color"] = Config.Colours[colour],
            ["author"] = {
                ["name"] = Config.CommunityName,
                ["icon_url"] = Config.CommuntiyLogo
            },
            ["title"] = GetTitle(channel),
            ["description"] = "".. message .. "",
            ["footer"] = {
                ["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
            },
            ["fields"] = {
                {
                    ["name"] = "Player Details: "..GetPlayerName(field1),
					["value"] = PlayerDetails,
					["inline"] = true
				},
				{
					["name"] = "Player Details: "..GetPlayerName(field2),
					["value"] = PlayerDetails2,
					["inline"] = true
				}
            },            
        }},
        avatar_url = Config.Avatar
    }), {
        ["Content-type"] = "application/json"
    })    
end

function TwoPlayerLog(message, colour, field1, field2, channel)
    local PlayerDetails = SimpleGetPlayerDetails(field1)
    local PlayerDetails2 = SimpleGetPlayerDetails(field2)
    PerformHttpRequest(Config.WebHooks[channel], function(err, text, headers) end, 'POST', json.encode({
        username = Config.Username,
        embeds = {{
            ["color"] = Config.Colours[colour],
            ["author"] = {
                ["name"] = Config.CommunityName,
                ["icon_url"] = Config.CommuntiyLogo
            },
            ["title"] = GetTitle(channel),
            ["description"] = "".. message .. "",
            ["footer"] = {
                ["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
				["icon_url"] = Config.FooterIcon,
            },
            ["fields"] = {
                {
                    ["name"] = "Player Details: "..GetPlayerName(field1),
					["value"] = PlayerDetails,
					["inline"] = true
				},
				{
					["name"] = "Player Details: "..GetPlayerName(field2),
					["value"] = PlayerDetails2,
					["inline"] = true
				}
            },            
        }},
        avatar_url = Config.Avatar
    }), {
        ["Content-type"] = "application/json"
    })
end

AddEventHandler("playerConnecting", function(name, setReason, deferrals)
    RegularLog('**' ..GetPlayerName(source).. '** is connecting to the server', 'Connecting', source, 'Connecting')
    SuperLog('**'..GetPlayerName(source)..'** is connecting to the server', 'Connecting', source, 'Super')
end)

AddEventHandler("playerDropped", function(reason)
    RegularLog("**"..GetPlayerName(source).."** has left the server. (Reason: "..reason..')', 'Disconnecting', source, 'Disconnecting')
    SuperLog("**"..GetPlayerName(source).."** has left the server. (Reason: "..reason..')', 'Disconnecting', source, 'Super')
end)

AddEventHandler("chatMessage", function(source, name, msg)
    RegularLog("**" .. santitise(GetPlayerName(source)) .. "**: `"..msg.."`", 'Chat', source, 'Chat')
end)

RegisterServerEvent('playerDied')
AddEventHandler('playerDied', function(id, player, killer, DeathReason, Weapon)
    if Weapon == nil then _Weapon = "" else _Weapon = "`"..Weapon.."`" end
    if id == 1 then
        RegularLog("**"..GetPlayerName(source) .. "** `"..DeathReason.."` ".._Weapon, 'Death', source, 'Death')
    elseif id == 2 then
		TwoPlayerLog('**' .. GetPlayerName(killer) .. '** '..DeathReason..' ' .. GetPlayerName(source).. ' `('.._Weapon..')`', 'Death', killer, source, 'Death') -- sending to deaths channel
	else -- When gets killed by something else
        RegularLog('**' .. GetPlayerName(source) .. '** `died`', 'Death', source, 'Death') -- sending to deaths channel
	end
end)

RegisterServerEvent('ClientDiscord')
AddEventHandler('ClientDiscord', function(message, id, id2, colour, channel, super)
    local _message = message

    if message == nil then print("^1Export Error: Message was nil.^0") return end
    if id == nil or id == "PLAYER_ID" or not tonumber(id) then print("^1Export Error: Invalid Player ID.^0") return end
    if id2 == nil or id2 == "PLAYER_2_ID" or not tonumber(id) then print("^1Export Error: Invalid 2nd Player ID.^0") return end
    if colour == nil then print("^1Export Error: Invalid Colour.^0") return end
    if channel == nil or channel == "" then print("^1Export Error: Invalid Channel.^0") return end
    if super == nil then print("^1Export Error: Super boolean not found.^0") return end

        if string.find(colour, '#') then _colour = tonumber(color:gsub('#',''),16) else _colour = colour end
    
    if id2 ~= 0 then 
        if not super then
            TwoPlayerLog(message, _colour, id, id2, channel)
        else
            SuperTwoPlayerLog(message, _colour, id, id2, channel)
        end
    else
        if not super then
            RegularLog(message, _colour, id , channel)
        else 
            SuperLog(message, _colour, id, channel)
        end
    end
end)

function SimpleGetPlayerDetails(src)
    local PlayerID = src
    local ids = ExtractIdentifiers(PlayerID)
    local postal = getPlayerLocation(PlayerID)
    _postal = "\n**Nearest Postal:** "..postal .. ""
    if ids.discord ~= "" then _discordID = "\n**Discord ID: ** <@"..ids.discord:gsub("discord:", "")..">" else _discordID = "\n**Discord ID:** N/A" end
    if ids.steam ~= "" then _steamID = "\n**Steam ID: ** " .. ids.steam.."" else _steamID = "\n**Steam ID: ** N/A" end
    if ids.steamURL ~= "" then _steamURL = "\n**Steam URL: ** https://www.steamcommunity.com/profiles/".. tonumber(ids.steam:gsub("steam:", ""),16).."" else _steamURL = "\n**Steam URL: ** NA" end 
    if PlayerID ~= "" then _playerID = "\n**Player Server ID:** "..PlayerID.."" else _playerID = "" end
    return _playerID .. ''.._postal..''.._discordID..''.._steamID..''.._steamURL..''
end

function AdminGetPlayerDetails(src)
    local PlayerID = src
    local ids = ExtractIdentifiers(PlayerID)
    local postal = getPlayerLocation(PlayerID)
    _postal = "\n**Nearest Postal:** "..postal .. ""
    if ids.discord ~= "" then _discordID = "\n**Discord ID: ** <@"..ids.discord:gsub("discord:", "")..">" else _discordID = "\n**Discord ID:** N/A" end
    if ids.steam ~= "" then _steamID = "\n**Steam ID: ** " .. ids.steam.."" else _steamID = "\n**Steam ID: ** N/A" end
    if ids.steamURL ~= "" then _steamURL = "\n**Steam URL: ** https://www.steamcommunity.com/profiles/".. tonumber(ids.steam:gsub("steam:", ""),16).."" else _steamURL = "\n**Steam URL: ** NA" end 
    if ids.license ~= "" then _license = "\n**License:** ".. ids.license else _license = "\n**License:** N/A" end
    if ids.ip ~= "" then _ip = "\n**IP:** " ..ids.ip else _ip = "\n**IP: ** N/A" end
    if PlayerID ~= "" then _playerID = "\n**Player Server ID:** "..PlayerID.."" else _playerID = "" end
    --print( _playerID .. ''.._postal..''.._discordID..''.._steamID..''.._steamURL..''.._license..''.._ip)
    return _playerID .. ''.._postal..''.._discordID..''.._steamID..''.._steamURL..''.._license..''.._ip
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

function getPlayerLocation(src)
    local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
    local postals = json.decode(raw)
    local nearest = nil

    local player = src
    local ped = GetPlayerPed(player)
    local playerCoords = GetEntityCoords(ped)

    local x, y = table.unpack(playerCoords)

    local ndm = -1
    local ni = -1

    local ndm = -1
    local ni = -1
    for i, p in ipairs(postals) do
        local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
        if ndm == -1 or dm < ndm then
            ni = i
            ndm = dm
        end
    end

    if ni ~= -1 then
        local nd = math.sqrt(ndm)
        nearest = {i = ni, d = nd}
    end
    _nearest = postals[nearest.i].code
    return _nearest
end

function GetTitle(channel)
	if Config.Icons[channel] then
		return Config.Icons[channel].." - "..firstToUpper(channel)
	else
		return "❓ "..firstToUpper(channel)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end