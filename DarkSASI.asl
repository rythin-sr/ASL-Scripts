//Dark SASI Autosplitter + Load Remover by rythin

state("Dark_SASI-Win64-Shipping") {
	//counter going up by 1 every frame, game is frozen when loading, so counter freezes aswell
	//currently unused
	byte c:	0x27C1154;	
	
	//consistent value depending on what level youre on, 0 in loads
	int l:	0x293C1D8;
}

//Lvl1Babka	- 15
//lvl2Dundeon - 8
//LVL3_Ruins - 12
//LVL4_Konec - 8 again???

startup {
	settings.Add("1", true, "Lvl1Babka");
	settings.Add("2", true, "lvl2Dundeon");
}

start {
	if (current.l == 15 && old.l == 0) {
		vars.lastLev = 15;
		return true;
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
		return true;
	}
}

isLoading {
	return (current.l == 0);
}