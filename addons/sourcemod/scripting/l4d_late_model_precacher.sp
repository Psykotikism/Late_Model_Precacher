/**
 * Late Model Precacher: a L4D/L4D2 SourceMod Plugin
 * Copyright (C) 2022  Alfred "Psyk0tik" Llagas
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

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