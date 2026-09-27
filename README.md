# TABAS + SCT Compatibility

Independent local-test mod `TABASSCTCompatibility` for Build 42.20.4.
Not published. No SCT/TABAS assets or source are bundled.

## Scope

Registers eight verified Guardian body full types in TABAS's
`Exclude.FullType` table. The bodies share `base:ears`; excluding that whole
slot would also affect unrelated accessories. Ordinary SCT clothing, armor,
hair accessories, and vanilla items remain under TABAS's existing policies.
Native hair and Dispatch's skin logic are not replaced or patched.

Dependencies, in order:

1. `ShadowCatTacticsDispatch` (Workshop `3689462578`)
2. `ShadowCatTacticsGuardian` (Workshop `3609052036`)
3. TABAS DepthMap component and `TakeABathAndShowerNew` (`3592172476`)
4. `TABASSCTCompatibility` (local mod, no Workshop ID)

If Lifestyle is present, retain its existing position before TABAS. Do not
add the 2DW compatibility mod to the SCT-only test preset.

## Commands

- `scripts/test.ps1`: executes Lua behavior tests in the installed game's Kahlua VM.
- `scripts/deploy-local.ps1`: installs only this mod and builds private draft staging.
- `scripts/configure-test-server.ps1`: clones b42204 into a separate SCT test server
  and matching Mod Manager preset, with backups and preservation checks.

SCT dependencies downloaded through SteamCMD are separate read-only upstream
copies, not part of this repository or upload. The test client needs both SCT
dependencies installed; every other client needs identical dependency versions
and this local compatibility mod until a permitted Workshop release exists.

## Test in game (not yet proven)

Start `StartServer64b42204-sct.bat`, connect to port 16265, and use a new test
character. Do not reuse a production save. Enable the `b42204-sct` preset.
Open Dispatch with `;`, select a Guardian body appropriate to the game's texture
setting (T512 or T2048), and equip ordinary SCT clothing.
Test shower and bath, completion and cancellation, death/reconnect, and a second
client observing body preservation and normal clothing restoration. Repeat male,
female and headgear body variants. Turn off TABAS's accessory-preservation option
to demonstrate the patch protects bodies independently of that setting.
Do not infer multiplayer rendering correctness from source tests or file hashes.

## Publication gate

The SCT author explicitly requests permission for dependent public mods. Obtain
permission before publishing, credit the author, and finish live SP/MP QA.
`workshop/workshop.txt` is private, has no ID, and is a draft. Artwork is not yet
provided. Steam Required Items must be configured separately on publication;
description links and `require=` do not create Workshop relationships.
