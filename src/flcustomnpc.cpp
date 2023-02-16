/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ScriptMgr.h"
#include "Player.h"
#include "Config.h"
#include "Chat.h"
#include "ScriptedGossip.h"

// Add player scripts
class FLCNPlayer : public PlayerScript
{
public:
    FLCNPlayer() : PlayerScript("FLCNPlayer") { }

    void OnLogin(Player* player) override
    {
        if (sConfigMgr->GetOption<bool>("flcn.Enable", true))
        {
            ChatHandler(player->GetSession()).SendSysMessage("This Server is running a custom npc module.");
        }
    }

    void OnPVPKill(Player* killer, Player* killed) {
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
};

class FLCNLevelUpCreature : public CreatureScript {
public:
    FLCNLevelUpCreature() : CreatureScript("FLCNLevelUpCreature") {}


    bool OnGossipSelect(Player* player, Creature* /*creature*/, uint32 /*sender*/, uint32 action) {
        if (sConfigMgr->GetOption<bool>("flcn.levelup.Enable", true)) {
            if (action == 1 && player->GetLevel() < 80) {
                player->GiveLevel(80);
                player->TeleportTo(727, 11585.527344, 12532.683594, -62.002, 5.136186);
                player->ModifyMoney(20000000);
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



    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) {
        if (sConfigMgr->GetOption<bool>("flcn.gurumaster.Enable", true)) {
            std::ostringstream ss;
            ss << "sender: " << sender << " , action: " << action;
            ChatHandler(player->GetSession()).SendSysMessage(ss.str().c_str());
            ClearGossipMenuFor(player);
            if (action == 1) {
                //fake tree
                creature->SummonGameObject(183492, -13237.378906, 272.936707, 21.856663, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                creature->SummonGameObject(183492, -13232.696289, 292.726685, 21.856663, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                creature->SummonGameObject(183492, -13182.932617, 253.628433, 21.856663, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                creature->SummonGameObject(183492, -13218.941406, 304.868369, 21.856663, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                creature->SummonGameObject(183492, -13195.192383, 307.406494, 21.856663, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                creature->SummonGameObject(183492, -13172.377930, 289.806458, 21.856663, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                creature->SummonGameObject(183492, -13169.080078, 268.401672, 21.856663, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                //camp fire
                creature->SummonGameObject(194534, -13206.650391, 274.483765, 21.857222, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                CloseGossipMenuFor(player);
            }
            else if (action == 2) {
                //elevator
                creature->SummonGameObject(183490, -13209.713867, 271.071564, 21.857899, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                CloseGossipMenuFor(player);
            }
            else if (action == 3) {
                //legion portalq
                creature->SummonGameObject(185589, -13209.713867, 271.071564, 21.857899, 90, 0, 0, 0, 0, 600, true, GO_SUMMON_TIMED_DESPAWN);
                Creature* mySummon = creature->SummonCreature(510006, -13209.713867, 271.071564, 24.857899, 0.0, TEMPSUMMON_TIMED_DESPAWN, 600000);
                mySummon->SetObjectScale(1.2);
                //Player* myTarget = mySummon->SelectNearestPlayer(25.0);
                //mySummon->_addAttacker(myTarget);
                CloseGossipMenuFor(player);
            }
        }
        return false;
    }
};


// Add all scripts in one
void AddFLCNScripts()
{
    new FLCNPlayer();
    new FLCNLevelUpCreature();
    new FLCNGuruMaster();
}
