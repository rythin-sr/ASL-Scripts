state("ROR_GMS_controller", "1.2.2") {
	int roomID: 		0x2BED7A8;
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;
	double gameTime:	0x02BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

state("Risk of Rain", "1.2.2") {
	int roomID: 		0x2BED7A8;
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;
	double gameTime:	0x02BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

state("Risk of Rain", "Steam") {
	int roomID: 		0x59D310;
	int runEnd:		0x0039AF04, 0x0, 0x54C, 0xC, 0xC0;
} 

startup {
	settings.Add("levelsplits", true, "Split between levels");
	settings.Add("ACR", false, "Only autoreset from the first split");
}

init {
	if (modules.First().ModuleMemorySize == 6221824) {
		version = "Steam";
	}
	
	if (modules.First().ModuleMemorySize == 48934912) {
		version = "1.2.2";
	} 
}
	
start {
	if (old.roomID == 6 && current.roomID != 6 || old.roomID == 40 && current.roomID != 40 || old.roomID == 7 && current.roomID != 7) {
		if (current.roomID != 2) {
			return true;
		}
	}
}
	
split {
	//area splits
	if (current.roomID != old.roomID &&                                                                   //when room changes
	current.roomID != 2 && old.roomID != 6 && old.roomID != 2 && old.roomID != 40 && old.roomID != 39 &&  //and is not one of the menus
	old.roomID != 9 && old.roomID != 1 && old.roomID != 0 &&                                              //nor the cutscenes on game startup
	settings["levelsplits"] == true) {                                                                    //and setting is on
		return true;                                                                                  //split
	}
	//final split
	if (current.roomID == 41 && current.runEnd == 1 && old.runEnd == 0) {
		return true;
	}
}
	
reset {
	if (current.roomID == 2 || current.roomID == 40) {
		if (settings["ACR"]) {
			return timer.CurrentSplitIndex == 0;
		} else {
			return true;
		}
	}
}

isLoading {
	return true;
}

gameTime {
	if (version == "1.2.2" && current.gameTime != 0) {
		return TimeSpan.FromSeconds(current.gameTime);
	}
}
