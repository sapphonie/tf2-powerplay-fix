#include <sourcemod>
#include <tf2_stocks>

public Plugin myinfo =
{
    name        = "PowerPlay For Realz",
    author      = "stephanie",
    description = "type /pp to win game",
    version     = "0.0.1",
    url         = "https://steph.anie.dev/"
};


bool PowerPlay              [MAXPLAYERS + 1];
Handle g_hLaughAndIgnite    [MAXPLAYERS + 1];

public OnPluginStart()
{
    RegAdminCmd("sm_pp", setPP, ADMFLAG_ROOT);
}

public Action setPP(client, args)
{
    if (!PowerPlay[client])
    {
        ReplyToCommand(client, "Enabled PowerPlay on self!");
        g_hLaughAndIgnite[client] = CreateTimer(6.9, timer_LaughAndIgnite, GetClientUserId(client), TIMER_REPEAT);
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
        //TF2_RemoveCondition(client, TFCond_MegaHeal);               // quick fix


        if (g_hLaughAndIgnite[client] != null)
        {
            LogMessage("Destroying powerplay timer");
            KillTimer(g_hLaughAndIgnite[client]);
            g_hLaughAndIgnite[client] = null;
        }
    }
    PowerPlay[client] = !PowerPlay[client];
}

public Action timer_LaughAndIgnite(Handle timer, userid)
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
