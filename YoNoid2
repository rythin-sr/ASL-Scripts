//Yo! Noid 2 Legacy Edition autosplitter by rythin
//todo: start and final split offsets

state("noid") {
	//different number on different levels, flickers a bunch during level transitions
	int level:	0xFFC710;
}

startup {
	
	//set up settings and variables required for logic
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", true, "Level Entry");
	
	settings.Add("5", true, "New York", "lc");
	
	vars.validLevels = new List<int>();
	vars.validLevels.Add(5);
	vars.lastLevel = 0;
	
	vars.l = new Dictionary<int, string> {
		{16, "Plizzanet"},
		{28, "Swing Factory"},
		{31, "Domino Dungeon"},
		{10, "???"}
	};
	
	foreach (var Tag in vars.l) {
		settings.Add(Tag.Key.ToString(), true, Tag.Value, "lc");
		settings.Add(Tag.Key.ToString() + "e", true, Tag.Value, "le");
		vars.validLevels.Add(Tag.Key); 
	};
	
}



start {
	if (current.level == 1 && old.level != 1) {
		vars.lastLevel = 5;
		return true;
	}
}

split {
	
	//area entry splits
	if (vars.validLevels.Contains(current.level) && old.level != current.level) {
		vars.lastLevel = current.level;
		return (settings[current.level.ToString() + "e"]);
	}
	
	//area completion splits
	if (current.level == 19 && old.level != 19) {
		return (settings[vars.lastLevel.ToString()]);
	}
}
