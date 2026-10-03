# Custom NPC for Forgotten Land

[English](README.md)


## Includes

1. NPC to give player level 80 and starting stuff.
1. NPC that spawnes different structures in gurubashi arena.
1. Killing Spree announcement for gurubashi arena.
1. Ressurecting dead players in gurubashi arena.
1. A class / spell test area on map 13 (`.tele classtest`, data only): hostile training dummies by level
   (1, 10, ... 80 and a boss-level "??" one) and by creature type, an AoE pack of 8, and friendly heal dummies that
   fall back to 50 % health every 10 s (`data/sql/db-world/updates/2026_09_27_00_flcn_class_test_area.sql`).
1. Knockback training dummies in that test area (4 at the east end of the boulevard): not rooted, so knockbacks
   move them; the C++ AI `npc_fl_knockback_dummy` teleports them back to their spawn point every 10 s in combat and
   at once when combat ends (`data/sql/db-world/updates/2026_10_03_00_flcn_knockback_dummies.sql`, bot scenario
   `tests/ta2_knockback_dummy.tbs`).
