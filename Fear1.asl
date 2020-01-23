state("FEAR")
{
	int gameLoading:		0x173DB0;				//0, 4 or 5 when gameplay, 1 or 2 when loading
	byte cp2:				0x00015DCC, 0x288;		//0 or 96 when gameplay is happening
	byte cp1:				0x170D28;				//0 when gameplay is happening
	string16 mapName:		0x16C045;
	int gamePaused:			0x16CCE8;				//1 when paused
}

init {
	vars.lastMap = "h";
}

update {
	if (current.mapName == "" && old.mapName != "") {
		vars.lastMap = old.mapName;
	}
}

start { 
	if (current.mapName == "Intro.World00p" && old.gameLoading != 0 && current.gameLoading == 0 || current.gameLoading == 4 || current.gameLoading == 5) {
		vars.lastMap = "h";
		return true;
	}
}

split {
	//level splits
	if (vars.lastMap != current.mapName && current.mapName != "" && vars.lastMap != "h") {
			vars.lastMap = current.mapName;
			return true;
	}
}

reset {
	return (old.mapName == "" && current.mapName == "Intro.World00p");
}

isLoading {
	//cp2 acts fluctuates between loading and not in the main menu
	//this is to prevent timer slowing down in case of "Disconnected from Sever" bug
	if (current.gamePaused == 0) {
		if (current.cp2 != 0 && current.cp2 != 96) {
			return true;
		}
	}
	
	//standard load removal
	if (current.gameLoading == 1 || current.gameLoading == 2 || current.cp1 != 0) {
		return true;
	}
	
	else {
		return false;
	}
}

exit {
	timer.IsGameTimePaused = true;
}