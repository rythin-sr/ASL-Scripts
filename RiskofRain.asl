//Risk of Rain Autosplitter by rythin

//Current features:
// *autostart
// *full autosplitting including final split
// *auto reset on quit to menu

state("ROR_GMS_controller") {
	int roomID: 		0x2BED7A8; 					//1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;		//goes from 0 to 1 when you Press 'A' to leave the planet
	double spIGT:		0x02BD97CC, 0x0, 0x10, 0x0, 0x4D0;		//goes from 0 to 59, then back to 0, only in singleplayer
	int isPaused:		0x2BAAA3C;					//229 when paused, 255 when not
}

startup {
	settings.Add("levelsplits", true, "Split between levels");
}
	
start {
	if (old.roomID == 6 && current.roomID != 6 || old.roomID == 40 && current.roomID != 40) {
		return true;
	}
}
	
split {
	//area splits
	if (current.roomID != old.roomID && current.roomID != 2 && old.roomID != 6 && old.roomID != 40 && settings["levelsplits"] == true) {
		return true;
	}
	
	//final split
	if (current.roomID == 41 && current.runEnd == 1 && old.runEnd == 0) {
		return true;
	}
}
	
reset {
	return (current.roomID == 6 || current.roomID == 39);
}
