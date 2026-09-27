param(
    [string]$ZomboidRoot = (Join-Path $HOME 'Zomboid'),
    [string]$DedicatedRoot = 'C:\Program Files (x86)\Steam\steamapps\common\Project Zomboid Dedicated Server',
    [string]$DesktopRoot = [Environment]::GetFolderPath('Desktop')
)
$ErrorActionPreference = 'Stop'
$name = 'b42204-sct'
$server = Join-Path $ZomboidRoot 'Server'
$source = Join-Path $server 'b42204.ini'
$target = Join-Path $server "$name.ini"
$preset = Join-Path $ZomboidRoot 'Lua\pz_modlist_settings.cfg'
$launcherSource = Join-Path $DedicatedRoot 'StartServer64b42204.bat'
$launcherTarget = Join-Path $DedicatedRoot "StartServer64$name.bat"
$suffixes = @('.ini','_SandboxVars.lua','_spawnpoints.lua','_spawnregions.lua')
foreach ($suffix in $suffixes) {
    if (!(Test-Path (Join-Path $server "b42204$suffix"))) { throw "Missing base $suffix" }
    if (Test-Path (Join-Path $server "$name$suffix")) { throw "Refusing to overwrite existing test configuration: $name$suffix" }
}
if (Test-Path $launcherTarget) { throw 'Test launcher already exists' }
if (Test-Path (Join-Path $ZomboidRoot "Saves\Multiplayer\$name")) { throw 'Test save already exists' }
$before = (Get-FileHash $source).Hash
$raw = [IO.File]::ReadAllText($source)
$presetRaw = [IO.File]::ReadAllText($preset)
if ($presetRaw -match '(?m)^b42204-sct:') { throw 'Test preset already exists' }
if ($presetRaw -notmatch '(?m)^b42204:') { throw 'Base Mod Manager preset missing' }
$launcher = [IO.File]::ReadAllText($launcherSource)
if ($launcher -notmatch '-servername b42204\b') { throw 'Unexpected base launcher' }
$remove = @('4123567854998','2DWTranslationKR','2DWSkinAdapterFix','TABAS2DWCompatibility','Lifestyle2DWShowerCompatibility')
$modsMatch = [regex]::Match($raw,'(?m)^Mods=([^\r\n]*)')
$workshopMatch = [regex]::Match($raw,'(?m)^WorkshopItems=([^\r\n]*)')
if (!$modsMatch.Success -or !$workshopMatch.Success) { throw 'Invalid base configuration' }
$mods = @($modsMatch.Groups[1].Value -split ';' | Where-Object { $_ -and $_ -notin $remove })
$tabasIndex = [Array]::IndexOf($mods,'TakeABathAndShowerNew')
if ($tabasIndex -lt 0) { throw 'TABAS is not enabled in base server' }
$newMods = New-Object 'System.Collections.Generic.List[string]'
foreach ($mod in $mods) {
    if ($mod -eq 'TakeABathAndShowerNew') {
        $newMods.Add('ShadowCatTacticsDispatch')
        $newMods.Add('ShadowCatTacticsGuardian')
    }
    $newMods.Add($mod)
    if ($mod -eq 'TakeABathAndShowerNew') { $newMods.Add('TABASSCTCompatibility') }
}
$removedWorkshop = @('3497748766','3778723972','3790696431','3789887641')
$workshop = @($workshopMatch.Groups[1].Value -split ';' | Where-Object { $_ -and $_ -notin $removedWorkshop })
$workshop += '3689462578','3609052036'
$values = @{
    Mods=($newMods -join ';'); WorkshopItems=($workshop -join ';')
    DefaultPort='16265'; UDPPort='16266'; RCONPort='27017'
    PublicName='B42204 SCT Compatibility Test'
}
foreach ($key in $values.Keys) {
    $pattern = '(?m)^' + $key + '=[^\r\n]*'
    if ($raw -notmatch $pattern) { throw "Missing configuration key $key" }
    $replacement = $key + '=' + $values[$key]
    $raw = [regex]::Replace($raw,$pattern,[System.Text.RegularExpressions.MatchEvaluator]{param($m) $replacement})
}
# Preserve passwords and all gameplay settings in the isolated clone; never print them.
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = "$preset.before-sct-$stamp.bak"
Copy-Item -LiteralPath $preset -Destination $backup
$utf8 = New-Object Text.UTF8Encoding $false
[IO.File]::WriteAllText($target,$raw,$utf8)
foreach ($suffix in $suffixes | Where-Object { $_ -ne '.ini' }) {
    Copy-Item -LiteralPath (Join-Path $server "b42204$suffix") -Destination (Join-Path $server "$name$suffix")
}
$newline = if ($presetRaw.Contains("`r`n")) { "`r`n" } else { "`n" }
$separator = if ($presetRaw.EndsWith("`n")) { '' } else { $newline }
[IO.File]::WriteAllText($preset,$presetRaw + $separator + "${name}:$($newMods -join ';')" + $newline,$utf8)
[IO.File]::WriteAllText($launcherTarget,($launcher -replace '-servername b42204\b',"-servername $name"),[Text.Encoding]::ASCII)
if ($DesktopRoot) {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $DesktopRoot "StartServer64$name.lnk"))
    $shortcut.TargetPath = $launcherTarget
    $shortcut.WorkingDirectory = $DedicatedRoot
    $shortcut.Description = 'Isolated SCT/TABAS test server - port 16265'
    $shortcut.Save()
}
if ((Get-FileHash $source).Hash -ne $before) { throw 'Base server changed unexpectedly' }
$cloneLines = [IO.File]::ReadAllLines($target)
$baseLines = [IO.File]::ReadAllLines($source)
if ($cloneLines.Count -ne $baseLines.Count) { throw 'Unexpected line count change' }
for ($i=0; $i -lt $baseLines.Count; $i++) {
    if ($baseLines[$i] -ne $cloneLines[$i] -and ($baseLines[$i] -split '=',2)[0] -notin $values.Keys) {
        throw "Unexpected configuration change at line $($i+1)"
    }
}
Write-Output "Created $name; ports 16265/16266, RCON 27017; original server unchanged."
Write-Output "Removed only 2DW family. Other mods, including 42_VSGirlBodySFW, retained."
Write-Output "Preset backup: $backup"
