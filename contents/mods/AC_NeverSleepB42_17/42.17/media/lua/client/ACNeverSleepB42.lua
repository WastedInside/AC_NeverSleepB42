-- Tested on B42.17
-- Verified for B42.18

local function ResetFatigue()
    local player = getPlayer()

    if player then
        player:getStats():set(CharacterStat.FATIGUE, 0)
    end
end

Events.EveryTenMinutes.Add(ResetFatigue)


local function AddSleepOption(playerIndex, context, worldobjects, test)
    if test then return end

    local playerObj = getSpecificPlayer(playerIndex)
    if not playerObj then return end

    for _, obj in ipairs(worldobjects) do

        if instanceof(obj, "IsoObject") then

            local sprite = obj:getSprite()

            if sprite then
                local spriteName = sprite:getName()

                if spriteName then
                    spriteName = string.lower(spriteName)

                    -- bed detection
                    if string.find(spriteName, "bed")
                    or string.find(spriteName, "bedding")
                    or string.find(spriteName, "furniture_bedding") then

                        context:addOption(
                            "Sleep (Optional)",
                            obj,
                            function(bed)

                                -- temporarily allow sleeping
                                playerObj:getStats():set(CharacterStat.FATIGUE, 0.7)

                                ISWorldObjectContextMenu.onSleep(bed, playerIndex)
                            end
                        )

                        return
                    end
                end
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(AddSleepOption)