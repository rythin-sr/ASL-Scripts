//Trespasser: Jurassic Park Load Remover + Autosplitter by rythin

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("trespass", "1.0") {
	int		gameLoading1:		0x340AD4;
	int		gameLoading2:		0x26E654;
	string3		mapName:		0x26E342;
	float		isMoving:		0x0033DC88, 0x68;
	int		csWatcher:		"smackw32.dll", 0x14298; 
}

state("trespass", "1.1") {
	int		gameLoading1:		0x26A28C;
	int		gameLoading2:		0x26A938;
	string3		mapName:		0x269F7A;
	float		isMoving:		0x003397A8, 0x68;
	int		csWatcher:		"smackw32.dll", 0x00015414, 0x3CC; 
}

state("tpassp6", "Community Edition") {
   	bool		gameLoading1: 		0x054FDF0;
	bool		gameLoading2:		0x5B3968;
	string3		mapName: 		0x5AEC68; //BE, ij, it, lab, as, as2, sum
	float		isMoving:		0x005B3DE4, 0x70;
	int		csWatcher:		"smackw32.dll" , 0x14298; 
} 

startup {
	vars.mapsDone = new List<string>();
}

init {
	if (modules.First().ModuleMemorySize == 3436544) {
		version = "1.0";
	}
	
	if (modules.First().ModuleMemorySize == 6778880) {
		version = "Community Edition";
	}
	
	else {
		version = "1.1";
	}
}

start {
	if (current.mapName == "BE." && old.isMoving != current.isMoving && current.isMoving != 0) {
		vars.mapsDone.Clear();
		vars.mapsDone.Add(current.mapName);
		return true;
	}
}

split {
	//split between levels
	if (current.mapName != old.mapName && !vars.mapsDone.Contains(current.mapName)) {
		vars.mapsDone.Add(current.mapName);
		return true;
	}
	
	//final split
	if (current.mapName == "sum" && current.csWatcher == 1 && old.csWatcher == 0) {
		return true;
	}
}

reset{
	return (current.mapName == "BE." && old.csWatcher == 1);
}

isLoading {
	
	//the game seems to have 2 kinds of loads:
	// short loads - when loading a save on the same map
	//these are included in gameLoading1 in their entirety.
	// long loads - when loading into a new map
	//these seem to be split into two different pointers
	//gameLoading1 still works for *most* of the loading
	//but theres around 1-2s of loading that gameLoading1 
	//doesnt seem to detect, hence why gameLoading2 is necessary
	
	//also, when running 1.0 or 1.1 
	//sometimes one of the values from the other version 
	//gets stuck at some random absurdly high number, hence why the '< 1000000'. 
	//It seems to catch all the incorrect values from what ive tested
	
	if (version == "1.0" || version == "1.1") {
		return (current.gameLoading1 == 1  || current.gameLoading2 == 2);
	}
	
	if (version == "Community Edition") {
		return (current.gameLoading1 || current.gameLoading2);
	}
}
