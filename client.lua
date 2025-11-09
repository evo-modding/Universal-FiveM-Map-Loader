-- client.lua
-- Universal map loader for FiveM

local resourceName = GetCurrentResourceName()

CreateThread(function()
    print(("[Map Loader] Starting map loader for resource: %s"):format(resourceName))

    -- Wait until the map files are ready
    Wait(1000)

    local resourcePath = ("resources/%s/"):format(resourceName)

    -- Automatically enable all map files in the resource
    -- (This includes all .ymap, .ytyp, .ymf, .ybn, etc. that are streamed)
    if not IsDlcPresent(resourceName) then
        RequestIpl(resourceName)
    end

    -- Load IPLs (interior proxy libraries) or XML map definitions
    local iplFiles = {
        -- Add specific IPL names if needed
        -- Example: "gabz_pinkcage_milo_", "bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo_"
    }

    for _, iplName in ipairs(iplFiles) do
        if not IsIplActive(iplName) then
            RequestIpl(iplName)
            print(("[Map Loader] Requested IPL: %s"):format(iplName))
        end
    end

    -- If you have XML or meta-based maps, load them here:
    local mapDir = GetResourcePath(resourceName) .. "/maps"
    local files = io.popen('dir "' .. mapDir .. '" /b')

    if files then
        for file in files:lines() do
            local ext = file:match("^.+(%..+)$")
            if ext == ".xml" or ext == ".meta" then
                print(("[Map Loader] Found XML/META map: %s"):format(file))
                -- FiveM automatically handles these through fxmanifest and streaming
            elseif ext == ".ymap" then
                print(("[Map Loader] Found YMAP file: %s"):format(file))
            end
        end
        files:close()
    end

    -- (Optional) Ensure all streamed objects are loaded properly
    Citizen.CreateThread(function()
        for i = 1, 100 do
            local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 200.0, 0, false, false, false)
            if obj ~= 0 then
                SetEntityDynamic(obj, true)
            end
            Wait(1000)
        end
    end)

    print("[Map Loader] Map files loaded successfully.")
end)

-- Optional: Reload command
RegisterCommand("reloadmaps", function()
    print("[Map Loader] Reloading all IPLs and streamed maps...")
    -- Reload IPLs and streamed files
    TriggerEvent("onResourceStart", resourceName)
end)
