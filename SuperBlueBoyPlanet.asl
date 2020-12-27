//Super Blue Boy Planet Autosplitter by rythin
//Original script by eddiesaurus87

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("006", "1.2") {
	int	roomID: 	0x05CB860;
}

state("006", "1.1") {
	int	roomID:		0x59D310;
}

state("Super Blue Boy Planet", "2.0") {
	int	roomID:		0x6C2D90;
} 

init {
	vars.prevLevel = 0;
	
	if (modules.First().ModuleMemorySize == 6225920) {
		version = "1.1";
	}
	
	if (modules.First().ModuleMemorySize == 6311936) {
		version = "1.2";
	}
	
	if (modules.First().ModuleMemorySize == 7393280) {
		version = "2.0";
	}
}   

start {
	if (old.roomID == 0 && current.roomID == 1) {
		vars.levelsDone.Clear();
		vars.levelsDone.Add(0);
		vars.prevLevel = 1;
		return true;
	}
}

split {
	if (vars.prevLevel != current.roomID && !vars.levelsDone.Contains(current.roomID)) {
		vars.levelsDone.Add(vars.prevLevel);
		vars.prevLevel = current.roomID;
		return true;
	}
}

reset {
	return (old.roomID == 0 && current.roomID == 1);
}
