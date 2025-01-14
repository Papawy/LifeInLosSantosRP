#if defined PLAYERS_VARS_INCLUDED
	#endinput
#endif

#define PLAYERS_VARS_INCLUDED

// ----------------------------------------------------------------------------

#include "core.pwn"

// ----------------------------------------------------------------------------

#include <YSI4\YSI_Coding\y_hooks>

// ----------------------------------------------------------------------------

/*
	key 
	- 0 : SQL ID
	- 1 : player name 
*/

forward LoadPlayerData(playerid, key);
public LoadPlayerData(playerid, key)
{
	new ORM:pOrm = pInfos[playerid][pOrmID] = orm_create("playersData");
	orm_addvar_int(pOrm, 	pInfos[playerid][pSqlID], 						"ID");
	orm_addvar_string(pOrm, pInfos[playerid][pName], 	MAX_PLAYER_NAME+1, 	"Name");
	orm_addvar_string(pOrm, pInfos[playerid][pPass], 	HASHED_PASS_LENGHT,	"Pass");
	orm_addvar_string(pOrm, pInfos[playerid][pIP],	 	VERY_VERY_SHORT_STR,"IP");
	orm_addvar_string(pOrm, pInfos[playerid][pEmail], 	LONG_STR,			"Email");
	orm_addvar_int(pOrm, 	pInfos[playerid][pRegisterDate], 				"RegisterDate");
	orm_addvar_int(pOrm, 	pInfos[playerid][pAdminRank],					"AdminRank");
	orm_addvar_int(pOrm,	pInfos[playerid][pCharacterID],					"CharacterID");

	switch(key)
	{
		case 0:
			orm_setkey(pOrm, "ID");

		case 1:
			orm_setkey(pOrm, "Name");

		default:
			orm_setkey(pOrm, "ID");
	}
	orm_select(pOrm, "OnPlayerDataLoad", "d", playerid);

	return true;
}

forward OnPlayerDataLoad(playerid);
public OnPlayerDataLoad(playerid)
{
	switch(orm_errno(pInfos[playerid][pOrmID]))
	{
		case ERROR_OK: {
			pInfos[playerid][pRegistered] = true;
		}
		case ERROR_NO_DATA: {
			pInfos[playerid][pRegistered] = false;
		}
	}
	orm_setkey(pInfos[playerid][pOrmID], "ID");
	return 1;
}

forward SavePlayerData(playerid);
public SavePlayerData(playerid)
{
	if(IsPlayerRegistered(playerid))
	{
		orm_update(pInfos[playerid][pOrmID]);
	}
}

forward ResetPlayerVars(playerid);
public ResetPlayerVars(playerid)
{
	new reset[P_INFOS];
	pInfos[playerid] = reset;
}

forward CreateNewPlayerInDataBase(playerid);
public CreateNewPlayerInDataBase(playerid)
{
	return orm_insert(pInfos[playerid][pOrmID]);
}