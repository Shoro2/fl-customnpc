# Functions

All scripts are registered by `AddFLCNScripts()` in `src/flcustomnpc.cpp`.

## Scripts

| Script (ScriptName) | Kind | What |
|---|---|---|
| `FLCNPlayer` | PlayerScript | registered, but every hook is commented out: a login line, `OnPlayerReleasedGhost` in zone 33 (resurrect and port into the Gurubashi Arena) and `OnPVPKill` in area 2177 (kill-streak announcements, kills/deaths in `fl_gurupvp`) |
| `FLCNLevelUpCreature` | CreatureScript, `OnGossipSelect` | Sesame (8999948; also the FL DB's 62500) |
| `FLCNGuruMaster` | CreatureScript, `OnGossipHello` + `OnGossipSelect` | Arena Master (8999949) |
| `npc_fl_knockback_dummy` | `RegisterCreatureAI` (NullCreatureAI) | Knockback Training Dummy 920021 |

The TA-1 dummies use the core's `npc_training_dummy`; the two heal dummies run SmartAI.

## Sesame (`FLCNLevelUpCreature`)

The gossip window is DB menu 62002 ("I want to LevelUP"); the script only handles the choice.
With `flcn.levelup.Enable` (default true):

- action 1 and level below 80: `GiveLevel(80)`, `ModifyMoney(20000000)` (2000 gold),
  `CompleteQuest(90154)`, `TeleportTo(727, 13350.215, 11989.907, -24.998, 1.343)`.
- level 80: system message "You are already level 80, if you need help ask a GM."

## Arena Master (`FLCNGuruMaster`)

`OnGossipHello` adds three options, each behind an "Are you sure?" box: Spawn Forest (1), Spawn
Elevator (2), Spawn Demon Portal (3). `OnGossipSelect` (with `flcn.gurumaster.Enable`) first
sends the player a debug line "sender: X , action: Y", then:

| Action | Summons (600 s) |
|---|---|
| 1 | seven trees GO 183492 + camp fire GO 194534 |
| 2 | elevator GO 183490 |
| 3 | demon portal GO 185589 + Infernal 510006 at scale 0.2 (timed despawn 10 min) |

The coordinates are hard-coded Gurubashi Arena positions (x about -13200, y about 270, the
map-0 arena), but `SummonGameObject` / `SummonCreature` place them on the NPC's own map; the
NPC's only spawn is on map 727. The Infernal summon result is used without a null check.

## Knockback Training Dummy (`npc_fl_knockback_dummy`)

- Every hit is set to 0 damage; it never attacks, chases or turns.
- Per attacker a 5 s combat timer (`COMBAT_HOLD`): direct hits and hostile spells refresh it, DoT
  ticks do not; a pet's hit refreshes its owner's timer; combat with that attacker ends when it
  runs out.
- In combat it `NearTeleportTo`s its home position and facing every 10 s (`RETURN_EVERY`).
- When combat ends it evades and teleports home at once (no walk back).
- The template is not rooted and has no knockback immunity, so knockbacks move it; the TA-1
  dummies are rooted and do not move.

## Test area layout (map 13, `.tele classtest`)

From the SQL headers: the middle room of map 13 (floor z -423.22, 848 x 848 yd, below the
ScottTest room of `.tele test`). Level row at x -200 (L1, L10 ... L80, boss L83, 50 yd apart),
type row at x -340 (eight creature types, L80), boulevard at x -270 with the teleport point
(y 230), the AoE pack of 8 (y 150), the single heal dummy (y 0) and the heal cluster of 5
(y -150); the four knockback dummies form a 50 yd square centred on (-270, -320). The 50 yd
spacing keeps every stock and CoA splash, chain jump, cleave and 40 yd caster sphere off the
neighbour. `game_tele` 92001 `test` pins ScottTest's position so `.tele test` keeps working.

## SQL behaviour

- `flcn_base.sql`: DELETE + INSERT of its own entries; re-runnable.
- Test-area files: every DELETE matches the id band and this file's names/entries, so a foreign
  row in the band survives and the INSERT then fails loudly instead of overwriting it.

## Bot scenario

`tests/ta2_knockback_dummy.tbs` (party with a shaman, Thunderstorm 59159, Lightning Bolt 49238):
knocked back, home within 10 s while in combat, home at once on evade, the rooted L80 dummy
920008 does not move. Run 313 PASS 30/0 (2026-10-03). The runner reads the copy in
mod-woodworking `tests/`; `modules/fl-customnpc/tests` is not in `TestBots.ScenarioDirs`
(workbench, 2026-10-09).
