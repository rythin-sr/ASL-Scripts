// Made by rythin, contact in case you encounter any issues: 

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr


state("AxySnake") {
	int levelID: 0x787A0;
	int hasControl: 0x00020A7C, 0x148;
	int lostControl: 0x7870C;
	int snakeChosen: 0xDE4FC;
	int diffChosen: 0x79DB4;
}

start {
	return (current.snakeChosen == 1 && old.snakeChosen == 0);
	}
	
split {

// since the final split happens on control lost, and normal splitting happens on level change
// i need to determine which level is the last, that happens by looking at the difficulty chosen
// 0 and 3 are the 5 level difficulties, 1 and 4 - 15 level and 2 and 5 - 20

	if (current.diffChosen == 0 || current.diffChosen == 3) {
		if (current.levelID == 5 && current.lostControl == 1 && old.lostControl == 0) {
			return true;
		}
	}
	
	if (current.diffChosen == 1 || current.diffChosen == 4) {
		if (current.levelID == 15 && current.lostControl == 1 && old.lostControl == 0) {
			return true;
		}
	}
		
	if (current.diffChosen == 2 || current.diffChosen == 5) {
		if (current.levelID == 20 && current.lostControl == 1 && old.lostControl == 0) {
			return true;
		}
	}
	
// split between level transitions
	
	if (old.levelID != current.levelID && current.hasControl == 0 && current.levelID != 1) {
		return true;
	}
	
}


