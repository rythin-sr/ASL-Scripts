//World War II: Sniper - Call to Victory / Battlestrike: Call to Victory Autosplitter + Load Remover
//Load Removal by SuicideMachine
//Autosplitter code by rythin
//Addresses found by The_One & SuicideMachine

state("Lithtech") {
	bool isPaused:			0x1C12D0, 0x194;
	byte levelID:			"lithtech.exe", 0x001C1330, 0xC;					//doesn't work for the transition from Dropzone to Messenger
	byte levelID2: 			"lithtech.exe", 0x001c17e0, 0x8, 0x4, 0xa68;		//works for the above transition, but seems to split randomly? also one mission shares the value of C1 making auto-resets a pain
}

init {
	//as in most lithtech games, the level value goes to 0 in loading screens, 
	//so we keep the value of the previous level here to compare to after a load happens
	vars.prevLev = 26;
}

start {
	//start when first level is loaded and the loading screen just finished
	if (current.levelID == 26 && !current.isPaused && current.isPaused != old.isPaused) {
		return true;
	}
}

split {
	//split on level transitions except for Dropzone -> Messenger (because the levelID for those two maps is the same)
	if (current.levelID != vars.prevLev && current.levelID != 0) {
		vars.prevLev = current.levelID;
		return true;
	}
	
	//split Dropzone -> Messenger (since levelID2 is different for those two)
	if (current.levelID2 == 41 && old.levelID2 == 0 && vars.prevLev == 6) {
		return true;
	}
	
	//levelID2 has repeating values for different levels, making it not great for splitting anywhere else
	//but it does fix this singular issue so we use it here
}

reset {
	//reset when in C1, the beginning cutscene
	if (current.levelID == 4) {
		vars.prevLev = 26;
		return true;
	}
}

isLoading {
	return current.isPaused;
}