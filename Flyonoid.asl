//Flyonoid Autosplitter + Load Remover by rythin
//Todo: support for Max Energy runs?

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("mask") {
	string20 level:		0x6A987;	//level name
	int load:		0x8F95C;	//1 when loading
	int end:		0x87504;	//garbage values in most levels, 0 -> 1 on game end
}

startup {

	settings.Add("IL", false, "IL Mode");
	settings.Add("levels", true, "Levels");
	
	vars.d = new Dictionary<string, string> {
		{"white1/planet.txt", "1"},
		{"white2/planet.txt", "2"},
		{"white3/planet.txt", "3"},
		{"white4/planet.txt", "4"},
		{"red1/planet.txt", "5"},
		{"red2/planet.txt", "6"},
		{"red3/planet.txt", "7"},
		{"red4/planet.txt", "8"},
		{"blue1/planet.txt", "9"},
		{"blue2/planet.txt", "10"},
		{"blue3/planet.txt", "11"},
		{"blue4/planet.txt", "12"},
		{"yellow1/planet.txt", "13"},
		{"yellow2/planet.txt", "14"},
		{"yellow3/planet.txt", "15"},
		{"yellow4/planet.txt", "16"},
		{"base1/planet.txt", "17"},
		{"base2/planet.txt", "18"},
		{"base3/planet.txt", "19"}
	};
	
	foreach (var Tag in vars.d) {							
		settings.Add(Tag.Key, true, Tag.Value, "levels");
	};
}

start {
	//autostart for full game runs
	if (settings["IL"] == false) {
		if (current.level == "White1/Planet.txt") {
			if (current.load == 0 && old.load == 1) {
				return true;
			}
		}
	}
	
	//autostart for IL runs
	else if (settings["IL"] == true) {
		if (current.load == 0 && old.load == 1) {
			return true;
		}
	}
}

split {

	//the capitalization of map names seems random, or at least very specific and is different when choosing the level from stage select or going into it from the previous level
	//forcing the names to all lowercase removes this issue
	
	//level splits according to settings
	if (current.level != old.level && current.level.ToLowerInvariant() != "white1/planet.txt") {
		if (settings[old.level.ToLowerInvariant()] == true && settings["IL"] == false) {
			return true;
		}
		
		else if (settings["IL"] == true) {
			return true;
		}
	}
	
	//final split
	if (old.level.ToLowerInvariant() == "base4/planet.txt" && current.level == "") {
		return true;
	}
}

reset {
	
	if (settings["IL"] == true) {
		if (current.load == 0 && old.load == 1) {
			return true;
		}
	}
	
	if (settings["IL"] == false) {
		if (current.level == "White1/Planet.txt") {
			if (current.load == 0 && old.load == 1) {
				return true;
			}
		}
	}
}

isLoading {
	return current.load == 1;
}
