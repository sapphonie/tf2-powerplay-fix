#include <sourcemod>
#include <tf2_stocks>

public Plugin myinfo =
{
    name        = "PowerPlay For Realz",
    author      = "stephanie",
    description = "type /pp to win game",
    version     = "0.0.2",
    url         = "https://steph.anie.dev/"
};


bool PowerPlay              [MAXPLAYERS + 1];
Handle g_hLaughTimer    [MAXPLAYERS + 1];

public OnPluginStart()
{
    RegAdminCmd("sm_pp", setPP, ADMFLAG_ROOT);

    AddNormalSoundHook(stopFlames);
}

public Action stopFlames
    (
        int clients[MAXPLAYERS],
        int& numClients,
        char sample[PLATFORM_MAX_PATH],
        int& entity,
        int& channel,
        float& volume,
        int& level,
        int& pitch,
        int& flags,
        char soundEntry[PLATFORM_MAX_PATH],
        int& seed
    )
{
    if  (
            // block flame noises for client
            StrContains(sample, "flame_engulf") != -1
            // block flame pain noises for client
            || StrContains(sample, "PainSharp") != -1
            // only mess with sounds if player is powerplayed
            && (PowerPlay[entity])
        )
    {
        return Plugin_Handled;
    }

    return Plugin_Continue;
}


public void OnPluginEnd()
{
    for (int client = 0; client < MaxClients + 1; client++)
    {
        if (IsValidClient(client) && PowerPlay[client])
        {
            TF2_RemoveCondition(client, TFCond_OnFire);                 // extinguishes player
            TF2_RemoveCondition(client, TFCond_Kritzkrieged);           // kritz
            TF2_RemoveCondition(client, TFCond_Ubercharged);            // uber
            TF2_RemoveCondition(client, TFCond_DefenseBuffed);          // battalion's backup
            TF2_RemoveCondition(client, TFCond_RegenBuffed);            // conch buff
            TF2_RemoveCondition(client, TFCond_Buffed);                 // buff banner
            TF2_RemoveCondition(client, TFCond_UberBulletResist);       // vacc bullet charge
            TF2_RemoveCondition(client, TFCond_UberBlastResist);        // vacc blast charge
            TF2_RemoveCondition(client, TFCond_UberFireResist);         // vacc fire charge
            //TF2_RemoveCondition(client, TFCond_MegaHeal);             // quick fix
            TF2_RemoveCondition(client, TFCond_OnFire);                 // fire
            // set player health to max overheal (give or take)
            SetEntityHealth(client, RoundToFloor(GetEntProp(client, Prop_Data, "m_iMaxHealth") * 1.5));

            PrintToChat(client, "Disabled PowerPlay on ALL!");
            if (g_hLaughTimer[client] != null)
            {
                LogMessage("Destroying powerplay timer");
                KillTimer(g_hLaughTimer[client]);
                g_hLaughTimer[client] = null;
            }
            PowerPlay[client] = false;
        }
    }
    LogMessage("unloaded pp.smx");
}

public Action setPP(client, args)
{
    if (!PowerPlay[client])
    {
        ReplyToCommand(client, "Enabled PowerPlay on self!");
        g_hLaughTimer[client] = CreateTimer(8.0, timer_Laugh, GetClientUserId(client), TIMER_REPEAT);
    }
    else if (PowerPlay[client])
    {
        ReplyToCommand(client, "Disabled PowerPlay on self!");
        TF2_RemoveCondition(client, TFCond_OnFire);                 // extinguishes player
        TF2_RemoveCondition(client, TFCond_Kritzkrieged);           // kritz
        TF2_RemoveCondition(client, TFCond_Ubercharged);            // uber
        TF2_RemoveCondition(client, TFCond_DefenseBuffed);          // battalion's backup
        TF2_RemoveCondition(client, TFCond_RegenBuffed);            // conch buff
        TF2_RemoveCondition(client, TFCond_Buffed);                 // buff banner
        TF2_RemoveCondition(client, TFCond_UberBulletResist);       // vacc bullet charge
        TF2_RemoveCondition(client, TFCond_UberBlastResist);        // vacc blast charge
        TF2_RemoveCondition(client, TFCond_UberFireResist);         // vacc fire charge
        //TF2_RemoveCondition(client, TFCond_MegaHeal);             // quick fix
        TF2_RemoveCondition(client, TFCond_OnFire);                 // fire
        // set player health to max overheal (give or take)
        SetEntityHealth(client, RoundToFloor(GetEntProp(client, Prop_Data, "m_iMaxHealth") * 1.5));
        // murder timer
        if (g_hLaughTimer[client] != null)
        {
            LogMessage("Destroying powerplay timer");
            KillTimer(g_hLaughTimer[client]);
            g_hLaughTimer[client] = null;
        }
    }
    // toggle !
    PowerPlay[client] = !PowerPlay[client];
}

public Action timer_Laugh(Handle timer, userid)
{
    int client = GetClientOfUserId(userid);
    if (IsValidClient(client) && IsClientPlaying(client) && PowerPlay[client])
    {
        TFClassType playerClass = TF2_GetPlayerClass(client);
        if (playerClass == TFClass_Scout)
        {
            EmitSoundToAll("vo/scout_laughlong02.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_Soldier)
        {
            EmitSoundToAll("vo/soldier_laughevil02.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_Pyro)
        {
            EmitSoundToAll("vo/pyro_laughlong01.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_DemoMan)
        {
            EmitSoundToAll("vo/demoman_laughlong02.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_Heavy)
        {
            EmitSoundToAll("vo/heavy_laughlong01.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_Engineer)
        {
            EmitSoundToAll("vo/engineer_laughlong01.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_Medic)
        {
            EmitSoundToAll("vo/medic_laughlong02.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_Sniper)
        {
            EmitSoundToAll("vo/sniper_laughlong01.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
        else if (playerClass == TFClass_Spy)
        {
            EmitSoundToAll("vo/spy_laughevil02.mp3", client, _, _, _, _, _, _, _, _, _, _)
        }
    }
}


public void OnGameFrame()
{
    for (int client = 0; client < MaxClients + 1; client++)
    {
        if (IsValidClient(client) && IsClientPlaying(client) && PowerPlay[client])
        {
            TF2_AddCondition(client, TFCond_Kritzkrieged);          // kritz
            TF2_AddCondition(client, TFCond_Ubercharged);           // uber
            TF2_AddCondition(client, TFCond_DefenseBuffed);         // battalion's backup
            TF2_AddCondition(client, TFCond_RegenBuffed);           // conch buff
            TF2_AddCondition(client, TFCond_Buffed);                // buff banner
            TF2_AddCondition(client, TFCond_UberBulletResist);      // vacc bullet charge
            TF2_AddCondition(client, TFCond_UberBlastResist);       // vacc blast charge
            TF2_AddCondition(client, TFCond_UberFireResist);        // vacc fire charge
            //TF2_AddCondition(client, TFCond_MegaHeal);            // quick fix
            TF2_IgnitePlayer(client, client, 0.1);                  // set player on fire
            SetEntityHealth(client, 6969);                          // set health to high number (arbitrary)
        }
    }
}

// cleaned up IsValidClient Stock
stock bool IsValidClient(client)
{
    if  (
            client <= 0
             || client > MaxClients
             || !IsClientConnected(client)
             || IsFakeClient(client)
        )
    {
        return false;
    }
    return IsClientInGame(client);
}

// is client on a team and not dead
stock bool IsClientPlaying(client)
{
    TFTeam team = TF2_GetClientTeam(client);
    if  (
            IsPlayerAlive(client)
            &&
            (
                team == TFTeam_Red
                 ||
                team == TFTeam_Blue
            )
        )
    {
        return true;
    }
    return false;
}
