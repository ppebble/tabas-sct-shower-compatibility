# Verification - 2026-09-27

## Source evidence

- Node metadata/scope/publication-gate contracts: PASS.
- Java compilation and installed Project Zomboid Kahlua execution: PASS.
- Actual TABAS 42.20 body-location module and utils loaded into the test VM.
- Eight Guardian bodies protected with accessory options off and ignore-options on.
- Ordinary skirt, tactical shirt, hair accessory and unrelated earring removable.
- Existing towel exception preserved; repeat registration adds no duplicates.
- Missing API/table cases return safely.
- Guardian body definitions covered: 8/8.
- Negative control disabling registration fails at the expected eight-body assertion.
- All PowerShell scripts parse; staged Git whitespace check passes.

## Local installation / draft staging

- `C:\Users\ask13\Zomboid\mods\TABASSCTCompatibility`: source hashes match.
- `C:\Users\ask13\Zomboid\Workshop\TABASSCTCompatibility`: source hashes match.
- Upstream Dispatch: 428 files copied unchanged into the local mods directory.
- Upstream Guardian: 1967 files copied unchanged into the local mods directory.
- All upstream local-copy file hashes match SteamCMD downloads. They are not
  included in this repository or the compatibility mod's upload directory.
- If later subscribing through Steam, avoid stale duplicate local SCT copies;
  these local copies do not auto-update. Do not mix different client/server builds.

## Server / preset

- Created `Server/b42204-sct.ini` and three matching companion Lua files.
- Base `b42204.ini` hash unchanged by configuration script.
- All settings except Mods, WorkshopItems, PublicName and network ports match.
- SandboxVars, spawnpoints and spawnregions hashes match the original.
- Preserved original preset records and backed up the preset file.
- `b42204-sct` Mod Manager record exactly matches server mod order (241 IDs).
- Removed active IDs: 4123567854998, 2DWSkinAdapterFix,
  TABAS2DWCompatibility, 2DWTranslationKR.
- Added ShadowCatTacticsDispatch, ShadowCatTacticsGuardian,
  TABASSCTCompatibility. Other mods/order retained, including 42_VSGirlBodySFW.
- Ports: 16265 / 16266; RCON 27017. Existing server ports unchanged.
- Created dedicated-server launcher and desktop shortcut for `b42204-sct`.
- No production save copied or modified; no server was started.

## Not verified / not performed

Live server startup, Workshop server download, client connection, live
body/clothing rendering, bath/shower completion and cancellation, two-client
replication, reconnect and save safety are not established by the tests above.
No Steam upload, public release, Required Items editing or author permission
request was performed. Draft artwork is pending.

## Follow-up: SCT-only body configuration

User correction: the SCT test environment must not enable VS alongside SCT's
own body system. Removed `42_VSGirlBodySFW` and Workshop `3640496116` from
`b42204-sct.ini`, after a timestamped backup. Server now has 240 enabled IDs.
The only observed VS-dependent patch, 2DWSkinAdapterFix, was already excluded.
The original b42204 and user-edited singleplayer preset hashes are unchanged.
Updated future clone generation to exclude VS. Deployment checks with
`-ServerOnly`, Kahlua tests and metadata contracts pass. Preset parity checks
were explicitly skipped because singleplayer presets are now user-managed.
No runtime compatibility claim or server restart is implied.

## Artwork and friends-only upload preparation

User-supplied Desktop/tabas+sct/poster.png (512x512) and preview.png (256x256)
were copied without modification; each is below 1 MiB. Source, local poster,
staged poster/preview and metadata hashes match. Added poster=poster.png.
Description follows the existing TABAS+2DW page structure but describes SCT's
exact full-type protection and does not inherit its in-game testing claims.
Visibility is friendsOnly (supported by installed WorkshopSubmitScreen.lua:302);
ID remains blank for manual first upload. No Steam upload was performed.
Required Items must be added manually for 3592172476, 3689462578, 3609052036.
Metadata/artwork contracts, Kahlua suite and whitespace checks pass.
The historical server-clone comparison now fails at line 63 due to external
configuration drift; no server or singleplayer preset was changed in this task.
This does not affect package hash verification. Public release permission and
live gameplay validation remain separate requirements.
