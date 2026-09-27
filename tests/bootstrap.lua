modules = {}
function require(name) return modules[name] end
function isDebugEnabled() return false end
function instanceof() return false end
function isAutoClothesChangeExcludedFullType() return false end
TABAS_BodyLocation = { BodyGrime = "grime", BodyShampoo = "shampoo" }
BodyLocations = { getGroup = function() return { getOrCreateLocation = function() end } end }
ItemBodyLocation = setmetatable({}, { __index = function(_, key) return key end })
modules.TABAS_GameTimes = {}
