-- fl-customnpc: class / spell test area on map 13 "Testing" (TA-1, 2026-09-27). Data only, no client change.
--
-- .tele classtest -> the middle room of map 13 (floor z -423.22, flat, 848 x 848 yd; the ScottTest area of
-- ".tele test" is the smaller room 278 yd above, untouched). Layout (x north, y west; see the TA-1 report):
--   row 1  level row  x -200: Training Dummy L1 L10 L20 L30 L40 L50 L60 L70 L80 + Boss (L83, "??"),
--          west -> east, 50 yd apart, facing the boulevard
--   row 2  type row   x -340: Beast Dragonkin Demon Elemental Giant Undead Humanoid Mechanical (L80),
--          west -> east, 50 yd apart
--   boulevard x -270 between the rows (70 yd from each): teleport at y 230 (facing east), AoE pack
--          (8 x L80 on a 3.9 yd ring, ~3 yd apart) at y 150, the single heal dummy at y 0, the heal cluster
--          (5 on a 2.6 yd ring) at y -150; every group >= 70 yd from the next.
-- Spacing: 50 yd between single dummies clears every stock and Chapters-of-Azeroth splash (<= 15 yd), chain
--   jump (<= 12.5 yd) and cleave, and keeps the largest CoA caster-centred damage/debuff sphere (40 yd) off the
--   neighbour while the player stands at a dummy.
-- Hostile dummies: the stock Grandmaster's Training Dummy (31144, npc_training_dummy: never moves or attacks,
--   takes no damage, leaves combat 5 s after the last hit) with level / type / name changed.
-- Heal dummies: friendly (faction 35), SmartAI: out of combat every 10 s back to 50 % health (and at spawn);
--   RegenHealth 0 so they do not regenerate; type_flags CREATURE_TYPE_FLAG_TREAT_AS_RAID_UNIT, which the core
--   needs before a player may heal or buff a creature at all (Unit::_IsValidAssistTarget, PvC case) and which
--   makes chain heals and raid-wide heals/buffs include them (Unit::IsInRaidWith); party-only effects include
--   them only while the caster is in a 5-man party (Unit::IsInPartyWith).
-- game_tele 92001 "test": a pin with ScottTest's (817) exact position. ".tele <name>" takes an exact name first,
--   else the FIRST name containing the text in an unordered_map (ObjectMgr::GetGameTele) - with "ClassTest" in the
--   table, ".tele test" could otherwise land here instead of at ScottTest, depending on hash order.
-- Ids (registry share-public docs/World of Warcraft/06-custom-ids.md): NPC 920000-920020 (band 920000-920099),
--   spawn guid 8920000-8920031 (band 8920000-8920099), game_tele 92000-92001 (band 92000-92099).
-- Idempotent: every DELETE takes only this file's rows (entry/guid band AND this file's names/entries); a row of
-- anyone else in these bands is left alone and the INSERT then fails loudly instead of overwriting it.

-- templates (this file's names only), then their child rows once they are orphans
DELETE FROM `creature_template` WHERE `entry` BETWEEN 920000 AND 920020 AND `name` LIKE '%Training Dummy';
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 920000 AND 920020 AND `CreatureID` NOT IN (SELECT `entry` FROM `creature_template` WHERE `entry` BETWEEN 920000 AND 920020);
DELETE FROM `creature_template_movement` WHERE `CreatureId` BETWEEN 920000 AND 920020 AND `CreatureId` NOT IN (SELECT `entry` FROM `creature_template` WHERE `entry` BETWEEN 920000 AND 920020);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` BETWEEN 920000 AND 920020 AND `entryorguid` NOT IN (SELECT `entry` FROM `creature_template` WHERE `entry` BETWEEN 920000 AND 920020);
DELETE FROM `creature` WHERE `guid` BETWEEN 8920000 AND 8920031 AND `id` BETWEEN 920000 AND 920020;
DELETE FROM `game_tele` WHERE (`id` = 92000 AND `name` = 'ClassTest') OR (`id` = 92001 AND `name` = 'test');

-- creature_template: 31144's row, changed only where noted per line
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES
(920000, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 1', '', 0, 1, 1, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920001, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 10', '', 0, 10, 10, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920002, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 20', '', 0, 20, 20, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920003, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 30', '', 0, 30, 30, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920004, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 40', '', 0, 40, 40, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920005, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 50', '', 0, 50, 50, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920006, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 60', '', 0, 60, 60, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920007, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 70', '', 0, 70, 70, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920008, 0, 0, 0, 0, 0, 'Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920009, 0, 0, 0, 0, 0, 'Boss Training Dummy', 'Boss Level 83', '', 0, 83, 83, 2, 7, 0, 1, 1, 1, 1, 20, 3, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 4, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920010, 0, 0, 0, 0, 0, 'Beast Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920011, 0, 0, 0, 0, 0, 'Dragonkin Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920012, 0, 0, 0, 0, 0, 'Demon Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920013, 0, 0, 0, 0, 0, 'Elemental Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920014, 0, 0, 0, 0, 0, 'Giant Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920015, 0, 0, 0, 0, 0, 'Undead Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920016, 0, 0, 0, 0, 0, 'Humanoid Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920017, 0, 0, 0, 0, 0, 'Mechanical Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920018, 0, 0, 0, 0, 0, 'AoE Training Dummy', 'Level 80', '', 0, 80, 80, 2, 7, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 0.000187, 1, 1, 1, 0, 0, 1, -26, 262144, 'npc_training_dummy', 0),
(920019, 0, 0, 0, 0, 0, 'Heal Training Dummy', 'Single Target', '', 0, 80, 80, 2, 35, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 67108864, 0, 0, 0, 0, 0, 0, 0, 'SmartAI', 0, 1, 8.0, 1, 1, 1, 0, 0, 0, -26, 262144, '', 0),
(920020, 0, 0, 0, 0, 0, 'Heal Training Dummy', 'Group Heals', '', 0, 80, 80, 2, 35, 0, 1, 1, 1, 1, 20, 0, 0, 1, 2200, 2000, 1, 1, 1, 131072, 2048, 0, 0, 9, 67108864, 0, 0, 0, 0, 0, 0, 0, 'SmartAI', 0, 1, 8.0, 1, 1, 1, 0, 0, 0, -26, 262144, '', 0);

-- same display as 31144 (CreatureDisplayID 16074), rooted like 31144
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(920000, 0, 16074, 1, 1, 0),
(920001, 0, 16074, 1, 1, 0),
(920002, 0, 16074, 1, 1, 0),
(920003, 0, 16074, 1, 1, 0),
(920004, 0, 16074, 1, 1, 0),
(920005, 0, 16074, 1, 1, 0),
(920006, 0, 16074, 1, 1, 0),
(920007, 0, 16074, 1, 1, 0),
(920008, 0, 16074, 1, 1, 0),
(920009, 0, 16074, 1, 1, 0),
(920010, 0, 16074, 1, 1, 0),
(920011, 0, 16074, 1, 1, 0),
(920012, 0, 16074, 1, 1, 0),
(920013, 0, 16074, 1, 1, 0),
(920014, 0, 16074, 1, 1, 0),
(920015, 0, 16074, 1, 1, 0),
(920016, 0, 16074, 1, 1, 0),
(920017, 0, 16074, 1, 1, 0),
(920018, 0, 16074, 1, 1, 0),
(920019, 0, 16074, 1, 1, 0),
(920020, 0, 16074, 1, 1, 0);
INSERT INTO `creature_template_movement` (`CreatureId`, `Ground`, `Swim`, `Flight`, `Rooted`, `Chase`, `Random`, `InteractionPauseTimer`) VALUES
(920000, 1, 0, 0, 1, 0, 0, NULL),
(920001, 1, 0, 0, 1, 0, 0, NULL),
(920002, 1, 0, 0, 1, 0, 0, NULL),
(920003, 1, 0, 0, 1, 0, 0, NULL),
(920004, 1, 0, 0, 1, 0, 0, NULL),
(920005, 1, 0, 0, 1, 0, 0, NULL),
(920006, 1, 0, 0, 1, 0, 0, NULL),
(920007, 1, 0, 0, 1, 0, 0, NULL),
(920008, 1, 0, 0, 1, 0, 0, NULL),
(920009, 1, 0, 0, 1, 0, 0, NULL),
(920010, 1, 0, 0, 1, 0, 0, NULL),
(920011, 1, 0, 0, 1, 0, 0, NULL),
(920012, 1, 0, 0, 1, 0, 0, NULL),
(920013, 1, 0, 0, 1, 0, 0, NULL),
(920014, 1, 0, 0, 1, 0, 0, NULL),
(920015, 1, 0, 0, 1, 0, 0, NULL),
(920016, 1, 0, 0, 1, 0, 0, NULL),
(920017, 1, 0, 0, 1, 0, 0, NULL),
(920018, 1, 0, 0, 1, 0, 0, NULL),
(920019, 1, 0, 0, 1, 0, 0, NULL),
(920020, 1, 0, 0, 1, 0, 0, NULL);

-- heal dummies: SmartAI - out of combat, at once and then every 10 s: SMART_ACTION_SET_HEALTH_PCT 50 on self
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(920019, 0, 0, 0, 1, 0, 100, 0, 0, 0, 10000, 10000, 0, 0, 142, 50, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Heal Training Dummy - Out of Combat (at once, then every 10 s) - Set Health 50%'),
(920020, 0, 0, 0, 1, 0, 100, 0, 0, 0, 10000, 10000, 0, 0, 142, 50, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Heal Training Dummy - Out of Combat (at once, then every 10 s) - Set Health 50%');

-- spawns (stationary: MovementType 0, wander 0); heal dummies spawn at 50 % (RegenHealth 0 makes curhealth count)
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`, `CreateObject`, `Comment`) VALUES
(8920000, 920000, 13, 0, 0, 1, 1, 0, -200.000, 225.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L1'),
(8920001, 920001, 13, 0, 0, 1, 1, 0, -200.000, 175.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L10'),
(8920002, 920002, 13, 0, 0, 1, 1, 0, -200.000, 125.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L20'),
(8920003, 920003, 13, 0, 0, 1, 1, 0, -200.000, 75.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L30'),
(8920004, 920004, 13, 0, 0, 1, 1, 0, -200.000, 25.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L40'),
(8920005, 920005, 13, 0, 0, 1, 1, 0, -200.000, -25.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L50'),
(8920006, 920006, 13, 0, 0, 1, 1, 0, -200.000, -75.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L60'),
(8920007, 920007, 13, 0, 0, 1, 1, 0, -200.000, -125.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L70'),
(8920008, 920008, 13, 0, 0, 1, 1, 0, -200.000, -175.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row L80'),
(8920009, 920009, 13, 0, 0, 1, 1, 0, -200.000, -225.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: level row boss (L83, ??)'),
(8920010, 920010, 13, 0, 0, 1, 1, 0, -340.000, 175.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Beast'),
(8920011, 920011, 13, 0, 0, 1, 1, 0, -340.000, 125.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Dragonkin'),
(8920012, 920012, 13, 0, 0, 1, 1, 0, -340.000, 75.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Demon'),
(8920013, 920013, 13, 0, 0, 1, 1, 0, -340.000, 25.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Elemental'),
(8920014, 920014, 13, 0, 0, 1, 1, 0, -340.000, -25.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Giant'),
(8920015, 920015, 13, 0, 0, 1, 1, 0, -340.000, -75.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Undead'),
(8920016, 920016, 13, 0, 0, 1, 1, 0, -340.000, -125.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Humanoid'),
(8920017, 920017, 13, 0, 0, 1, 1, 0, -340.000, -175.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: type row Mechanical'),
(8920018, 920018, 13, 0, 0, 1, 1, 0, -266.100, 150.000, -423.22, 3.1416, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #1'),
(8920019, 920018, 13, 0, 0, 1, 1, 0, -267.242, 152.758, -423.22, 3.9270, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #2'),
(8920020, 920018, 13, 0, 0, 1, 1, 0, -270.000, 153.900, -423.22, 4.7124, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #3'),
(8920021, 920018, 13, 0, 0, 1, 1, 0, -272.758, 152.758, -423.22, 5.4978, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #4'),
(8920022, 920018, 13, 0, 0, 1, 1, 0, -273.900, 150.000, -423.22, 0.0000, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #5'),
(8920023, 920018, 13, 0, 0, 1, 1, 0, -272.758, 147.242, -423.22, 0.7854, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #6'),
(8920024, 920018, 13, 0, 0, 1, 1, 0, -270.000, 146.100, -423.22, 1.5708, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #7'),
(8920025, 920018, 13, 0, 0, 1, 1, 0, -267.242, 147.242, -423.22, 2.3562, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: AoE pack #8'),
(8920026, 920019, 13, 0, 0, 1, 1, 0, -270.000, 0.000, -423.22, 1.5708, 300, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: heal single'),
(8920027, 920020, 13, 0, 0, 1, 1, 0, -267.400, -150.000, -423.22, 3.1416, 300, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: heal cluster #1'),
(8920028, 920020, 13, 0, 0, 1, 1, 0, -269.197, -147.527, -423.22, 4.3982, 300, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: heal cluster #2'),
(8920029, 920020, 13, 0, 0, 1, 1, 0, -272.103, -148.472, -423.22, 5.6549, 300, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: heal cluster #3'),
(8920030, 920020, 13, 0, 0, 1, 1, 0, -272.103, -151.528, -423.22, 0.6283, 300, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: heal cluster #4'),
(8920031, 920020, 13, 0, 0, 1, 1, 0, -269.197, -152.473, -423.22, 1.8850, 300, 0, 0, 50400, 0, 0, 0, 0, 0, '', 0, 0, 'TA-1 class test area: heal cluster #5');

-- teleports: .tele classtest, and the pin that keeps .tele test at ScottTest
INSERT INTO `game_tele` (`id`, `position_x`, `position_y`, `position_z`, `orientation`, `map`, `name`) VALUES
(92000, -270, 230, -422.72, 4.71239, 13, 'ClassTest'),
(92001, -0.310414, 0.107129, -100.538, 2.94612, 13, 'test');
