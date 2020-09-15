state("kao", "Legendsworld (Patched)") {
	int level:		0xDB2A4;
	int load:		0xD3D24;
}

startup {
	vars.dic = new Dictionary<int, string> {
		{1, "Lava 1"},
		{2, "Lava 2"},
		{3, "Lava 3 (Glider)"},
		{4, "Lava 4"},
		{5, "Ice 1"},
		{6, "Ice 2"},
		{7, "Bear Boss"},
		{8, "Ice 3"},
		{9, "Ice 4"},
		{10, "Ice 5 (Snowboard)"},
		{11, "Ice 6"},
		{12, "Greece 1"},
		{13, "Captain Boss"},
		{14, "Greece 2"},
		{15, "Greece 3 (Motorboat)"},
		{16, "Greece 4"},
		{17, "Greece 5"},
		{18, "Greece 6"},
		{19, "Zeus"},
		{20, "Space 1"},
		{21, "Space 2"},
		{22, "Space 3"},
		{23, "Space 4"},
		{24, "Alien"},
		{25, "Tropics 1"},
		{26, "Tropics 2"},
		{27, "Tropics 3"},
		{28, "Tropics 4"},
		{29, "Tropics 5"},
		{30, "Hunter"}
	};
	
	foreach (var Tag in vars.dic) {
		settings.Add(Tag.Key.ToString(), true, Tag.Value);
    };
	
	vars.doneLevels = new List<int>();
	vars.lastLevel = 0;
}

init {
	//print("Kao Version: " + modules.First().ModuleMemorySize.ToString());
	
	int memSize = modules.First().ModuleMemorySize;
	
	switch (memSize) {
		case 2486272:
		version = "Legendsworld (Patched)";
		break;
	}
}

start {
	if (current.level == 1 && old.level == 100 || current.level == 1 && old.level == 101) {
		vars.doneLevels.Clear();
		vars.lastLevel = 1;
		return true;
	}
}

split {
	//splits for levels 1-29, with the map menu inbetween
	if (current.level != 101 && old.level == 101 && current.level != vars.lastLevel && !vars.doneLevels.Contains(current.level)) {
		if (settings[vars.lastLevel.ToString()]) {
			vars.lastLevel = current.level;
			return true;
		}
		
		else {
			vars.lastLevel = current.level;
		}
	}
	
	//final split
	if (old.level == 30 && current.level != 101 && current.level != 100 && current.level != old.level) {
		if (settings["30"]) {
			return true;
		}
	}
}
	
isLoading {
	return (current.load == 1);
}
