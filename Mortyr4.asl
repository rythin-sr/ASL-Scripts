state("game", "1.0") {
	byte load:   0x1C2A60;        // 2 when loading, 1 when loading is done but screen still up, 0 or >2 in gameplay
	string9 map: 0x1C412D;
	float end:   0x1C2EFC;        // goes from 1 to 0 at the end of the run
	byte freeze: 0x1DEF54, 0x2B0; // 33 when game is frozen due to quicksave/checkpoint
	int cs:      0x1BA648;        // 2 during gameplay, 0 in fmvs
	byte cp:     0x1DEF54, 0x2C9; // 1 at the start of a checkpoint freeze, then -19, flickers to -19 during gameplay, other values during loads

}

state("game", "Steam") {
	byte load:   0x1C0898;        // 2 in loads, 0 in gameplay, flickers a lot when going back to gameplay
	string9 map: 0x1C212D;        
	float end:   0x1C0EFC;        
	byte freeze: 0x1DCEC8, 0x2B0; 
	int cs:      0x1B8648;
	byte cp:     0x1DCEC8, 0x2C9; 
}

startup {
	vars.doneSplits = new List<string>();
	vars.lastMap = "";
}

init {	
	switch (modules.First().ModuleMemorySize) {
	case 2183168:
		version = "Steam";
		break;
		
	default:
		version = "1.0";
		break;
	}

}

start {
	if (current.map == "level_1_1" && (current.load > 2 || current.load < 1) && old.load > 0 && old.load < 3) {
		vars.doneSplits.Clear();
		vars.lastMap = "";
		return true;
	}
}

split {
	if (current.map != old.map && current.map == "") {
		vars.lastMap = old.map;
	}
	
	if (current.map != vars.lastMap && current.map != "" && vars.lastMap != "" && !vars.doneSplits.Contains(vars.lastMap) && !vars.doneSplits.Contains(current.map)) {
		vars.doneSplits.Add(vars.lastMap);
		return true;
	}
	
	if (current.map == "level_3_3" && current.end == old.end - 1) {
		return true;
	}
}

reset {
	return current.map == "level_1_1" && old.map == "";
}

isLoading {
	return current.load > 0 && current.load < 3 && current.cs == 2 || current.freeze == 33 || current.cp == 1;
}
