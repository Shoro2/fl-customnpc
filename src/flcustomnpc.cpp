/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ScriptMgr.h"
#include "Player.h"
#include "Config.h"
#include "Chat.h"
#include "ScriptedGossip.h"
#include "Quests/QuestDef.h"
#include "CreatureScript.h"
#include "PassiveAI.h"
#include "MoveSpline.h"
#include "SpellInfo.h"
#include <unordered_map>

// Add player scripts
class FLCNPlayer : public PlayerScript
{
public:
    FLCNPlayer() : PlayerScript("FLCNPlayer") { }
    /*
    void OnPlayerLogin(Player* player) override
    {
        if (sConfigMgr->GetOption<bool>("flcn.Enable", true))
        {
            ChatHandler(player->GetSession()).SendSysMessage("This Server is running a custom npc module.");
        }
    }

    void OnPlayerReleasedGhost(Player* player) override {
        if (sConfigMgr->GetOption<bool>("flcn.portonrelease.Enable", true))
        {
            if (player->GetZoneId() == 33) {
                double roll = rand_chance();
                player->ResurrectPlayer(100, false);
                if(roll >= 50.0) player->TeleportTo(0, -13217.698242, 183.740921, 53.279888, 1.398887);
                else player->TeleportTo(0, -13270.440430, 212.779221, 52.390369, 0.723444);
            }
        }

    }
    
    void OnPVPKill(Player* killer, Player* killed) override {
        if (sConfigMgr->GetOption<bool>("flcn.pvpevent.Enable", true))
        {
            if (killed->GetAreaId() == 2177 && killer->GetName() != killed->GetName()) {
                std::ostringstream ss;
                ss << killer->GetName() << " has killed " << killed->GetName();
                sWorld->SendServerMessage(SERVER_MSG_STRING, ss.str().c_str());
                QueryResult qKiller = WorldDatabase.Query("SELECT spree FROM fl_gurupvp WHERE player= '{}'", killer->GetName());
                QueryResult qKilled = WorldDatabase.Query("SELECT spree FROM fl_gurupvp WHERE player= '{}'", killed->GetName());

                if (qKiller) {
                    WorldDatabase.Query("UPDATE fl_gurupvp SET kills = kills + 1, spree = spree + 1 WHERE player = '{}'", killer->GetName());
                    std::ostringstream ssa;
                    if ((*qKiller)[0].Get<uint32>() >= 15) {
                        ssa << killer->GetName() << " is fucking GODLIKE!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssa.str().c_str());
                        killer->SetHealth(killer->GetMaxHealth());
                        killer->SetMaxPower(killer->getPowerType(), killer->GetMaxPower(killer->getPowerType()));
                    }
                    else if ((*qKiller)[0].Get<uint32>() >= 10) {
                        ssa << killer->GetName() << " is dominating!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssa.str().c_str());
                        killer->SetHealth(killer->GetMaxHealth());
                        killer->SetMaxPower(killer->getPowerType(), killer->GetMaxPower(killer->getPowerType()));
                    }
                    else if ((*qKiller)[0].Get<uint32>() >= 7) {
                        ssa << killer->GetName() << " is unstoppable!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssa.str().c_str());
                        killer->SetHealth(killer->GetMaxHealth());
                    }
                    else if ((*qKiller)[0].Get<uint32>() >= 5) {
                        ssa << killer->GetName() << " is on rampage!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssa.str().c_str());
                    }
                    else if ((*qKiller)[0].Get<uint32>() >= 3) {
                        ssa << killer->GetName() << " is on a killing spree!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssa.str().c_str());
                    } 
                }
                else {
                    WorldDatabase.Query("INSERT INTO fl_gurupvp (player, kills, deaths, spree) VALUES ('{}',1,0,1)", killer->GetName());
                }

                if (qKilled) {
                    WorldDatabase.Query("UPDATE fl_gurupvp SET deaths = deaths + 1, spree = 0 WHERE player = '{}'", killed->GetName());
                    std::ostringstream ssb;
                    if ((*qKilled)[0].Get<uint32>() >= 15) {
                        ssb << killer->GetName() << " has ended " << killed->GetName() << "'s fucking GODLIKE spree!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssb.str().c_str());
                    }
                    else if ((*qKilled)[0].Get<uint32>() >= 10) {
                        ssb << killer->GetName() << " has ended " << killed->GetName() << "'s dominating spree!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssb.str().c_str());
                    }
                    else if ((*qKilled)[0].Get<uint32>() >= 7) {
                        ssb << killer->GetName() << " has ended " << killed->GetName() << "'s unstappable spree!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssb.str().c_str());
                    }
                    else if ((*qKilled)[0].Get<uint32>() >= 5) {
                        ssb << killer->GetName() << " has ended " << killed->GetName() << "'s rampage!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssb.str().c_str());
                    }
                    else if ((*qKilled)[0].Get<uint32>() >= 3) {
                        ssb << killer->GetName() << " has ended " << killed->GetName() << "'s killing spree!";
                        sWorld->SendServerMessage(SERVER_MSG_STRING, ssb.str().c_str());
                    }
                }
                else {
                    WorldDatabase.Query("INSERT INTO fl_gurupvp (player, kills, deaths, spree) VALUES ('{}', 0, 1, 0)", killed->GetName());
                }
            }
        }
    }
    */
};

class FLCNLevelUpCreature : public CreatureScript {
public:
    FLCNLevelUpCreature() : CreatureScript("FLCNLevelUpCreature") {}


    bool OnGossipSelect(Player* player, Creature* /*creature*/, uint32 /*sender*/, uint32 action) override {
        if (sConfigMgr->GetOption<bool>("flcn.levelup.Enable", true)) {
            if (action == 1 && player->GetLevel() < 80) {
                player->GiveLevel(80);
                player->ModifyMoney(20000000);
                player->CompleteQuest(90154);
                player->TeleportTo(727, 13350.215, 11989.907, -24.998, 1.343);
                
            }
            else if (player->GetLevel() == 80) {
                ChatHandler(player->GetSession()).SendSysMessage("You are already level 80, if you need help ask a GM.");
            }
        }
        return false;
    }
    
};

class FLCNGuruMaster : public CreatureScript {
public:
    FLCNGuruMaster() : CreatureScript("FLCNGuruMaster") {}

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        if (!player || !creature)
            return true;

        AddGossipItemFor(player, 4, "Spawn Forest", GOSSIP_SENDER_MAIN, 1, "Are you sure?", 0, false);
        AddGossipItemFor(player, 4, "Spawn Elevator", GOSSIP_SENDER_MAIN, 2, "Are you sure?", 0, false);
        AddGossipItemFor(player, 4, "Spawn Demon Portal", GOSSIP_SENDER_MAIN, 3, "Are you sure?", 0, false);
        SendGossipMenuFor(player, 1, creature);
        return true;
    }



    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override {
        if (sConfigMgr->GetOption<bool>("flcn.gurumaster.Enable", true)) {
            std::ostringstream ss;
            ss << "sender: " << sender << " , action: " << action;
            ChatHandler(player->GetSession()).SendSysMessage(ss.str().c_str());
            ClearGossipMenuFor(player);
            if (action == 1) {
                //fake tree
                creature->SummonGameObject(183492, -13237.378906, 272.936707, 21.856663, 90, 0, 0, 0, 0, 600, true);
                creature->SummonGameObject(183492, -13232.696289, 292.726685, 21.856663, 90, 0, 0, 0, 0, 600, true);
                creature->SummonGameObject(183492, -13182.932617, 253.628433, 21.856663, 90, 0, 0, 0, 0, 600, true);
                creature->SummonGameObject(183492, -13218.941406, 304.868369, 21.856663, 90, 0, 0, 0, 0, 600, true);
                creature->SummonGameObject(183492, -13195.192383, 307.406494, 21.856663, 90, 0, 0, 0, 0, 600, true);
                creature->SummonGameObject(183492, -13172.377930, 289.806458, 21.856663, 90, 0, 0, 0, 0, 600, true);
                creature->SummonGameObject(183492, -13169.080078, 268.401672, 21.856663, 90, 0, 0, 0, 0, 600, true);
                //camp fire
                creature->SummonGameObject(194534, -13206.650391, 274.483765, 21.857222, 90, 0, 0, 0, 0, 600, true);
                CloseGossipMenuFor(player);
            }
            else if (action == 2) {
                //elevator
                creature->SummonGameObject(183490, -13209.713867, 271.071564, 21.857899, 90, 0, 0, 0, 0, 600, true);
                CloseGossipMenuFor(player);
            }
            else if (action == 3) {
                //legion portalq
                creature->SummonGameObject(185589, -13209.713867, 271.071564, 21.857899, 90, 0, 0, 0, 0, 600, true);
                Creature* mySummon = creature->SummonCreature(510006, -13209.713867, 271.071564, 24.857899, 0.0, TEMPSUMMON_TIMED_DESPAWN, 600000);
                mySummon->SetObjectScale(0.2);
            }
        }
        return false;
    }
};

// Knockback Training Dummy (TA-2, class test area on map 13): a training dummy that knockback spells move.
//
// Like the stock npc_training_dummy (src/server/scripts/World/npcs_special.cpp) - a NullCreatureAI, so it never
// attacks, chases or turns to a victim; every hit is set to 0 damage; it leaves combat with an attacker 5 s after
// that attacker's last direct hit - but its template is not rooted and not knockback-immune, so a knockback moves it.
// Then, while it is in combat, it teleports back to its home position (spawn point and facing) every 10 s, and
// when its combat ends it evades and teleports home at once.
struct npc_fl_knockback_dummy : public NullCreatureAI
{
    static constexpr Milliseconds COMBAT_HOLD = 5s;   // the stock dummy's: no hit for 5 s ends combat with that attacker
    static constexpr Milliseconds RETURN_EVERY = 10s; // in combat: back to the home position every 10 s

    explicit npc_fl_knockback_dummy(Creature* creature) : NullCreatureAI(creature) { }

    void Reset() override
    {
        _combatTimer.clear();
        _inCombat = false;
        _returnTimer = RETURN_EVERY;
    }

    void JustEnteredCombat(Unit* who) override
    {
        _combatTimer[who->GetGUID()] = COMBAT_HOLD;
    }

    void DamageTaken(Unit* attacker, uint32& damage, DamageEffectType damageType, SpellSchoolMask /*schoolMask*/) override
    {
        damage = 0;

        if (!attacker || damageType == DOT)
            return;

        Hit(attacker);
    }

    // A knockback without damage (or any other hostile spell) keeps its caster's combat alive as a damaging hit does.
    void SpellHit(Unit* caster, SpellInfo const* spellInfo) override
    {
        if (!caster || !spellInfo || spellInfo->IsPositive())
            return;

        Hit(caster);
    }

    void UpdateAI(uint32 diff) override
    {
        // the stock dummy's per-attacker combat timers; a reference without a timer (combat that reached us without
        // JustEnteredCombat, e.g. through a pet) gets one too, so combat always ends 5 s after the last hit
        for (auto const& pveRef : me->GetCombatManager().GetPvECombatRefs())
            _combatTimer.try_emplace(pveRef.first, COMBAT_HOLD);

        for (auto itr = _combatTimer.begin(); itr != _combatTimer.end();)
        {
            itr->second -= Milliseconds(diff);
            if (itr->second <= 0s)
            {
                auto const& pveRefs = me->GetCombatManager().GetPvECombatRefs();
                auto it = pveRefs.find(itr->first);
                if (it != pveRefs.end())
                    it->second->EndCombat();

                itr = _combatTimer.erase(itr);
            }
            else
                ++itr;
        }

        if (me->IsInCombat())
        {
            if (!_inCombat)
            {
                _inCombat = true;
                _returnTimer = RETURN_EVERY;
            }
            else
            {
                _returnTimer -= Milliseconds(diff);
                if (_returnTimer <= 0s)
                {
                    ReturnHome();
                    _returnTimer = RETURN_EVERY;
                }
            }
        }
        else if (_inCombat)
        {
            _inCombat = false;
            EnterEvadeMode(EVADE_REASON_NO_HOSTILES); // combat is over: evade, which takes it home
        }
    }

    // NullCreatureAI ignores evading; this dummy cleans up as any evading creature does (CreatureAI::_EnterEvadeMode:
    // combat, evade auras, loot recipient) and then teleports home instead of walking there.
    void EnterEvadeMode(EvadeReason why) override
    {
        if (!_EnterEvadeMode(why))
            return;

        ReturnHome();

        // what HomeMovementGenerator<Creature>::DoFinalize does on arrival
        me->GetCombatManager().SetEvadeState(EVADE_STATE_NONE);
        me->ClearUnitState(UNIT_STATE_EVADE);
        Reset();
    }

private:
    void Hit(Unit* attacker)
    {
        if (me->GetCombatManager().IsInCombatWith(attacker))
            _combatTimer[attacker->GetGUID()] = COMBAT_HOLD;

        // Pet attacks engage the owner via propagation without firing JustEnteredCombat here, so track the owner's
        // timer too (as the stock dummy does).
        if (Unit* owner = attacker->GetCharmerOrOwner())
            if (me->GetCombatManager().IsInCombatWith(owner))
                _combatTimer[owner->GetGUID()] = COMBAT_HOLD;
    }

    // NearTeleportTo ends a knockback still in flight (Unit::DisableSpline) and sends the teleport to the clients.
    void ReturnHome()
    {
        Position const& home = me->GetHomePosition();
        float const turn = Position::NormalizeOrientation(me->GetOrientation() - home.GetOrientation());
        bool const facingHome = turn < 0.01f || turn > 2.0f * float(M_PI) - 0.01f;
        if (me->GetExactDist(&home) < 0.05f && facingHome && me->movespline->Finalized())
            return; // already there: nothing to send

        me->NearTeleportTo(home.GetPositionX(), home.GetPositionY(), home.GetPositionZ(), home.GetOrientation());
    }

    std::unordered_map<ObjectGuid, Milliseconds> _combatTimer;
    bool _inCombat = false;
    Milliseconds _returnTimer = RETURN_EVERY;
};

// Add all scripts in one
void AddFLCNScripts()
{
    new FLCNPlayer();
    new FLCNLevelUpCreature();
    new FLCNGuruMaster();
    RegisterCreatureAI(npc_fl_knockback_dummy);
}
