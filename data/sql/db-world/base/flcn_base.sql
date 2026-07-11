-- fl-customnpc base data, ported to the current AC schema.
-- Source: sql/world/base/flcn_levelup_base.sql + flcn_pvpevent.sql
-- (modelid1-4/scale -> creature_template_model; trainer_*/immune-mask
--  columns were dropped upstream). Idempotent via DELETE+INSERT.

-- === flcn_levelup_base.sql ===
DELETE FROM `creature_template` WHERE `entry`=8999948;
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES (8999948, 0, 0, 0, 0, 0, 'Sesame', 'Instant 80', 'Speak', 62002, 80, 80, 2, 35, 1, 1, 1.14286, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 'FLCNLevelUpCreature', 0);
DELETE FROM `creature_template_model` WHERE `CreatureID`=8999948;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES (8999948, 0, 17, 1, 1, 0);
DELETE FROM `gossip_menu` WHERE `MenuID`=62002;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (62002, 1);
DELETE FROM `gossip_menu_option` WHERE `MenuID`=62002;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES (62002, 0, 0, 'I want to LevelUP', 1, 1);

-- === flcn_pvpevent.sql ===
DELETE FROM `gossip_menu` WHERE `MenuID`='62001';
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES ('62001', '1');
DELETE FROM `creature_template` WHERE `entry`=8999949;
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES (8999949, 0, 0, 0, 0, 0, 'Arena Master', 'Terraforming', 'Speak', 62001, 80, 80, 2, 35, 1, 1, 1.14286, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 'FLCNGuruMaster', 0);
DELETE FROM `creature_template_model` WHERE `CreatureID`=8999949;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES (8999949, 0, 22541, 1, 1, 0);
DELETE FROM `creature_template` WHERE `entry`=510006;
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES (510006, 0, 0, 0, 0, 0, 'Infernal', '', '', 0, 80, 80, 0, 21, 0, 1, 1.14286, 1, 1, 25, 1, 0, 20, 2500, 2500, 1, 1, 1, 0, 2048, 0, 40, 6, 0, 0, 0, 0, 0, 0, 0, 0, 'CombatAI', 1, 1, 25, 1, 1, 1, 0, 0, 1, 0, '', 0);
DELETE FROM `creature_template_model` WHERE `CreatureID`=510006;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES (510006, 0, 7950, 0.5, 1, 0);

