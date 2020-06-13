state("bf") {
	//board you're currently on, 25 on stage end screen, 1 in menus
	int board:	0x0012AB80, 0x4C, 0x6C;
	int igt:	0x0012AB80, 0x3B4, 0x108;
	
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

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(vars.dispIGT);
}
