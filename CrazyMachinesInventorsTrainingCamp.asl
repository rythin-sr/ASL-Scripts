//Crazy Machines 1.5: Inventors Training Camp Autosplitter by rythin

state("cm_family", "PL Retail") {
	int 	tbWatcher: 			0x112794;							//tb on screen = 1, else 0
	string4 levelName: 			0x00114D44, 0x10, 0x28, 0x4, 0x14, 0x2C;			//level name (duh)
	int 	endTextbox: 			0x0011111C, 0xE8, 0x8, 0xD4, 0x1A4;				//same as tbWatcher but only for the tb at the end of a level
}

state("cm_family", "Steam") {
	string4	levelName:			0x00113D64, 0x10, 0x28, 0x4, 0x14, 0x2C;
	string4 levelName:			0x00113D64, 0x10, 0x64;
	int	endTextbox:			0x00110178, 0xE0, 0x54;
	int	tbWatcher:			0x1117BC;
	double	timeScore:			0x00113D64, 0x10, 0xC, 0x118;					//score counter that ticks down every second in-game
}

startup {
	settings.Add("allsplit", true, "Split on every level");
	settings.Add("testsplit", false, "Split on completing Tests");
}

init {  

	if (modules.First().ModuleMemorySize == 1482752) {
		version = "Steam";
	}

	if (modules.First().ModuleMemorySize == 1142784) {
		version = "PL Retail";
	}	

	vars.IGT = 0;
	
}

update {
	if (Math.Truncate(current.timeScore) < Math.Truncate(old.timeScore)) {
		//print(Math.Truncate(current.timeScore).ToString());
		//print("e");
		//print(Math.Truncate(old.timeScore).ToString());
		vars.IGT = vars.IGT + 1;
	}
}

start {
		if (current.tbWatcher == 1 && old.tbWatcher == 0) {
			if (current.levelName == "Tren" || current.levelName == "Spra" || current.levelName == "Foot" || current.levelName == "Test") {
				vars.IGT = 0;
				return true;
			}
		}
}
	
split {
	//split after finishing a level
	if (settings["allsplit"] == true) {
		if (current.endTextbox == 0 && old.endTextbox == 1) {	
			return true;
		}
	}
	
	//split after finishing a test
	if (settings["testsplit"] == true && settings["allsplit"] == false) {
		if (old.levelName == "Test" || old.levelName == "Fina" || old.levelName == "Spra") {
			if (current.endTextbox == 0 && old.endTextbox == 1) {
				return true;
			}
		}
	}
	
	//final split
	if (current.endTextbox == 1 && old.endTextbox == 0) {
		if (current.levelName == "WIEL" || current.levelName == "GRAN") {
			return true;
		}
	}	
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(vars.IGT);
}
