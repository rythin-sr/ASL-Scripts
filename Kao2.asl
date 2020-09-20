
state("Kao2", "Polish Retail") {
    int level: 			0x22B7D4;
    int menu: 			0x23D9AC;
    int loading: 		0x22451C;
	int cs: 			0x21E6EC;
	float hunterHealth: 0x227080, 0x44, 0x08, 0x44, 0x1C, 0x44, 0x00, 0x44, 0x38, 0x0114, 0x5C, 0x30, 0x20, 0x0C;
}

startup {
	
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", true, "Level Entry");
	
	vars.level = new Dictionary<int, string> {
		{0, "The Ship"},
		{2, "Beavers' Forest"},
		{3, "The Great Escape"},
		{4, "Great Trees"},
		{5, "River Raid"},
		{6, "Shaman's Cave"},
		{7, "Igloo Village"},
		{8, "Ice Cave"},
		{9, "Down the Mountain"},
		{10, "Crystal Mines"},
		{11, "The Station"},
		{12, "The Race"},
		{13, "Hostile Reef"},
		{14, "Deep Ocean"},
		{15, "Liar of Poison"},
		{16, "Trip to Island"},
		{17, "Treasure Island"},
		{18, "The Volcano"},
		{19, "Pirate's Bay"},
		{20, "Abandoned Town"},
		{21, "Hunter's Galleon"}
	};
	
	vars.levelEntry = new Dictionary<string, string> {
		{"2e", "Beavers' Forest"},
		{"7e", "Igloo Village"},
		{"12e", "The Race"},
		{"16e", "Trip to Island"},
		{"20e", "Abandoned Town"}
	};
	
	foreach (var Tag in vars.level) {
		settings.Add(Tag.Key.ToString(), true, Tag.Value, "lc");
	};
	
	foreach (var Tag in vars.levelEntry) {
		settings.Add(Tag.Key, false, Tag.Value, "le");
	};
}

init {
	
	if (modules.First().ModuleMemorySize == 2523136) { 
		version = "Polish Retail";
	}
	
	else {
		version = "Unsupported";
	}
}

start {
    if (current.level == 0 && old.menu == 1 && current.menu == 0 && current.cs == 1) {
		return true;
	}
} 

split {
	if (current.level != old.level && current.level != 0) {
		//level completion splits
		if (settings[old.level.ToString()]) {
			return true;
		}
		//level entry splits
		if (settings[current.level.ToString() + "e"]) {
			return true;
		}	
	}
	
	//final split
	if (current.level == 22 && current.hunterHealth == 0 && current.cs == 1 && old.cs == 0) {
		return true;
	}
}

isLoading {
    return (current.loading == 1);
}
