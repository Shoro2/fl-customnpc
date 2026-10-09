# Todo

- (medium) Operator decision: does production get the class test area (MIG-040, on hold; queue
  row "Class / spell test area on map 13")? `master` carries it since 2026-10-01
  (`fef3ed8`..`09eeb31`), so a host pull of `master` would install it; host kits pin `013f11a`
  until the decision. The queue row still names the merge into `master` as open.
- (low) Keep `tests/ta2_knockback_dummy.tbs` byte-identical to the copy in mod-woodworking
  `tests/` (the one the bot runner reads), or add `modules/fl-customnpc/tests` to
  `TestBots.ScenarioDirs` and drop the copy.
- (low) The README lists a Gurubashi kill-streak announcer and arena resurrection; both are
  commented out in `FLCNPlayer` and their table `fl_gurupvp` was never shipped. Revive them or
  remove them from code and README.
- (low) (suggestion) The Arena Master stands on the 727 hub but summons its props at map-0
  Gurubashi Arena coordinates on its own map, whispers a debug "sender/action" line and uses the
  Infernal summon without a null check. Move it to the arena, fix it, or retire it.
