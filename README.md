# fl-customnpc

Custom NPCs for AzerothCore, plus a spell / class test area. Part of the Forgotten Land server project.

## Features

- **Sesame ("Instant 80")**, creature 8999948: one gossip click ("I want to LevelUP") takes a character below level 80
  to level 80, gives 2000 gold, completes quest 90154 and teleports the character to a fixed point on map 727.
  A character that is already level 80 gets a short message instead.
- **Arena Master ("Terraforming")**, creature 8999949: summons arena props for ten minutes, each behind an "Are you
  sure?" box: a forest (seven trees and a camp fire), an elevator, or a demon portal with a small Infernal (creature
  510006). The props use stock gameobjects 183492, 194534, 183490 and 185589 and are placed at hard-coded
  Gurubashi Arena coordinates on the map the NPC stands on.
- **Class / spell test area** on the stock test map 13 (data only, no code): hostile training dummies by level
  (1, 10, ... 80 and a boss-level one) and by creature type, a pack of eight for AoE tests, and friendly heal dummies
  that fall back to 50 % health every 10 seconds. Reach it with `.tele classtest`.
- **Knockback training dummies** in the test area (creature 920021, four of them): unlike the other dummies they are not
  rooted, so knockbacks move them. The C++ AI `npc_fl_knockback_dummy` sets every hit to 0 damage and teleports the
  dummy back to its spawn point every 10 seconds while in combat, and at once when combat ends.

## Requirements

- AzerothCore (WotLK 3.3.5a), current master. No extra core patches and no other modules are needed.
- Sesame teleports to map 727 (a custom hub map of Forgotten Land) and completes quest 90154. Both belong to the
  Forgotten Land world content and are **not** part of this module; on another server, change the target in
  `src/flcustomnpc.cpp` (function `FLCNLevelUpCreature::OnGossipSelect`) or Sesame will teleport to a map that does not
  exist.
- The test area uses the stock test map 13 and needs no client files of its own.

## Installation

1. Clone into the `modules/` folder of your AzerothCore source tree:
   ```
   cd azerothcore-wotlk/modules
   git clone https://github.com/Shoro2/fl-customnpc.git
   ```
2. Re-run CMake and rebuild the worldserver.
3. Copy `conf/flcustomnpc.conf.dist` to `flcustomnpc.conf` in the folder of your `worldserver.conf` (optional).
4. Start the worldserver. The AzerothCore updater imports the module SQL from `data/sql/db-world/` (the NPC templates
   and gossip menus, and the test area with its teleport entries). The old files under `sql/world/` are legacy copies
   and are not applied.

## Configuration

`conf/flcustomnpc.conf.dist`:

| Key | Default | Effect |
|---|---|---|
| `flcn.levelup.Enable` | 1 | Sesame works |
| `flcn.gurumaster.Enable` | 1 | the Arena Master's options work |
| `flcn.Enable`, `flcn.pvpevent.Enable`, `flcn.portonrelease.Enable` | 1 | not used by the current code (reserved for disabled features) |

## Usage

- The module does not spawn Sesame or the Arena Master. Add them where you want them with a GM account, for example
  `.npc add 8999948` and `.npc add 8999949`.
- Test area: `.tele classtest` takes a GM to the dummies on map 13; `.tele test` keeps working for the stock test room.
  Attack a dummy with the spell you want to test. Reserved id ranges: NPCs 920000-920099, creature guids
  8920000-8920099, `game_tele` 92000-92099.
- `tests/ta2_knockback_dummy.tbs` is a scenario for the `mod-fl-testbots` bot runner (not required to use the module).

## License

See the `LICENSE` file (MIT).
