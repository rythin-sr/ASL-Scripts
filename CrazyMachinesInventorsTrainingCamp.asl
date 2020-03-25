//Crazy Machines 1.5: Inventors Training Camp Autosplitter by rythin

state("cm_family", "PL Retail") {
	int 	textboxWatcher: 	0x112794;
	string4 levelName: 			0x00112D28, 0x4, 0x10, 0x64;
	int 	endTextbox: 		0x0011111C, 0xE8, 0x8, 0xD4, 0x1A4;
}

state("cm_family", "Steam") {
	string4	levelName:			0x00113D64, 0x10, 0x28, 0x4, 0x14, 0x2C;
	int		endTextbox:			0x00110178, 0xE0, 0x54;
}

init {  

	if (modules.First().ModuleMemorySize == 1482752) {
		version = "Steam";
	}

	if (modules.First().ModuleMemorySize == 1142784) {
		version = "PL Retail";
	}
}

start {
		return (current.levelName == "Tren" || current.levelName == "Spra" ||
		current.levelName == "Foot" || current.levelName == "Test");
}
	
split {
	//split after finishing a level
	if (current.endTextbox == 0 && old.endTextbox == 1) {	
		return true;
	}
	
	//final split
	if (current.endTextbox == 1 && old.endTextbox == 0) {
		if (current.levelName == "WIEL" || current.levelName == "GRAN") {
			return true;
		}
	}	
}