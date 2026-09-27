param(
    [string]$GameRoot = 'C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid',
    [string]$TabasRoot = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\108600\3592172476\mods\Take A Bath And Shower New\42.20',
    [string]$GuardianRoot = (Join-Path $PSScriptRoot '..\..\.omx\tools\steamcmd\steamapps\workshop\content\108600\3609052036\mods\ShadowCatTacticsGuardian\common'),
    [string]$Javac = 'C:\Users\ask13\.jdks\ms-21.0.8\bin\javac.exe'
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$build = Join-Path $repo '.build'
New-Item -ItemType Directory -Path $build -Force | Out-Null
$patch = Get-Content (Join-Path $repo 'common\media\lua\shared\TABASSCTCompatibility.lua') -Raw
$bodyIds = [regex]::Matches($patch, '"Base\.([A-Za-z0-9]+)"') | ForEach-Object { $_.Groups[1].Value }
if ($bodyIds.Count -ne 8) { throw 'Expected eight explicit body IDs' }
foreach ($id in $bodyIds) {
    $definition = Get-Content (Join-Path $GuardianRoot "media\scripts\clothing\$id.txt") -Raw
    if ($definition -notmatch "item\s+$id\s*\{" -or $definition -notmatch 'BodyLocation\s*=\s*base:ears,') {
        throw "Guardian body contract changed: $id"
    }
}
$allEarBodies = @(Get-ChildItem (Join-Path $GuardianRoot 'media\scripts\clothing') -Filter '*.txt' | Where-Object {
    (Get-Content $_.FullName -Raw) -match 'BodyLocation\s*=\s*base:ears,'
} | ForEach-Object BaseName)
if (Compare-Object ($bodyIds | Sort-Object) ($allEarBodies | Sort-Object)) { throw 'Review new or removed Guardian ear-slot items' }
$lua = Get-Content (Join-Path $repo 'tests\bootstrap.lua') -Raw
foreach ($entry in @(@('NPCs/TABAS_BodyLocations','NPCs\TABAS_BodyLocations.lua'), @('TABAS_Utils','TABAS_Utils.lua'))) {
    $source = Get-Content (Join-Path $TabasRoot "media\lua\shared\$($entry[1])") -Raw
    $lua += "`nmodules['$($entry[0])'] = (function()`n$source`nend)()`n"
}
$lua += "`nfunction applyPatch()`n$patch`nend`n"
$lua += Get-Content (Join-Path $repo 'tests\behavior.lua') -Raw
$suite = Join-Path $build 'suite.lua'
[IO.File]::WriteAllText($suite, $lua, (New-Object Text.UTF8Encoding $false))
& $Javac -d $build (Join-Path $repo 'tests\KahluaTest.java')
if ($LASTEXITCODE -ne 0) { throw 'Java compilation failed' }
Push-Location $GameRoot
try {
    & "$GameRoot\jre64\bin\java.exe" -cp "$build;$GameRoot\projectzomboid.jar" KahluaTest $suite
    if ($LASTEXITCODE -ne 0) { throw 'Kahlua tests failed' }
} finally { Pop-Location }
Write-Output 'PASS installed Guardian definition coverage (8/8)'
