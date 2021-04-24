state("Legbreaker", "1.0") {
	int roomID: 0x1A71CC8, 0xE8, 0x3D8, 0x148, 0x50, 0x18;
}

state("Legbreaker", "1.1") {
	int roomID: 0x1FA7238, 0xE8, 0x640, 0x10, 0x50, 0x18;
}

startup {
	settings.Add("areasplit", true, "Split between areas");
}

init {
	//print(modules.First().ModuleMemorySize.ToString());
	
	vars.validID = new List<int>{170, 175, 172, 181, 148, 119, 134, 154, 147, 189, 188, 199, 174, 132, 
	128, 190, 164, 167, 142, 131, 169, 162, 144, 198, 115, 137, 0, 143, 108, 146, 168, 192};
	
	//initially meant to have separate lists for each patch, decided to combine the two instead but keeping the list of 1.1 levels just in case
	//the four last entries in the above list are the only ones exclusive to 1.1, otherwise the values repeat or are exclusive to 1.0
	//vars.validID11 = new List<int>{170, 172, 181, 147, 148, 119, 134, 108, 154, 189, 188, 192, 142, 174, 128, 146, 164, 168, 131, 169, 143, 162, 144, 198, 115, 0}; 
	
	switch (modules.First().ModuleMemorySize) {
		case 28053504:
		version = "1.0";
		break;
		
		case 33525760:
		version = "1.1";
		break;
	}
}	

start {
	return ((old.roomID == 5398 || old.roomID == 5342) && current.roomID != old.roomID);
}

split {
	if (current.roomID != old.roomID && vars.validID.Contains(current.roomID)) 
		current.realID = current.roomID;
	
	//area splits
	if (settings["areasplit"]) {															
		if (current.realID != old.realID && old.realID == 0 && current.realID != 170) { //dialogue-based area changes
			return true;	
		}
		
		if (old.realID == 143 && current.realID == 169) {                               //final area entry
			return true;
		}
	}
	
	//level splits
	/* currently broken, maybe i will fix at some point in the future
	if (settings["l"] && current.realID != old.realID && current.realID != 0 && old.realID != 0) {
		print(old.realID + " -> " + current.realID);
		return true;
	}
	*/
	//final split
	if (old.roomID == 143 && current.roomID == 0 || old.roomID == 115 && current.roomID == 0) {	
		return true;
	}
}
