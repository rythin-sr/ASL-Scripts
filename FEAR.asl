state("FEAR")
{
	int gameLoading:		0x173DB0;				//0, 4 or 5 when gameplay, 1 or 2 when loading
	byte cp2:			0x00015DCC, 0x288;			//0 or 96 when gameplay is happening
	byte cp1:			0x170D28;				//0 when gameplay is happening
	string16 mapName:		0x16C045;
	int gamePaused:			0x16CCE8;				//1 when paused
}

startup {
	settings.Add("cp2", false, "Enable experimental checkpoint removal (should provide more accurate loadless time but may not work on some versions)");
}

init {
	vars.lastMap = "h";
	vars.splits = new List<string>();
}

update {
	if (current.mapName == "" && old.mapName != "") {
		vars.lastMap = old.mapName;
	}
}

start { 
	if(current.gameLoading == 0 || current.gameLoading == 4 || current.gameLoading == 5) {
		if(current.mapName == "Intro.World00p" && old.gameLoading != 0) {
			vars.lastMap = "h";
			vars.splits.Clear();
			vars.splits.Add(current.mapName);
			return true;
		}
	}
}

split {
	//level splits
	if (vars.lastMap != current.mapName && current.mapName != "" && vars.lastMap != "h" && !vars.splits.Contains(current.mapName) && timer.CurrentPhase == TimerPhase.Running) {
		vars.lastMap = current.mapName;
		vars.splits.Add(current.mapName);
		return true;
	}
}

reset {
	return (old.mapName == "" && current.mapName == "Intro.World00p");
}

isLoading {
	//cp2 acts fluctuates between loading and not in the main menu
	//this is to prevent timer slowing down in case of "Disconnected from Sever" bug
	if (current.gamePaused == 0 && settings["cp2"]) {
		if (current.cp2 == 232) {
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
