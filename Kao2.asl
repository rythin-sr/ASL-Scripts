//Kao the Kangaroo: Round 2 Autosplitter + Load Remover for the Retail version by rythin
//base script by RibShark, Mr. Mary

state("Kao2", "Polish Retail") {
   	int level: 			0x22B7D4;
   	int menu: 			0x23D9AC;
    	int loading: 			0x22451C;
	int cs: 			0x21E6EC;
	float Xpos:			0x22C648;
	float Ypos:			0x22C64C;
	float Zpos:			0x22C650;
}

state("Kao2", "Australian Rerelease") {
	int level:			0x28DFC4;
	int menu:			0x282E18;
	int loading:			0x2806A4;
	int cs:				0x27A65C;
	float Xpos:			0x28EE98;
	float Ypos:			0x28EE9C;
	float Zpos:			0x28EEA0; 
}

startup {
	
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", true, "Level Entry");
	settings.Add("newb", true, "Newbie-friendly auto-resets");
	settings.SetToolTip("newb", "Only auto-reset if going to the menu before The Race, but after The Ship");
	
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
		{21, "Hunter's Galleon"},
		{23, "Bonus: Jumprope"},
		{24, "Bonus: Trees"},
		{25, "Bonus: Shooting"},
		{26, "Bonus: The Race"},
		{27, "Bonus: Mini Baseball"},
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
	
	vars.doneSplits = new List<string>();
}

init {
	
	if (modules.First().ModuleMemorySize == 2523136) { 
		version = "Polish Retail";
	}
	
	if (modules.First().ModuleMemorySize == 2940928) { 
		version = "Australian Rerelease";
	}
	
	else {
		version = "Unsupported";
	}
}

start {
    if (current.level == 0 && old.menu == 1 && current.menu == 0 && current.cs == 1) {
		vars.doneSplits.Clear();
		vars.counter = 0;
		return true;
	}
} 

split {

	if (current.level != old.level && current.level != 0) {
		//level completion splits
		if (settings[old.level.ToString()] && !vars.doneSplits.Contains(old.level.ToString())) {
			vars.doneSplits.Add(old.level.ToString());
			return true;
		}
		//level entry splits
		if (settings[current.level.ToString() + "e"] && !vars.doneSplits.Contains(current.level.ToString() + "e")) {
			vars.doneSplits.Add(current.level.ToString() + "e");
			return true;
		}	
	}
	
	//final split
	if (current.level == 22 && current.cs == 1 && old.cs == 0 && current.Ypos > 9000) {
		return true;
	}	
}

reset {
	if (current.level == 0) {
		if (settings["newb"] && old.level < 13 && old.level > 0) {
			return true;
		}
		if (!settings["newb"] && current.loading == 0 && old.loading == 1) {
			return true;
		}
	}
}

isLoading {
    return (current.loading == 1);
}
