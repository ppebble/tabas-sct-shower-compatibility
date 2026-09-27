# Upstream review - 2026-09-27

Official originals were downloaded anonymously with SteamCMD, outside this
repository under the workspace `.omx/tools/steamcmd/steamapps/workshop/content/108600`.
Both downloads report OK in `logs/workshop_log.txt` (the self-updating launcher
returned exit 1 despite successful downloads; definitions and files were checked).

Sources:
- https://steamcommunity.com/sharedfiles/filedetails/?id=3689462578
- https://steamcommunity.com/sharedfiles/filedetails/?id=3609052036
- https://steamcommunity.com/sharedfiles/filedetails/?id=3592172476

Dispatch manifest: `8831938054840579640`.
Guardian manifest: `1023418538371587811`.

## Direct evidence

Guardian `common/mod.info` requires `ShadowCatTacticsDispatch`.
Each of these Guardian `common/media/scripts/clothing/<name>.txt` files defines
an item in module Base with `BodyLocation = base:ears`:

- FemaleBodyT512 / FemaleBodyT2048
- FemaleBodyR18T512 / FemaleBodyR18T2048
- MaleBodyT512 / MaleBodyT2048
- BodyWithHeadgear512 / BodyWithHeadgear2048

These are all eight ear-slot definitions in the examined release. BodyconSkirt,
hair accessories, helmets and tactical shirts are ordinary clothing, not body
variants. Dispatch's `LingLi_AutoTransparentSkin.lua:990-997` separately lists
the six female/male body types in its character creation body selector.

Installed TABAS 42.20 `media/lua/shared/NPCs/TABAS_BodyLocations.lua` exposes
`Exclude.FullType`. `TABAS_Utils.canAutoUnequipClothing` checks that table before
accessory options and location-based rules. Adding exact full types therefore
works even when the user disables accessory preservation and avoids making
every ear-slot item permanently non-removable.

## Decision and limits

Only the public full-type exclusion table is extended. No inventory mutation,
timed-action replacement, skin restoration, renderer hook or network message is
introduced. Ordinary clothing behavior remains upstream-controlled, not forced.
The shared Lua executes in both client and server contexts.

The author requests prior permission for public dependent mods. A draft private
package is prepared but not published. Native skin/hair customization and
Dispatch transmog variants beyond these body item IDs are not newly implemented.
SP/MP bath/shower rendering, cancellation and reconnect require live validation.
