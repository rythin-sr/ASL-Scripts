//Crazy Machines 2 Autosplitter by rythin
//Steam version only for now

state("cm2") {
	//loading address not reliable
	//just changes randomly fuck off lmao
	//the game uses IGT for timing anyway, whatever
	//int load:		"faktum.dll", 0x2F2498;
	
	//current level you're in - 1 (so 1 for 1-2, 2 for 1-3 etc)
	int level:		"faktum.dll", 0x0030ACA4, 0x10, 0x178;
	
	//current chapter you're in - 1 (so 0 for 1-7, 3 for 4-2 etc)
	int chapter:	"faktum.dll", 0x0030ACA4, 0x10, 0x174;
	
	//0 when in menu, 1 when in level select and in levels
	int menu:		"faktum.dll", 0x0030ACA4, 0x10, 0x170;
}

startup {
	settings.Add("l", true, "Split on level change");
	settings.Add("c", false, "Split on chapter change");	
}

start {
	if (current.level == 0 && current.chapter == 0 && current.load == 0 && old.load == 1) {
		return true;
	}
}

split {
	
	if (settings["l"]) {
		if (current.level != old.level) {
			return true;
		}
	}
	
	if (settings["c"] && !settings["l"]) {
		if (current.chapter > old.chapter) {
			return true;
		}
	}
}
