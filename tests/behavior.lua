local exclusions = modules["NPCs/TABAS_BodyLocations"].Exclude
local originals = {}
for key, value in pairs(exclusions.FullType) do originals[key] = value end
local locations = #exclusions.BodyLocations
applyPatch()
applyPatch()
local count = 0
for key in pairs(exclusions.FullType) do if not originals[key] then count = count + 1 end end
assert(count == 8, "exactly eight bodies; reload must be idempotent")
assert(#exclusions.BodyLocations == locations, "no broad slot exclusion")
for key, value in pairs(originals) do assert(exclusions.FullType[key] == value) end

local utils = modules.TABAS_Utils
utils.ModOptionsValue = function() return false end
local function item(fullType, location)
    return {
        isHidden = function() return false end,
        getBodyLocation = function() return location end,
        getAttachmentReplacement = function() return nil end,
        getFullType = function() return fullType end,
        getAttachmentsProvided = function() return nil end,
    }
end
for key in pairs(exclusions.FullType) do
    if not originals[key] then
        assert(not utils.canAutoUnequipClothing(item(key, ItemBodyLocation.EARS), false))
        assert(not utils.canAutoUnequipClothing(item(key, ItemBodyLocation.EARS), true))
    end
end
assert(utils.canAutoUnequipClothing(item("Base.UnrelatedEarring", ItemBodyLocation.EARS), false))
assert(utils.canAutoUnequipClothing(item("Base.BodyconSkirt", "base:pants"), false))
assert(utils.canAutoUnequipClothing(item("Base.AEM01TacticalShirt1", "base:jacket"), false))
assert(utils.canAutoUnequipClothing(item("Base.GothicStyleCatEarHairAccessories", "base:hat"), false))
assert(not utils.canAutoUnequipClothing(item("Base.TowelHat", "base:hat"), false))
modules["NPCs/TABAS_BodyLocations"] = nil
applyPatch()
modules["NPCs/TABAS_BodyLocations"] = { Exclude = {} }
applyPatch()
modules["NPCs/TABAS_BodyLocations"] = { Exclude = { FullType = false } }
applyPatch()
print("PASS eight bodies, ordinary clothing/accessories, existing policy, repeat load, missing API")
