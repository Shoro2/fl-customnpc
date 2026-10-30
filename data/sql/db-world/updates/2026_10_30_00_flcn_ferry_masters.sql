-- fl-customnpc: two ferry masters for the Port Blue Ocean ferry (map 727, gameobject 727400).
-- Each stands on its pier and tells a player when the ship docks or casts off (script FLCNFerryMaster reads the
-- transport's own path progress); the gossip text names the destination. Ids: creature 727410-727411, npc_text and
-- gossip menu 727410-727411, creature guids 7274000-7274001 (share-public 06-custom-ids). Idempotent.

DELETE FROM `creature_template` WHERE `entry` IN (727410, 727411);
INSERT INTO `creature_template` (`entry`, `name`, `subname`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`,
  `npcflag`, `speed_walk`, `speed_run`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `AIName`,
  `MovementType`, `HealthModifier`, `RegenHealth`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES
(727410, 'Dockmaster Hale', 'Ferry Master', 727410, 50, 50, 35, 1, 1, 1.14286, 0, 1, 768, 7, 0, '', 0, 1, 1, 2, 'FLCNFerryMaster', 12340),
(727411, 'Dockmaster Ulrik', 'Ferry Master', 727411, 50, 50, 35, 1, 1, 1.14286, 0, 1, 768, 7, 0, '', 0, 1, 1, 2, 'FLCNFerryMaster', 12340);

DELETE FROM `creature_template_model` WHERE `CreatureID` IN (727410, 727411);
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(727410, 0, 9073, 1, 1, 12340),
(727411, 0, 9073, 1, 1, 12340);

DELETE FROM `npc_text` WHERE `ID` IN (727410, 727411);
INSERT INTO `npc_text` (`ID`, `text0_0`, `BroadcastTextID0`, `lang0`, `Probability0`, `VerifiedBuild`) VALUES
(727410, 'Ahoy, $c! The ship at this pier sails to Kalu''thar Haven and back, round the clock. Board her through the gap in her rail when she lies alongside.', 0, 0, 1, 12340),
(727411, 'Ahoy, $c! The ship at this pier sails to Port Blue Ocean and back, round the clock. Board her through the gap in her rail when she lies alongside.', 0, 0, 1, 12340);

DELETE FROM `gossip_menu` WHERE `MenuID` IN (727410, 727411);
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES
(727410, 727410),
(727411, 727411);

-- Hale on the island's lowered pier beside the berth, Ulrik on Kalu'thar Haven's ferry dock (the Valgarde docks)
DELETE FROM `creature` WHERE `guid` IN (7274000, 7274001);
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`,
  `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`) VALUES
(7274000, 727410, 727, 0, 0, 1, 1, 0, 15196.0, 11016.0, 119.25, 1.571, 300, 0, 0, 1, 0, 0),
(7274001, 727411, 727, 0, 0, 1, 1, 0, 16550.5, 12435.5, 120.55, 0.0, 300, 0, 0, 1, 0, 0);
