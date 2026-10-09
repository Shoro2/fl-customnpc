# fl-customnpc

Custom NPC scripts from the old Forgotten Land fork, plus a class / spell test area. Players meet
**Sesame** ("Instant 80") on the Azealia hub (map 727): one gossip click takes a character below
80 to level 80, adds 2000 gold, completes quest 90154 "The Exobeast Land" and teleports it to a
fixed point on the hub. The **Arena Master** ("Terraforming") summons arena props (forest,
elevator, demon portal with an Infernal). Since 2026-09-27 the repo also holds a **test area on map 13**
(`.tele classtest`): training dummies by level and creature type, an AoE pack, heal dummies and
knockback dummies with their own AI. Full description: [README.md](README.md).

Why it shows up in the CoA program records: the test area was built as CoA work packages TA-1
and TA-2 (share-public `coa-classes/program-records/ta1-report.md`, `progress.md`) to test the 21
CoA classes' spells; dummy spacing follows the largest CoA spell radii. This repo was picked as
its home because the content is data-only module SQL plus one small AI.

## Ids and tables

| What | Id / name |
|---|---|
| Sesame | creature 8999948, ScriptName `FLCNLevelUpCreature`, gossip menu 62002; spawn guid 5300690 (map 727) |
| Arena Master | creature 8999949, ScriptName `FLCNGuruMaster`, gossip menu 62001; spawn guid 5300691 (map 727) |
| Infernal | creature 510006 (CombatAI), summoned by the demon portal option |
| Arena props | stock GameObjects 183492 (tree), 194534 (camp fire), 183490 (elevator), 185589 (demon portal) |
| Quest | 90154 "The Exobeast Land" (FL world content) |
| Test area NPCs | 920000-920020 (TA-1, `npc_training_dummy`; heal dummies 920019/920020 SmartAI), 920021 Knockback Training Dummy (TA-2, `npc_fl_knockback_dummy`) |
| Test area rows | creature guids 8920000-8920035 on map 13; `game_tele` 92000 `ClassTest`, 92001 `test` |
| Reserved bands | NPC 920000-920099, guid 8920000-8920099, `game_tele` 92000-92099 (share-public `06-custom-ids.md`) |
| FL DB twin | creature 62500 "Sesame" (old-server entry, same ScriptName, gossip 62500, no spawn on the workbench) |

Tables: none of its own. The module SQL writes `creature_template`, `creature_template_model`,
`creature_template_movement`, `gossip_menu`, `gossip_menu_option`, `creature`, `smart_scripts` and
`game_tele` rows. The hub spawns of Sesame and the Arena Master come from the July 2026 content
migration, not from this repo. `fl_gurupvp` (Gurubashi kill streaks) appears only in
commented-out code and was never shipped.

## Status and progress

- **Where it runs**: workbench at `master` (test area applied 2026-09-27, knockback dummies
  2026-10-03). Host: pinned at `013f11a` (Sesame and Arena Master, since the first deploy
  2026-07-13). The test area is MIG-040, **on hold**: production gets it only if the operator
  decides so; the HOST-2 and HOST-4 kits kept `013f11a` on purpose.
- **Evidence**: module test pass incl. Sesame T2 (user-confirmed 2026-07-13); TA-1 test area T2
  (operator, all 8 checks, 2026-09-27); TA-2 knockback dummies T1, bot run 313 PASS 30/0
  (2026-10-03).
- **Done**:
  - Port to the current AzerothCore API (2026-07-09); base data moved to the modern SQL path
    (`013f11a`, 2026-07-11).
  - TA-1 test area, heal dummies made Humanoid so heals land (2026-09-27).
  - TA-2 knockback dummies with `npc_fl_knockback_dummy` (2026-10-03).

## Next steps

1. Operator decision whether production gets the test area (queue row "Class / spell test area on
   map 13", MIG-040). `master` carries it since 2026-10-01, so any host pull of `master` would
   install it; keep host kits on `013f11a` until then.
2. Keep `tests/ta2_knockback_dummy.tbs` identical to its copy in mod-woodworking `tests/`, which
   is the one the bot runner reads (scenario header) - or add this folder to
   `TestBots.ScenarioDirs` and drop the copy.
3. README lists the Gurubashi kill-streak announcer and arena resurrection, which are commented
   out in `FLCNPlayer`; revive or drop them (todo).

Open points in full: [todo.md](todo.md).

## Working here

- Branch `claude/<topic>-<sessionId>`, merge into `master` and push (project rule: no pull requests).
- Data changes go into a new dated file in `data/sql/db-world/updates/`; the worldserver
  updater applies it at the next start (no build). C++ changes need a worldserver build
  (`C:\wowstuff\dcore_bin`). Restart the workbench only with
  `C:\wowstuff\ForgottenLand2.0\scripts\worldserver_restart.ps1`. The legacy `sql/world/base/`
  files are never applied.
- New ids must stay inside the bands above and be registered in share-public
  `docs/World of Warcraft/06-custom-ids.md`; the test-area SQL deletes only its own rows.
- Host-relevant changes need a MIG entry in share-public
  `docs/World of Warcraft/forgotten-land/15-host-migration-log.md`.
- Vault: `forgotten-land/06-fl-modules.md`, `12-server-todo.md`, MIG-040 in
  `forgotten-land/15-host-migration-log.md`, `coa-classes/program-records/ta1-report.md`,
  `testing/01-test-bots.md`.
- Doc set: [INDEX.md](INDEX.md), CLAUDE.md, [data_structure.md](data_structure.md),
  [functions.md](functions.md), [log.md](log.md) (newest first), [todo.md](todo.md).
