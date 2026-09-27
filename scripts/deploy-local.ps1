param([string]$ZomboidRoot = (Join-Path $HOME 'Zomboid'))
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$install = Join-Path $ZomboidRoot 'mods\TABASSCTCompatibility'
$stage = Join-Path $ZomboidRoot 'Workshop\TABASSCTCompatibility'
$stagedMod = Join-Path $stage 'Contents\mods\TABASSCTCompatibility'
foreach ($destination in @($install,$stagedMod)) {
    if (Test-Path $destination) { throw "Refusing to overwrite existing deployment: $destination" }
}
foreach ($destination in @($install,$stagedMod)) {
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $repo 'common') -Destination $destination -Recurse
    # B42 recognizes the version directory; runtime content is shared in common.
    New-Item -ItemType Directory -Path (Join-Path $destination '42') -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $repo 'README.md') -Destination $destination
    foreach ($file in Get-ChildItem (Join-Path $repo 'common') -File -Recurse) {
        $relative = $file.FullName.Substring((Join-Path $repo 'common').Length).TrimStart('\')
        $installed = Join-Path $destination "common\$relative"
        if ((Get-FileHash $file.FullName).Hash -ne (Get-FileHash $installed).Hash) { throw "Hash mismatch: $relative" }
    }
}
Copy-Item -LiteralPath (Join-Path $repo 'workshop\workshop.txt') -Destination (Join-Path $stage 'workshop.txt')
Write-Output "PASS local/staging source hashes. Installed: $install"
Write-Output "Private draft staging: $stage (no artwork, no ID, not uploaded)"
