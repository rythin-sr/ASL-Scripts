//Yo! Noid 2 Legacy Edition autosplitter by rythin
//dice patch support in the future?

state("noid") {
	//different number on different levels, flickers a bunch during level transitions
	int level:	0xFFC710;
	byte dialogue:	"mono.dll", 0x20C574, 0x10, 0xBC, 0x0, 0x8, 0xA8, 0xCC, 0x74, 0x40, 0xD8, 0x74;
}

startup {
	
	//set up settings and variables required for logic
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", true, "Level Entry");
	settings.Add("mikestart", false, "Split at the beginning of the Mike fight");
	
	settings.Add("5", true, "New York", "lc");
	
	vars.doneLevels = new List<string>();
	vars.validLevels = new List<int>();
	vars.validLevels.Add(5);
	vars.lastLevel = 0;
	vars.flickerPrevention = 0;
	vars.stopwatch = new Stopwatch();
	
	vars.l = new Dictionary<int, string> {
		{16, "Plizzanet"},
		{28, "Swing Factory"},
		{31, "Domino Dungeon"},
		{10, "???"}
	};
	
	foreach (var Tag in vars.l) {
		settings.Add(Tag.Key.ToString(), true, Tag.Value, "lc");
		settings.Add(Tag.Key.ToString() + "e", false, Tag.Value, "le");
		vars.validLevels.Add(Tag.Key); 
	};
	
	timer.Run.Offset = TimeSpan.FromSeconds(1.05);
}

init {
	current.miketalk = 0;
}

start {
	if (current.level == 1 && old.level != 1) {
		vars.lastLevel = 5;
		vars.flickerPrevention = 0;
		current.miketalk = 0;
		vars.doneLevels.Clear();
		return true;
	}
}

split {
	
	//area entry splits
	if (vars.validLevels.Contains(current.level) && old.level != current.level) {
		vars.flickerPrevention = current.level;
		vars.stopwatch.Restart();
	}
	
	if (vars.stopwatch.ElapsedMilliseconds > 30) {
		if (current.level == vars.flickerPrevention && !vars.doneLevels.Contains(current.level.ToString() + "e")) {
			vars.doneLevels.Add(current.level.ToString() + "e");
			vars.lastLevel = current.level;
			return (settings[current.level.ToString() + "e"]);
		}
	}
	
	//area completion splits
	if (current.level == 19 && old.level != 19 && !vars.doneLevels.Contains(vars.lastLevel.ToString())) {
		vars.doneLevels.Add(vars.lastLevel.ToString());
		return (settings[vars.lastLevel.ToString()]);
	}
	
	//mike splits
	if (current.level == 10 && current.dialogue == old.dialogue - 1) {
		current.miketalk++;
	}
	
	if (current.miketalk == old.miketalk + 1) {
		return current.miketalk == 1 && settings["mikestart"];
		return current.miketalk == 2 && settings["10"];
	}
}
