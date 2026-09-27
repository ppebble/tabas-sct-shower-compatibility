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
