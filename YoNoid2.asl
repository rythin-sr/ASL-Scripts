state("noid") {
	string10 scene:        0x104FB78, 0x24, 0x30;
	string10 loadingScene: 0x104FB78, 0x14, 0x0, 0x30;
	byte dialogue:	       "mono.dll", 0x20C574, 0x10, 0xBC, 0x0, 0x8, 0xA8, 0xCC, 0x74, 0x40, 0xD8, 0x74;
}

startup {
	
	//set up settings and variables required for logic
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", true, "Level Entry");
	settings.Add("mikestart", false, "Split at the beginning of the Mike fight");
	
	settings.Add("LevelIntro", true, "New York", "lc");
	vars.doneSplits = new List<string>();
	vars.lastLevel = "";
	vars.stopwatch = new Stopwatch();
	
	vars.l = new Dictionary<string, string> {
		{"PZNTv5", "Plizzanet"},
		{"LeviLevle", "Swing Factory"},
		{"dungeon", "Domino Dungeon"},
		{"MikeLayer", "???"}
	};
	
	foreach (var Tag in vars.l) {
		settings.Add(Tag.Key, true, Tag.Value, "lc");
		settings.Add(Tag.Key + "-e", false, Tag.Value, "le");
	};
}

init {
	current.miketalk = 0;
}

start {
	timer.Run.Offset = TimeSpan.FromSeconds(0);
	
	if (current.scene != old.scene && old.scene == "title") {
		current.miketalk = 0;
		vars.doneSplits.Clear();
		timer.Run.Offset = TimeSpan.FromSeconds(1.05);
		return true;
	}
}

split {
	if ((current.scene == null || current.scene == "title") && old.scene != current.scene && old.scene != "title") {
		vars.lastLevel = old.scene;
	}
	
	//level splits
	if (current.scene != vars.lastLevel && current.scene != null) {
		if (current.scene == "void") {
			if (settings[vars.lastLevel] && !vars.doneSplits.Contains(vars.lastLevel)) {
				vars.doneSplits.Add(vars.lastLevel);
				return true;
			}
		} else if (vars.lastLevel == "void") {
			if (settings[current.scene + "-e"] && !vars.doneSplits.Contains(current.scene + "-e")) {
				vars.doneSplits.Add(current.scene + "-e");
				return true;
			};
		}
	}
	
	//mike splits
	if (current.scene == "MikeLayer" && current.dialogue == old.dialogue - 1) {
		current.miketalk++;
	}
	
	if (current.miketalk == old.miketalk + 1) {
		if (current.miketalk == 1) return settings["mikestart"];
		if (current.miketalk == 2) return settings["MikeLayer"];
	}
}

isLoading {
	return (current.scene != current.loadingScene);
}
