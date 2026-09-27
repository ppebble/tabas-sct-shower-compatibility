param([string]$ZomboidRoot = (Join-Path $HOME 'Zomboid'), [switch]$Update)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$install = Join-Path $ZomboidRoot 'mods\TABASSCTCompatibility'
$stage = Join-Path $ZomboidRoot 'Workshop\TABASSCTCompatibility'
$stagedMod = Join-Path $stage 'Contents\mods\TABASSCTCompatibility'
foreach ($destination in @($install,$stagedMod)) {
    if ((Test-Path $destination) -and !$Update) { throw "Existing deployment: use -Update to refresh $destination" }
}
if ($Update -and (Test-Path (Join-Path $stage 'workshop.txt'))) {
    $metadata = [IO.File]::ReadAllText((Join-Path $stage 'workshop.txt'))
    if ($metadata -match '(?m)^id=\d+') { throw 'Published ID exists; reconcile source metadata before refreshing' }
    Copy-Item -LiteralPath (Join-Path $stage 'workshop.txt') -Destination (Join-Path $stage "workshop.txt.before-update-$(Get-Date -Format yyyyMMdd-HHmmss).bak")
}
foreach ($destination in @($install,$stagedMod)) {
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $repo 'common') -Destination $destination -Recurse -Force
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
Copy-Item -LiteralPath (Join-Path $repo 'workshop\preview.png') -Destination (Join-Path $stage 'preview.png') -Force
Write-Output "PASS local/staging source hashes. Installed: $install"
Write-Output "Friends-only upload staging: $stage (new item, no ID, not uploaded)"
