# Data structure

## Files

| Path | What |
|---|---|
| `src/flcustomnpc.cpp` | `FLCNPlayer` (all hooks commented out), `FLCNLevelUpCreature` (Sesame), `FLCNGuruMaster` (Arena Master), `npc_fl_knockback_dummy` (TA-2) |
| `src/flcn_loader.cpp` | `Addfl_customnpcScripts()` -> `AddFLCNScripts()` |
| `conf/flcustomnpc.conf.dist` | `flcn.*` keys (below) |
| `data/sql/db-world/base/flcn_base.sql` | Sesame 8999948, Arena Master 8999949, Infernal 510006, their models, gossip menus 62001/62002 (DELETE + INSERT) |
| `data/sql/db-world/updates/2026_09_27_00_flcn_class_test_area.sql` | TA-1: templates 920000-920020 (+ model, movement), spawns 8920000-8920031 on map 13, heal-dummy SmartAI, `game_tele` 92000/92001 |
| `data/sql/db-world/updates/2026_10_03_00_flcn_knockback_dummies.sql` | TA-2: template 920021 (not rooted), spawns 8920032-8920035 |
| `tests/ta2_knockback_dummy.tbs` | mod-fl-testbots scenario for 920021; an identical copy lives in mod-woodworking `tests/` |
| `sql/world/base/flcn_levelup_base.sql`, `flcn_pvpevent.sql` | legacy versions of the base data (old columns); never applied |
| `sql/README.md`, `sql/world/updates/.gitkeep` | skeleton leftovers |
| `README.md` | feature list; `README_ES.md`, `README_example.md` are skeleton templates |
| `include.sh`, `conf/conf.sh.dist`, `.git_commit_template.txt`, `setup_git_commit_template.sh` | AzerothCore skeleton leftovers |
| `.github/workflows/core-build.yml` | CI: AzerothCore's reusable module build |

## Tables touched (acore_world)

| Table | Rows |
|---|---|
| `creature_template` (+ `_model`) | 8999948, 8999949, 510006, 920000-920021 |
| `creature_template_movement` | 920000-920021 (TA-1 rooted, 920021 not rooted) |
| `gossip_menu` / `gossip_menu_option` | menus 62001 (no DB options; the script adds them), 62002 ("I want to LevelUP") |
| `creature` | guids 8920000-8920035 (map 13) |
| `smart_scripts` | heal dummies 920019, 920020 |
| `game_tele` | 92000 `ClassTest`, 92001 `test` |

No characters or auth tables.

## Config keys (`conf/flcustomnpc.conf.dist`)

| Key | Dist / workbench | Read by |
|---|---|---|
| `flcn.levelup.Enable` | 1 / 1 | Sesame's gossip action |
| `flcn.gurumaster.Enable` | 1 / 1 | Arena Master's gossip action |
| `flcn.Enable`, `flcn.pvpevent.Enable`, `flcn.portonrelease.Enable` | 1 / 1 | commented-out code only (no effect) |

The test area has no config key.
