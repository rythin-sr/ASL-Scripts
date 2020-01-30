// Legend of Xenia autosplitter by rythin
//

state("LowRezJam2016") {
	float posX:		0x5A9310;		//start at 64
	float posY:		0x3859C0;		//start at 184
	int roomID:		0x59D310;		//start = 0, last room = 12
}

init {
	vars.splitCounter = 0;
	
	if (modules.First().ModuleMemorySize == 6221824) {
		version = "1.0";
	}
	
	if (modules.First().ModuleMemorySize == 6512640) {
		version = "1.1";
	}
}

startup {
	// setting categories
	settings.Add("roomidsplits", false, "Area Splits");
	settings.Add("misc", false, "Misc Splits");

	// level change splits											   1.0	     |	  1.1
	settings.Add("sshrine", false, "Southern Shrine -> Austral Beach", "roomidsplits");			//1 -> 0     |
	settings.Add("thicket", false, "Austral Beach -> Mucky Thicket", "roomidsplits"); 			//0 -> 2     |
	settings.Add("hamlet", false, "Mucky Thicket -> Island Hamlet", "roomidsplits");			//2 -> 3     |
	settings.Add("magesplit", false, "Old Mage's House -> Island Hamlet", "roomidsplits");			//6 -> 3     |
	settings.Add("ebanks", false, "Island Hamlet -> Western Banks", "roomidsplits");			//3 -> 9     |
	settings.Add("lbanks", false, "Western Banks -> Island Hamlet", "roomidsplits");			//9 -> 3     |
	settings.Add("ewoods", false, "Island Hamlet -> Haunted Woods", "roomidsplits");			//3 -> 8     |
	settings.Add("lwoods", false, "Haunted Woods -> Island Hamlet", "roomidsplits");			//8 -> 3     |
	settings.Add("doorroom", false, "Island Hamlet -> Ancient Gated Path", "roomidsplits");			//3 -> 11    |	3 -> 10
	settings.Add("doorsplit", false, "Ancient Gated Path -> Northern Springs", "roomidsplits");		//11 -> 12   |	10 -> 11
	
	//misc splits
	settings.Add("keysplit", false, "Split when refreshing the key", "misc");
	settings.Add("shrinesplit", false, "Split when leaving a shrine (relevant for 100%)", "misc");
	settings.Add("keypickup", false, "Split when picking up keys (Western Banks & Mucky Thicket only", "misc"); 
	
}

update {
	if (current.roomID == 2 && old.roomID == 0) {	//counter used for key refresh splits
		vars.splitCounter = vars.splitCounter + 1;
	}
}

start {	//timing on first movement up or right, since you'd never move down or left first 
	if (current.roomID == 0) {
		if (current.posX == 65 && old.posX == 64 || current.posY == 183 && old.posY == 184) {
			vars.splitCounter = 0;
			return true;
		}
	}
}

split {

	//shrinesplit
	if (settings["shrinesplit"] == true) {
		if (current.posX >= 52 && current.posX <= 60 && old.posY == 140 && current.posY == 141 && current.roomID == 1) {
			return true;
		}
	
		if (current.posX >= -4 && current.posX <= 4 && old.posY == 356 && current.posY == 357 && current.roomID == 9) {
			return true;
		}
	
		if (current.posX >= 180 && current.posX <= 188 && old.posY == 4 && current.posY == 5 && current.roomID == 3) {
			return true;
		}
	
		if (current.posX >= 172 && current.posX <= 180 && old.posY == 252 && current.posY == 253 && current.roomID == 8) {
			return true;
		}
	}
	
	//keypickup
	if (settings["keypickup"] == true) {
		if (current.posX >= -8 && current.posX <= -4 && old.posY == 80 && current.posY == 81 && current.roomID == 9) {
			return true;
		}
	
		if (current.posY >= 125 && current.posY <= 145 && old.posX == 407 && current.posX == 408 && current.roomID == 2) {
			return true;
		}
	}

	//Southern Shrine -> Austral Beach
	if (settings["sshrine"] == true && old.roomID == 1 && current.roomID == 0) {
		return true;
	}
	
	//Austral Beach -> Mucky Thicket
	if (settings["thicket"] == true && old.roomID == 0 && current.roomID == 2 && vars.splitCounter < 2) {
		return true;
	}
	
	//key refresh split
	if (settings["keysplit"] == true) {
		if (vars.splitCounter > 1) {
			if (current.roomID == 2 && old.roomID == 0) {
				return true;
			}
		}
	}
	
	//Mucky Thicket -> Island Hamlet
	if (settings["hamlet"] == true && old.roomID == 2 && current.roomID == 3) {
		return true;
	}
	
	//Old Mage's House -> Island Hamlet
	if (settings["magesplit"] == true && old.roomID == 6 && current.roomID == 3) {
		return true;
	}
	
	//Island Hamlet -> Western Banks
	if (settings["ebanks"] == true && old.roomID == 3 && current.roomID == 9) {
		return true;
	}
	
	//Western Banks -> Island Hamlet
	if (settings["lbanks"] == true && old.roomID == 9 && current.roomID == 3) {
		return true;
	}
	
	//Island Hamlet -> Haunted Woods
	if (settings["ewoods"] == true && old.roomID == 3 && current.roomID == 8) {
		return true;
	}
	
	//Haunted Woods -> Island Hamlet
	if (settings["lwoods"] == true && old.roomID == 8 && current.roomID == 3) {
		return true;
	}
	
	//for whatever reason the room number for the last 2 rooms changed between 1.0 and 1.1
	
	if (version == "1.0") {
	
		//Island Hamlet -> Ancient Gated Path
		if (settings["doorroom"] == true && old.roomID == 3 && current.roomID == 11) {
			return true;
		}
	
		//Ancient Gated Path -> Northern Springs
		if (settings["doorsplit"] == true && old.roomID == 11 && current.roomID == 12) {
			return true;
		}
	
		//final split
		if (old.roomID == 12 && current.roomID == 0) {
			return true;
		}
	}
	
	if (version == "1.1") {
	
		//Island Hamlet -> Ancient Gated Path
		if (settings["doorroom"] == true && old.roomID == 3 && current.roomID == 10) {
			return true;
		}
	
		//Ancient Gated Path -> Northern Springs
		if (settings["doorsplit"] == true && old.roomID == 10 && current.roomID == 11) {
			return true;
		}
	
		//final split
		if (old.roomID == 11 && current.roomID == 0) {
			return true;
		}
	}
	
}
