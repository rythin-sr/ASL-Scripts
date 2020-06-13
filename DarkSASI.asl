//Dark SASI Autosplitter + Load Remover by rythin

state("Dark_SASI-Win64-Shipping") {
	//counter going up by 1 every frame, game is frozen when loading, so counter freezes aswell
	//currently unused
	byte c:	0x27C1154;	
	
	//consistent value depending on what level youre on, 0 in loads
	int l:	0x293C1D8;
}

//map name - value
//Lvl1Babka	- 15
//lvl2Dundeon - 8
//LVL3_Ruins - 12
//LVL4_Konec - 8 again???

startup {
	//settings for splits since i cba setting up a dictionary for this
	settings.Add("1", true, "Lvl1Babka");
	settings.Add("2", true, "lvl2Dundeon");
	settings.Add("3", true, "LVL3_Ruins");
	
	//variables used for final split, i'm sure there's a better way to do this
	vars.startCounter = false;
	vars.counter = 0;
	
	//lower refresh rate to not kill performance during the counter
	refreshRate = 30;
}

start {
	if (current.l == 15 && old.l == 0) {
		vars.lastLev = 15;
		vars.startCounter = false;
		vars.counter = 0;
		return true;
	}
}

update {
	//since the final split happens during a particular moment in the last cutscene
	//there isn't really a value you could use to detect when it happens
	//(at least i dont think so)
	//so this counter, going up 1 30 times a second will have to do
	if (vars.startCounter == true) {
		vars.counter++;
	}
}

split {
	if (current.l == 8 && vars.lastLev == 15) {
		vars.lastLev = 8;
		if (settings["1"]) {
			return true;
		}
	}
	
	if (current.l == 12 && vars.lastLev == 8) {
		vars.lastLev = 12;
		if (settings["2"]) {
			return true;
		}
	}

	if (current.l == 8 && vars.lastLev == 12) {
		vars.lastLev = 8;
		vars.startCounter = true;
		if (settings["3"]) {
			return true;
		}
	}
	
	//final split
	//using the counter to measure what seems to be ~37 seconds
	//which btw i swear this should be like around 50 seconds but from my testing this
	//seems to work fine so idk shits wack
	if (vars.counter > (1115)) {
		vars.startCounter = false;
		return true;
	}
}

isLoading {
	return (current.l == 0);
}
