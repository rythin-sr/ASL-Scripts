//Risk of Rain Autosplitter by rythin

// Current features:
// *autostart
// *full autosplitting including final split
// *auto reset on quit to menu

// ToDo:
// *settings to support multi-char categories
// *setting to disable splitting between levels (only on game completion)
// *work on IGT some more?

state("ROR_GMS_controller") {
	int roomID: 	0x2BED7A8; 								//1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;		//goes from 0 to 1 when you Press 'A' to leave the planet
	double spIGT:	0x02BD97CC, 0x0, 0x10, 0x0, 0x4D0;		//goes from 0 to 59, then back to 0, only in singleplayer
	int isPaused:	0x2BAAA3C;								//229 when paused, 255 when not
}
	
//init {
//	vars.displayIGT = 0;
//	vars.counter = 0;
//}
// I have tried many ways to get IGT in livesplit, but alas gamesux
//update {
	//if (old.spIGT != 0 && current.spIGT != 0 && current.spIGT != old.spIGT) {	//since IGT resets every minute, add 1 second to IGT
	//	vars.displayIGT = vars.displayIGT + 1;									//every time it ticks
	//}
	
	//if (old.spIGT == 59 && current.spIGT == 0) {		//because IGT gets set to 0 when you pause, i avoid adding to igt when it goes to 0
	//	vars.counter = vars.counter + 1;				//instead i add 2 seconds on the transition from 59 to 0
	//}													//to make up 59 -> 0 and 0 -> 1
	
	//if (vars.counter == 2) {
	//	vars.counter = 0;
	//	vars.displayIGT = vars.displayIGT + 3;
	//}
//}
	
start {
	if (old.roomID == 6 && current.roomID != 6 || old.roomID == 40 && current.roomID != 40) {
		vars.displayIGT = 1;	//i think i did some math wrong so just make it start on 1
		return true;
	}
}
	
split {
	//area splits
	if (current.roomID != old.roomID && old.roomID != 6 && old.roomID != 40) {
		return true;
	}
	
	//final split
	if (current.roomID == 41 && current.runEnd == 1 && old.runEnd == 0) {
		return true;
	}
}
	
reset {
	return (current.roomID == 2);
}

//gameTime {
//	return TimeSpan.FromSeconds(vars.displayIGT);
//}

//isLoading {
//	return true;
//}

