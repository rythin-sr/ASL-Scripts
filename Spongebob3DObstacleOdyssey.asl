//Spongebob Squarepants: 3D Obstacle Odyssey Autosplitter by rythin
//Currently starts the timer later than already established rules and stops it earlier
//However, i would advise for the rules to change as this method of timing makes more sense for an RTA speedrun
//(timing starting AFTER the first load, minimising hardware differences)

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("sboo") {
	//board you're currently on, 25 on stage end screen, 1 in menus
	int board:	0x0012ABC0, 0xA8, 0x6C;
	int igt:	0x0012ABC0, 0x4C, 0x290;
}

startup {
	vars.dispIGT = 0;
	settings.Add("all", true, "Split on completing every level");
	settings.Add("3", false, "Split on completing a stage");
}

update {
	if (current.igt == old.igt - 1) {
		vars.dispIGT++;
	}
}	

start {
	if (current.board == 1 && old.igt == 0) {
		if (current.igt == 99 || current.igt == 75) {
			vars.dispIGT = 0;
			return true;
		}
	}	
}

split {
	if (settings["all"] == true) {
		if (current.board == old.board + 1) {
			return true;
		}
	}
	
	if (settings["all"] == false && settings["3"] == true) {
		if (current.board == 25 && old.board == 24) {
			return true;
		}
	}	
}

reset {
	//autoreset currently broken
	if (current.board == 1 && old.board != 25 && old.board != 1) {
		if (current.igt == 0 && old.igt != 1) {
			return true;
		}
	}
}

isLoading {
	return true;
}

gameTime {
	//IGT for fun mostly, RTA still should be used as the main timing method
	return TimeSpan.FromSeconds(vars.dispIGT);
}
