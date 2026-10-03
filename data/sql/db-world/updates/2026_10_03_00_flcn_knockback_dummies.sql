-- fl-customnpc: knockback training dummies for the class test area on map 13 (TA-2, 2026-10-03). Data + the C++ AI
-- npc_fl_knockback_dummy (src/flcustomnpc.cpp); no client change.
--
-- The TA-1 dummies are rooted (creature_template_movement Rooted 1, like the stock 31144): Spell::EffectKnockBack
-- skips a target with UNIT_STATE_ROOT, so no knockback moves them. This entry can be knocked back:
--   Rooted 0; flags_extra 262144 (NO_SKILL_GAINS only - no CREATURE_FLAG_EXTRA_IMMUNITY_KNOCKBACK 0x40000000);
--   CreatureImmunitiesId 0 (31144's -26 is grip immunity, which belongs to a rooted dummy - a grip moves this one too);
--   rank 0, no BOSS_MOB type flag, type 9 Mechanical (EffectKnockBack also skips bosses and Giants).
-- Otherwise 920008's row (the L80 Training Dummy = 31144 at level 80): faction 7, PACIFIED, 2-3 HP that never drop.
-- The AI (npc_fl_knockback_dummy) is the stock npc_training_dummy's - never attacks, chases or turns, every hit set to
-- 0 damage, combat with an attacker ends 5 s after that attacker's last hit - plus: in combat it teleports back to
-- its spawn point and facing every 10 s, and when combat ends it evades and teleports home at once.
--
-- Layout: a 2 x 2 square, 50 yd sides (TA-1's spacing), centred on (-270, -320) at the east end of the boulevard,
--   facing west (pi/2, toward .tele classtest). >= 83.2 yd (2-D) from every other spawn on map 13 (the nearest: the
--   boss dummy), >= 79 yd from the room's east wall (y -424.3); a knockback carries a dummy ~19 yd (Thunderstorm
--   59159: 30 yd/s x 0.62 s), and the room is a closed box (Test.wmo), so nothing falls off.
-- Ids (registry share-public docs/World of Warcraft/06-custom-ids.md, band NPC 920000-920099, guid 8920000-8920099):
--   NPC 920021, spawn guids 8920032-8920035. Free on 2026-10-03 in the workbench world DB (creature_template and its
--   model/movement/addon tables, creature id and guid, smart_scripts, spell_dbc misc values, creature_addon,
--   creature_respawn), the server Spell.dbc misc values and every module source/SQL.
-- Idempotent: every DELETE takes only this file's rows (ids AND this file's name/entry); a foreign row in these ids is
-- left alone and the INSERT then fails loudly instead of overwriting it.

DELETE FROM `creature_template` WHERE `entry` = 920021 AND `name` = 'Knockback Training Dummy';
DELETE FROM `creature_template_model` WHERE `CreatureID` = 920021 AND `CreatureID` NOT IN (SELECT `entry` FROM `creature_template` WHERE `entry` = 920021);
DELETE FROM `creature_template_movement` WHERE `CreatureId` = 920021 AND `CreatureId` NOT IN (SELECT `entry` FROM `creature_template` WHERE `entry` = 920021);
DELETE FROM `creature` WHERE `guid` BETWEEN 8920032 AND 8920035 AND `id` = 920021;

-- 920008's row; changed: entry, name, CreatureImmunitiesId -26 -> 0, ScriptName npc_training_dummy -> npc_fl_knockback_dummy
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES
(920021, 0, 0, 0, 0, 0, 'Knockback Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, 0, 262144, 'npc_fl_knockback_dummy', 0);

-- same display as 31144 (CreatureDisplayID 16074); NOT rooted (Rooted 0), the one movement difference to TA-1's dummies
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(920021, 0, 16074, 1, 1, 0);
INSERT INTO `creature_template_movement` (`CreatureId`, `Ground`, `Swim`, `Flight`, `Rooted`, `Chase`, `Random`, `InteractionPauseTimer`) VALUES
(920021, 1, 0, 0, 0, 0, 0, NULL);

-- spawns (stationary: MovementType 0, wander 0); the spawn point is the home position the AI returns to
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`, `CreateObject`, `Comment`) VALUES
(8920032, 920021, 13, 0, 0, 1, 1, 0, -245.000, -295.000, -423.22, 1.5708, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-2 class test area: knockback dummy NW'),
(8920033, 920021, 13, 0, 0, 1, 1, 0, -295.000, -295.000, -423.22, 1.5708, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-2 class test area: knockback dummy SW'),
(8920034, 920021, 13, 0, 0, 1, 1, 0, -245.000, -345.000, -423.22, 1.5708, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-2 class test area: knockback dummy NE'),
(8920035, 920021, 13, 0, 0, 1, 1, 0, -295.000, -345.000, -423.22, 1.5708, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-2 class test area: knockback dummy SE');
