//YH10S3 Autosplitter by rythin
//Shit's jank as fuck, not tested excessively and prone to breaking
//Game's shit to work on asl stuff in sorry
//Probably won't be doing much more with it

state("You Have 10 Seconds 3") {
	//bro this game fucking blows
	int runStart:		0x3DBFBC; 					//changes from 0 to 1 upon run start
	int levelState:		0x0040761C, 0x0, 0x404, 0x2C, 0xCC; 		//2 between screens and on the last screen?
	int inHub:		0x0040761C, 0x0, 0x474, 0x2C, 0xCC;		//0 when in level, 1 in hub
	int credits:		0x0040761C, 0x0, 0x51C, 0x2C, 0xCC; 		//1 when credits activate, 0 otherwise
}

init {
	vars.yh3SplitCounter = 0;
}

update {
	if (current.inHub == 1 && old.inHub == 0) {						//for now this is only useful for better autostart
			vars.yh3SplitCounter = vars.yh3SplitCounter + 1;	//maybe in the future ill do fancy stuff with it
	}
}

start {
	if (current.runStart == 0 && old.runStart == 1) {
		vars.yh3SplitCounter = 0;
		return true;
	}
}

split {
	//area splits
	if (current.inHub == 1 && old.inHub == 0 && vars.yh3SplitCounter >= 1) {
		return true;
	}
		
	//final split
	if (current.credits == 1 && old.credits == 0) {
		return true;
	}
}
