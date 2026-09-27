-- Original compatibility glue only. No SCT or TABAS implementation is bundled.
local bodyLocations = require "NPCs/TABAS_BodyLocations"
local exclusions = bodyLocations and bodyLocations.Exclude

if not exclusions or type(exclusions.FullType) ~= "table" then
    print("[TABASSCT] TABAS full-type exclusions unavailable; no changes applied")
    return
end

-- Guardian bodies share base:ears with ordinary accessories. Never exclude
-- the entire slot or all Guardian clothing. Keep this reviewed allowlist narrow.
local bodies = {
    "Base.FemaleBodyT512",
    "Base.FemaleBodyT2048",
    "Base.FemaleBodyR18T512",
    "Base.FemaleBodyR18T2048",
    "Base.MaleBodyT512",
    "Base.MaleBodyT2048",
    "Base.BodyWithHeadgear512",
    "Base.BodyWithHeadgear2048",
}

for index = 1, #bodies do
    exclusions.FullType[bodies[index]] = true
end

print("[TABASSCT] Protected 8 SCT Guardian body items for TABAS")
