//You Have 10 Seconds Autosplitter + Game Time
//YH10S autosplitter originally by Arcree, cleaned up a tad by rythin
//IGT by rythin



state("You Have 10 Secondsfinal", "yh10s"){
	int roomID:		0x59C310;
	int hasControl:		0x399F04, 0x0, 0xF8, 0xC, 0xB4;			//0 during gameplay, 1 or 2 during fade
	double y1IGT:		0x0034D464, 0x5C8, 0xC, 0x140, 0x4, 0x130;	//10s countdown, doesn't tick on rooms: 15 (2-2), 32 (3-8), 43(4-4)
	double y1IGT2:		0x0059E504, 0x0, 0x13C, 0x140, 0x4, 0x130;	//10s countdown, works on most levels including the above, but missing some others
	double finaleIGT:	0x0034D464, 0x1F8, 0xC, 0x13C, 0x4, 0x130;	//50s countdown on the last screen
}

startup {
	settings.Add("1areasplits", true, "Split on area change");
	settings.Add("1levelsplits", false, "Split on level change");
}

init {	
	vars.IGT = 0;
}
	

update {
	
		if (current.roomID == 15 || current.roomID == 32 || current.roomID == 43) {
			if (current.y1IGT2 != old.y1IGT2 && current.y1IGT2 != 0) {			//add a second to IGT whenever a second ticks in-game
				vars.IGT = vars.IGT + 1;						//but not when IGT is 0,
			}										//as that adds an extra second every area transition
		}

		else {
			if (current.y1IGT != old.y1IGT && current.y1IGT != 0 && old.y1IGT != 0) {				//add a second to IGT whenever a second ticks in-game
				vars.IGT = vars.IGT + 1;									//but not when IGT is 0,
			}
		}	
		
		if (current.finaleIGT != old.finaleIGT && current.finaleIGT != 0 && old.finaleIGT != 0 && current.roomID == 50) {		//same as above but for the last screen
			vars.IGT = vars.IGT + 1;																//as that uses a different address for its IGT
		}																							
		
}
	
start {
	if (current.roomID == 3 && old.roomID == 1) {
		vars.IGT = 0;
		return true;
	}
}

split {
	//area splits
	if (settings["1areasplits"] == true) {
		if (current.roomID == 36 && old.roomID == 13 || current.roomID == 37 && old.roomID == 24 || current.roomID == 38 && old.roomID == 35) {
			return true;
		}
	}
		
	//level splits
	if (settings["1levelsplits"] == true) {
		if (current.roomID != old.roomID && current.roomID != 1 && old.roomID != 1) {
			return true;
		}
	}
	
	//final split
	if (current.roomID == 50 && current.hasControl == 1 && old.hasControl == 0) {
		return true;
	}
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(vars.IGT);
}
