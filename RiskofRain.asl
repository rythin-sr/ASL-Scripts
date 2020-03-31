//Risk of Rain Autosplitter by rythin

//Current features:
// *autostart
// *full autosplitting including final split
// *auto reset on quit to menu

state("ROR_GMS_controller", "1.2.2") {
	int roomID: 		0x2BED7A8; 						//1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41 | cutscenes: 1 & 9
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;			//goes from 0 to 1 when you Press 'A' to leave the planet
	double gameTime:	0x02BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

state("Risk of Rain", "1.2.2") {
	int roomID: 		0x2BED7A8; 						//1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41 | cutscenes: 1 & 9
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;			//goes from 0 to 1 when you Press 'A' to leave the planet
	double gameTime:	0x02BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

state("Risk of Rain", "Steam") {
	int roomID: 		0x59D310; 						//1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41
	int runEnd:		0x0039AF04, 0x0, 0x54C, 0xC, 0xC0;			//goes from 0 to 1 when you Press 'A' to leave the planet
} 

init {
	if (modules.First().ModuleMemorySize == 6221824) {
		version = "Steam";
	}
	
	if (modules.First().ModuleMemorySize == 48934912) {
		version = "1.2.2";
	} 
}

startup {
	settings.Add("levelsplits", true, "Split between levels");
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
	if (current.roomID != old.roomID && 								//when room changes
	current.roomID != 2 && old.roomID != 6 && old.roomID != 2 && old.roomID != 40 && 		//and is not one of the menus
	old.roomID != 9 && old.roomID != 1 && old.roomID != 0 && 					//nor the cutscenes on game startup
	settings["levelsplits"] == true) {								//and setting is on
		return true;										//split
	}
	//final split
	if (current.roomID == 41 && current.runEnd == 1 && old.runEnd == 0) {
		return true;
	}
}
	
reset {
	return (current.roomID == 2 || current.roomID == 40);
}

isLoading {
	return true;
}

gameTime {
	if (version == "1.2.2" && current.gameTime != 0) {
		return TimeSpan.FromSeconds(current.gameTime);
	}
}
