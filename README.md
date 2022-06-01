# Late Model Precacher

## PayPal
[Donate to Motivate](https://paypal.me/Psyk0tikism?locale.x=en_US)

## License
> The following license is placed inside the source code of the plugin.

Late Model Precacher: a L4D/L4D2 SourceMod Plugin
Copyright (C) 2022  Alfred "Psyk0tik" Llagas

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

## About
Catches unprecached models and tries to precache them to prevent crashes.

This plugin addresses the rare occurrence of a well-known `UTIL_SetModel` crash that has existed for as long as both L4D games have been around. The crash can occur even on completely vanilla servers, but can occur more frequently on modded servers that run plugins utilizing models.

If a model cannot be precached, this plugin will block `UTIL_SetModel` and the entity will (probably) just be invisible or be a giant ERROR sign.

Disclaimer: This plugin only helps prevent crashes related to unprecached models (`UTIL_SetModel` crashes). If this plugin is detecting a lot of unprecached models on your server on a regular basis, there may be severe underlying issues with your server that need to be addressed.

Do not use this plugin as a "global precacher" for models. When a model is late-precached, players will experience a stutter (more obvious on low-end computers), so it's best to make sure that plugins utilizing models properly precache them inside `OnMapStart()`.

Example:
```
L 04/11/2022 - 13:15:48: SourceMod error session started
L 04/11/2022 - 13:15:48: Info (map "l4d_hospital03_sewers") (file "C:\l4d1ds\left4dead\addons\sourcemod\logs\errors_20220411.log")
L 04/11/2022 - 13:15:48: [l4d_late_model_precacher.smx] UTIL_SetModel: Model models/props_unique/spawn_apartment/coffeeammo.mdl is not precached. Precaching late.
```

## Credits
**epz/epzminion** - For the idea and solution.

**SourceMod Team** - For continually updating/improving `SourceMod`.

## Requirements
1. `SourceMod 1.10` or higher
2. [`DHooks 2.2.0-detours15` or higher](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)
3. Knowledge of installing SourceMod plugins.

## Notes
1. I do not provide support for listen/local servers but the plugin should still work properly on them.
2. I will not help you with installing or troubleshooting problems on your part.
3. If you get errors from SourceMod itself, that is your problem, not mine.
4. MAKE SURE YOU MEET ALL THE REQUIREMENTS AND FOLLOW THE INSTALLATION GUIDE PROPERLY.

## Features
1. Precaches any model that is not precached prior to being used.
2. Blocks the game from setting an entity's model if the model failed to be precached.

## Installation
1. Delete files from old versions of the plugin.
2. Place `l4d_late_model_precacher.txt` in the `addons/sourcemod/gamedata` folder.
3. Place `l4d_late_model_precacher.smx` in the `addons/sourcemod/plugins` folder.
4. Place `l4d_late_model_precacher.sp` in the `addons/sourcemod/scripting` folder.

## Uninstalling/Upgrading to Newer Versions
1. Delete `l4d_late_model_precacher.sp` from the `addons/sourcemod/scripting` folder.
2. Delete `l4d_late_model_precacher.smx` from the `addons/sourcemod/plugins` folder.
3. Delete `l4d_late_model_precacher.txt` from the `addons/sourcemod/gamedata` folder.
4. Follow the Installation guide above. (Only for upgrading to newer versions.)

## Disabling
1. Move `l4d_late_model_precacher.smx` to the `plugins/disabled` folder.
2. Unload `Late Model Precacher` by typing `sm plugins unload l4d_late_model_precacher` in the server console.

## Third-Party Revisions Notice
If you would like to share your own revisions of this plugin, please rename the files so that there is no confusion for users.

## Final Words
Enjoy all my hard work and have fun with it!