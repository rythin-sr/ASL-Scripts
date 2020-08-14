//Risk of Rain 2 Autosplitter + Load Remover by rythin

//Changelog: 
//(13/04/2020) 1.0 - initial release, autosplitting and sketchy load removal through unity log
//(13/08/2020) 2.0 - full game released, switched load removal over to an actual address
//(14/08/2020) 2.1 - switched autosplitting to actual addresses aswell, reading logs is slow

state("Risk of Rain 2") {
	
	//1 from fade-out to the moment the next stage loads, 0 otherwise
	byte load: 		"mono-2.0-bdwgc.dll", 0x04A1C90, 0x280, 0x0, 0x1E0, 0x40;
	
	int stageCount:	"mono-2.0-bdwgc.dll", 0x0491DC8, 0x28, 0x50, 0x6B0;
	
	//0 in title and lobby, some random number in other stages
	//i just realised its a sound engine thing, yeah no clue either. it works for what i need it so good enough for me
	int inGame:		"AkSoundEngine.dll", 0x20DC04;
}

startup {

	settings.Add("stages", true, "Stages");
	settings.Add("reset", false, "Auto-reset the timer when starting a new run.");
	settings.SetToolTip("reset", "This option has not been tested. It may reset the timer in the middle of the run. Someone pls test ty.");

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
	vars.setOffset = false;
}

init {
	
	//timing method reminder from Amnesia TDD autosplitter, all credits to those guys
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {        
        	var timingMessage = MessageBox.Show (
           		"This game uses Loadless (real time without loads) as the main timing method.\n"+
            	"LiveSplit is currently set to show Real Time (time INCLUDING loads).\n"+
            	"Would you like the timing method to be set to Loadless for you?",
           		"RoR2 Autosplitter | LiveSplit",
           		 MessageBoxButtons.YesNo,MessageBoxIcon.Question
       		);
		
        	if (timingMessage == DialogResult.Yes) {
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
	
	//version detection goes here in the future, cba atm
	//if (modules.First().ModuleMemorySize == ) {
	//	version = "1.0";
	//}
}

start {
	if (current.inGame != 0 && old.inGame == 0) {
		vars.setOffset = true;
		return true;
	}
}

reset {
	if (settings["reset"]) {
		if (current.inGame != 0 && old.inGame == 0) {
			vars.setOffset = true;
			return true;
		}
	}
}

split {
	if (current.stageCount == old.stageCount + 1) {
		if (settings[old.stageCount.ToString()]) {
			return true;
		}
	}
}

gameTime {
	//timer offset from the script's starting point to the rule-defined starting point
	if (vars.setOffset == true) {
		vars.setOffset = false;
		return TimeSpan.FromSeconds(-0.56);
	}
}
		
isLoading {
	return (current.load == 1);
}
