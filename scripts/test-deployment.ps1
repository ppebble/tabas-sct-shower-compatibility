param([string]$ZomboidRoot = (Join-Path $HOME 'Zomboid'))
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$server = Join-Path $ZomboidRoot 'Server'
$base = [IO.File]::ReadAllLines((Join-Path $server 'b42204.ini'))
$clone = [IO.File]::ReadAllLines((Join-Path $server 'b42204-sct.ini'))
$allowed = @('Mods','WorkshopItems','DefaultPort','UDPPort','RCONPort','PublicName')
if ($base.Count -ne $clone.Count) { throw 'INI line count changed' }
for($i=0; $i -lt $base.Count; $i++) {
    if($base[$i] -ne $clone[$i] -and ($base[$i] -split '=',2)[0] -notin $allowed) { throw "Unexpected difference at line $i" }
}
foreach($suffix in '_SandboxVars.lua','_spawnpoints.lua','_spawnregions.lua') {
    if((Get-FileHash (Join-Path $server "b42204$suffix")).Hash -ne (Get-FileHash (Join-Path $server "b42204-sct$suffix")).Hash) { throw "Clone mismatch $suffix" }
}
$baseMods = (($base | Where-Object {$_ -match '^Mods='}) -replace '^Mods=','') -split ';'
$mods = (($clone | Where-Object {$_ -match '^Mods='}) -replace '^Mods=','') -split ';'
$removed = @('4123567854998','2DWSkinAdapterFix','TABAS2DWCompatibility','2DWTranslationKR','Lifestyle2DWShowerCompatibility')
$added = @('ShadowCatTacticsDispatch','ShadowCatTacticsGuardian','TABASSCTCompatibility')
foreach($mod in $removed) { if($mod -in $mods) { throw "2DW dependency remains: $mod" } }
foreach($mod in $added) { if(@($mods | Where-Object {$_ -eq $mod}).Count -ne 1) { throw "Missing/duplicate $mod" } }
$unchangedBase = @($baseMods | Where-Object {$_ -notin $removed})
$unchangedClone = @($mods | Where-Object {$_ -notin $added})
if(($unchangedBase -join ';') -cne ($unchangedClone -join ';')) { throw 'Unrelated mod or ordering changed' }
$preset = [IO.File]::ReadAllText((Join-Path $ZomboidRoot 'Lua\pz_modlist_settings.cfg'))
$record = [regex]::Match($preset,'(?m)^b42204-sct:([^\r\n]*)').Groups[1].Value
if($record -cne ($mods -join ';')) { throw 'Preset/server mismatch' }
$backup = Get-ChildItem (Join-Path $ZomboidRoot 'Lua\pz_modlist_settings.cfg.before-sct-*.bak') | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if(!$backup -or !$preset.StartsWith([IO.File]::ReadAllText($backup.FullName))) { throw 'Original presets were altered' }
foreach($destination in @((Join-Path $ZomboidRoot 'mods\TABASSCTCompatibility'),(Join-Path $ZomboidRoot 'Workshop\TABASSCTCompatibility\Contents\mods\TABASSCTCompatibility'))) {
    if(!(Test-Path (Join-Path $destination '42'))) { throw 'B42 directory missing' }
    foreach($file in Get-ChildItem (Join-Path $repo 'common') -Recurse -File) {
        $relative=$file.FullName.Substring((Join-Path $repo 'common').Length).TrimStart('\')
        if((Get-FileHash $file.FullName).Hash -ne (Get-FileHash (Join-Path $destination "common\$relative")).Hash) { throw "Deployment mismatch $relative" }
    }
}
Write-Output "PASS server clone settings, 3 companion-file hashes, unrelated mod order, original presets, SCT preset/server parity, deployed patch hashes"
Write-Output "Enabled mods: $($mods.Count); new test save not copied from production"
