#include <sourcemod>
#include <dhooks>

#define LMP_VERSION "1.0"

public Plugin myinfo =
{
	name = "[L4D & L4D2] Late Model Precacher",
	author = "Psyk0tik",
	description = "Catches unprecached models and tries to precache them to prevent crashes.",
	version = LMP_VERSION,
	url = "https://github.com/Psykotikism/Late_Model_Precacher"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion evEngine = GetEngineVersion();
	if (evEngine != Engine_Left4Dead && evEngine != Engine_Left4Dead2)
	{
		strcopy(error, err_max, "\"Late Model Precacher\" only supports Left 4 Dead 1 & 2.");

		return APLRes_SilentFailure;
	}

	return APLRes_Success;
}

DynamicDetour g_ddUTILSetModelDetour;

public void OnPluginStart()
{
	CreateConVar("l4d_late_model_precacher_version", LMP_VERSION, "Late Model Precacher Version", FCVAR_DONTRECORD|FCVAR_NOTIFY|FCVAR_REPLICATED|FCVAR_SPONLY);

	GameData gdLMP = new GameData("l4d_late_model_precacher");
	if (gdLMP == null)
	{
		SetFailState("Unable to load the \"l4d_late_model_precacher\" gamedata file.");
	}

	g_ddUTILSetModelDetour = DynamicDetour.FromConf(gdLMP, "LMPDetour_UTIL_SetModel");
	if (g_ddUTILSetModelDetour == null)
	{
		delete gdLMP;

		SetFailState("Failed to detour: LMPDetour_UTIL_SetModel");
	}

	delete gdLMP;

	if (!g_ddUTILSetModelDetour.Enable(Hook_Pre, mreUTILSetModel))
	{
		LogError("Failed to enable the pre-hook detour for the \"LMPDetour_UTIL_SetModel\" function.");
	}
}

public void OnPluginEnd()
{
	if (!g_ddUTILSetModelDetour.Disable(Hook_Pre, mreUTILSetModel))
	{
		LogError("Failed to disable the pre-hook detour for the \"LMPDetour_UTIL_SetModel\" function.");
	}
}

MRESReturn mreUTILSetModel(DHookParam hParams)
{
	char sModel[PLATFORM_MAX_PATH];
	hParams.GetString(2, sModel, sizeof sModel);
	if (!IsModelPrecached(sModel))
	{
		LogError("UTIL_SetModel: Model %s is not precached. Precaching late.", sModel);
		PrecacheModel(sModel, true);

		if (!IsModelPrecached(sModel))
		{
			LogError("UTIL_SetModel: Model %s failed to late-precache. Aborting function.", sModel);

			return MRES_Supercede;
		}
	}

	return MRES_Ignored;
}