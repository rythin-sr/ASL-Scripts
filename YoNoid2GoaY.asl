state("noid") {
	byte state:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30,  0x18,  0x28, 0x10;
	float xPos:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30,  0x1F0;
	float yPos:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30,  0x1F4;
	float zPos:            "UnityPlayer.dll", 0x1446C88, 0x58, 0x98, 0x30,  0x1F8;
	string20 loadedScene:  "UnityPlayer.dll", 0x1467538, 0x48, 0x40;
	string20 loadingScene: "UnityPlayer.dll", 0x1467538, 0x28, 0x0,  0x40;
	byte bosshp:           "UnityPlayer.dll", 0x1469C58, 0x8,  0x60, 0xAD8, 0x118, 0xAA;
	float ConfirmTime:     "UnityPlayer.dll", 0x1469C58, 0x8,  0x8,  0x7D8, 0x158, 0xD0;
}

startup {
	settings.Add("IL", false, "Enable IL Mode");
	settings.Add("ILS", false, "Split according to IL timing in full-game runs");
	settings.Add("Level Completion", true);
		settings.Add("LevelIntro", true, "New York", "Level Completion");
		settings.Add("LeviLevle", true, "Swing Factory", "Level Completion");
		settings.Add("dungeon", true, "Domino Dugeon", "Level Completion");
		settings.Add("PZNTv5", true, "Plizzanet", "Level Completion");
		settings.Add("MikeLayer", true, "???", "Level Completion");
	
	settings.Add("Level Entry");
		settings.Add("eLeviLevle", false, "Swing Factory", "Level Entry");
		settings.Add("edungeon", false, "Domino Dungeon", "Level Entry");
		settings.Add("ePZNTv5", false, "Plizzanet", "Level Entry");
		settings.Add("eMikeLayer", false, "???", "Level Entry");
		
	settings.Add("Misc.");
		settings.Add("mikestart", false, "Split when starting the Mike fight", "Misc.");
	
	vars.doneSplits = new List<string>();
}

start {
	if (current.loadedScene != "void" && current.state == old.state - 1 && settings["IL"]) {
		vars.doneSplits.Clear();
		return true;
	} 
	
	if (current.loadedScene == "title" && current.ConfirmTime > old.ConfirmTime) {
		vars.doneSplits.Clear();
		return true;
	}
}

split {
	if (String.IsNullOrEmpty(current.loadedScene))
		current.loadedScene = old.loadedScene;
	
	if (settings["IL"]) {
		return current.loadedScene == "MikeLayer" && current.state == 0 && old.state == 9 && current.bosshp == 0 ||
		current.loadedScene != "MikeLayer" && current.state == 9 && old.state < 9;
	} else {
		if (!settings["ILS"]) {
			if (current.loadedScene != old.loadedScene) {
				if (current.loadedScene == "void" && !vars.doneSplits.Contains(old.loadedScene) && settings[old.loadedScene]) {
					vars.doneSplits.Add(old.loadedScene);
					return true;
				}
				
				if (current.loadedScene != "void" && !vars.doneSplits.Contains("e" + current.loadedScene) && settings["e" + current.loadedScene]) {
					vars.doneSplits.Add("e" + current.loadedScene);
					return true;
				}
			}
		} else if (settings["ILS"]) {
			//this is awful
			if (current.state == 9 && old.state < 9) {
				if (current.loadedScene == "LevelIntro" &&
				current.xPos >= -90 && current.xPos <= -77 &&
				current.yPos >= 290 && current.yPos <= 320 &&
				current.zPos >= 240 && current.zPos <= 250 &&
				!vars.doneSplits.Contains(current.loadedScene) && settings[current.loadedScene]) {
					vars.doneSplits.Add(current.loadedScene);
					return true;
				}
					
				if (current.loadedScene == "LeviLevle" &&
				current.xPos >= 715 && current.xPos <= 725 &&
				current.yPos >= 135 && current.yPos <= 145 &&
				current.zPos >= 110 && current.zPos <= 120 &&
				!vars.doneSplits.Contains(current.loadedScene) && settings[current.loadedScene]) {
					vars.doneSplits.Add(current.loadedScene);
					return true;
				}
					
				if (current.loadedScene == "dungeon" &&
				current.xPos >= -15 && current.xPos <= -3 &&
				current.yPos >= 60 && current.yPos <= 70 &&
				current.zPos >= 8 && current.zPos <= 20 &&
				!vars.doneSplits.Contains(current.loadedScene) && settings[current.loadedScene]) {
					vars.doneSplits.Add(current.loadedScene);
					return true;
				}
					
				if (current.loadedScene == "PZNTv5" &&
				current.xPos >= 32 && current.xPos <= 42 &&
				current.yPos >= -60 && current.yPos <= -40 &&
				current.zPos >= -1345 && current.zPos <= -1330 &&
				!vars.doneSplits.Contains(current.loadedScene) && settings[current.loadedScene]) {
					vars.doneSplits.Add(current.loadedScene);
					return true;
				}
			}
				
			if (current.state == old.state - 1 && !vars.doneSplits.Contains("e" + current.loadedScene) && settings["e" + current.loadedScene]) {
				vars.doneSplits.Add("e" + current.loadedScene);
				return true;
			}
		}
		
		if (current.loadedScene == "MikeLayer" && current.state < 2 && old.state == 9) {
				if (current.bosshp > 0)
					return settings["mikestart"];
				
				if (current.bosshp == 0)
					return settings["MikeLayer"];
		}
	}
}

reset {
	if (settings["IL"]) {
		return current.state == 8;
	} else {
		return current.loadedScene == "title" && old.loadedScene != "title";
	}
}

isLoading {
	return current.loadedScene != current.loadingScene;
}
