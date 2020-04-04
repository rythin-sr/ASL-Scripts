//Crazy Machines 1.5: Inventors Training Camp Autosplitter by rythin
//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("cm_family", "Steam") {
	string4	levelName:			0x00113D64, 0x10, 0x28, 0x4, 0x14, 0x2C;
	string4 levelName2:			0x00113D64, 0x10, 0x64;
	int	endTextbox:			0x00110178, 0xE0, 0x54;
	int	tbWatcher:			0x1117BC;
	double	timeScore:			0x00113D64, 0x10, 0x2C, 0x0, 0x14, 0xD0;			
	double	timeScore2:			0x00113D64, 0x10, 0xC, 0x118;						//score counter that ticks down every second in-game

	//it appears that randomly one of the levelName and timeScore pointer paths breaks,
	//and then the other works. yea i dont get it either
}

startup {
	settings.Add("gt", false, "Enable game time comparsion (may cause crashes)");
}

init {  
	vars.IGT = 0;
}

update {
	if (settings["gt"] == true) {
		if (Math.Truncate(current.timeScore) < Math.Truncate(old.timeScore) && current.timeScore != 0) {
			vars.IGT = vars.IGT + 1;
		}
		
		if (Math.Truncate(current.timeScore2) < Math.Truncate(old.timeScore2) && current.timeScore2 != 0) {
			vars.IGT = vars.IGT + 1;
		}
	}
}

start {
	if (current.tbWatcher == 1 && old.tbWatcher == 0) {
		if (current.levelName == "Foot" || current.levelName == "Test") {
			vars.IGT = 0;
			return true;
		}
		
		if (current.levelName2 == "Foot" || current.levelName2 == "Test") {
			vars.IGT = 0;
			return true;
		}
	}
}
	
split {
	if (current.endTextbox == 1 && old.endTextbox == 0) {	
		return true;
	}	
}

isLoading {
	if (settings["gt"] == true) {
		return true;
	}
}

gameTime {
	if (settings["gt"] == true) {
		return TimeSpan.FromSeconds(vars.IGT);
	}
}
