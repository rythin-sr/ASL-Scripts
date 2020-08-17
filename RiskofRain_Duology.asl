//Risk of Rain Duofecta Autosplitter + Load Remover by rythin
//fix it fuckface

state("Risk of Rain 2") {
	
	//1 from fade-out to the moment the next stage loads, 0 otherwise
	byte load: 		"mono-2.0-bdwgc.dll", 0x04A1C90, 0x280, 0x0, 0x1E0, 0x40;
	
	int stageCount:	"mono-2.0-bdwgc.dll", 0x0491DC8, 0x28, 0x50, 0x6B0;
	
	//0 in title and lobby, some random number in other stages
	//i just realised its a sound engine thing, yeah no clue either. it works for what i need it so good enough for me
	int inGame:		"AkSoundEngine.dll", 0x20DC04;
}

state("ROR_GMS_controller") {
	int roomID: 		0x2BED7A8; 						//1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41 | cutscenes: 1 & 9
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;			//goes from 0 to 1 when you Press 'A' to leave the planet
	double gameTime:	0x02BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

state("Risk of Rain") {
	int roomID: 		0x2BED7A8; 						//1st stages: 18, 23, 22, 21, 19, 20 | last stage: 41 | cutscenes: 1 & 9
	int runEnd:		0x02BEB5E0, 0x0, 0x548, 0xC, 0xB4;			//goes from 0 to 1 when you Press 'A' to leave the planet
	double gameTime:	0x02BEB5E0, 0x0, 0x28, 0xC, 0xBC, 0x8, 0x0, 0x720, 0x8, 0x1EC0;
}

startup {

	settings.Add("ror1", true, "Risk of Rain");
	settings.Add("ror2", true, "Risk of Rain 2");

	settings.Add("levelsplits", true, "Split between levels", "ror1");
	
	settings.Add("stages", true, "Stages", "ror2");

	vars.l = new Dictionary<int, string> {
		{1,"Titanic Plains/Distant Roost"},
		{2,"Abandoned Aqueduct/Wetlands Aspect"},
		{3,"Rallypoint Delta/Scorched Acres"},
		{4,"Siren's Call/Abyssal Depths"},
		{5,"Sky Meadow"},
		{6,"Commencement"}
	};

	foreach (var Tag in vars.l) {							
		settings.Add(Tag.Key.ToString(), true, Tag.Value, "stages");					
    };
	
	settings.SetToolTip("1", "Splits when entering the Bazaar. Due to current limitations splitting after bazaar is not possible");

	//variable used to set the offset of the timer start, to account for timing rules
	vars.setOffset = "off";
	
	//variable to pause the timer when switching games
	vars.isSwitchingGames = false;
	
	//variable to keep track of if one game was finished before, for auto-reset purposes
	vars.canReset = true;
}

update {
	if (vars.canReset == false) {	//if we're on the 2nd game, start condition unpauses the timer
		if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
			if (old.roomID == 6 && current.roomID != 6 || old.roomID == 40 && current.roomID != 40 || old.roomID == 7 && current.roomID != 7) {
				if (current.roomID != 2) {
					vars.isSwitchingGames = false;
				}
			}
		}
	
		if (game.ProcessName == "Risk of Rain 2") {
			if (current.inGame != 0 && old.inGame == 0) {
				vars.isSwitchingGames = false;
			}
		}
	}
}

start {
	if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
		if (old.roomID == 6 && current.roomID != 6 || old.roomID == 40 && current.roomID != 40 || old.roomID == 7 && current.roomID != 7) {
			if (current.roomID != 2) {
				vars.setOffset = "ror1";
				vars.canReset = true;
				vars.isSwitchingGames = false;
				return true;
			}
		}
	}
	
	if (game.ProcessName == "Risk of Rain 2") {
		if (current.inGame != 0 && old.inGame == 0) {
			vars.setOffset = "ror2";
			vars.canReset = true;
			vars.isSwitchingGames = false;
			return true;
		}
	}
}

reset {
	if (vars.canReset == true) {
		if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
			return (current.roomID == 2 || current.roomID == 40);
		}
		
		if (game.ProcessName == "Risk of Rain 2") {
			if (current.inGame != 0 && old.inGame == 0 && current.stageCount < 4) {
				vars.setOffset = true;
				return true;
			}
		}
	}
}

split {
	if (vars.isSwitchingGames == false) {
		if (game.ProcessName == "Risk of Rain" || game.ProcessName == "ROR_GMS_controller") {
			//ror1 area splits
			if (current.roomID != old.roomID && 												//when room changes
			current.roomID != 2 && old.roomID != 6 && old.roomID != 2 && old.roomID != 40 && 	//and is not one of the menus
			old.roomID != 9 && old.roomID != 1 && old.roomID != 0 && 							//nor the cutscenes on game startup
			settings["levelsplits"] == true) {													//and setting is on
				return true;																	//split
			}
	
			//ror1 final split
			if (current.roomID == 41 && current.runEnd == 1 && old.runEnd == 0) {
				vars.canReset = false;
				vars.isSwitchingGames = true;
				return true;
			}
		}
	
		if (game.ProcessName == "Risk of Rain 2") {
			//ror2 area splits
			if (current.stageCount == old.stageCount + 1) {
				if (settings[old.stageCount.ToString()]) {
					return true;
				}
			}
	
			//ror2 final split
			if (current.stageCount == 7 && old.stageCount == 6) {
				vars.isSwitchingGames = true;
			}
		}
	}
}

gameTime {
	if (vars.setOffset == "ror2") {
		vars.setOffset = "off";
		return TimeSpan.FromSeconds(-0.56);
	}
}
		
isLoading {
	if (vars.isSwitchingGames == true) {
		return true;
	}
	
	if (game.ProcessName == "Risk of Rain 2") {
		return (current.load == 1);
	}
}
