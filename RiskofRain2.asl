//Risk of Rain 2 Autosplitter + Load Remover by rythin

//INSTALL INSTRUCTIONS:
//Go to Edit Splits in LiveSplit
//Set the game name to "Risk of Rain 2"
//Click "Activate"
//You can change the settings as you wish, though it is recommended to keep autostart and at least the last split enabled
//Make sure to exit out of the Edit Splits menu by pressing OK, and not the red X. IF YOU DO NOT PRESS "OK", THE CHANGES WILL NOT BE SAVED

//Changelog: 
//(13/04/2020) 1.0 - initial release, autosplitting and sketchy load removal through unity log
//(13/08/2020) 2.0 - full game released, switched load removal over to an actual address
//(14/08/2020) 2.1 - switched autosplitting to actual addresses aswell, reading logs is slow
//(14/08/2020) 2.1.1 - bugfixes, bugfixes, bugfixes
//(21/08/2020) 2.1.2 - added extra load removal address as the first one didnt work for 1 (one) person in the community
//(31/08/2020) 2.1.2.1 - added install instructions, cleaned up some extra settings
//(03/09/2020) 2.2 - added version detection and support for 1.0.1, added extra splitting setting

state("Risk of Rain 2", "1.0.0") {
	
	//1 from fade-out to the moment the next stage loads, 0 otherwise
	byte load: 		"mono-2.0-bdwgc.dll", 0x04A1C90, 0x280, 0x0, 0x1E0, 0x40;
	
	//the above address didn't work for a singular person in the community, so adding this one just for them lol
	byte load2:		"mono-2.0-bdwgc.dll", 0x0491DC8, 0x58, 0x160, 0x160, 0x160, 0x160, 0x160, 0xBF0;
	
	int stageCount:	"mono-2.0-bdwgc.dll", 0x0491DC8, 0x28, 0x50, 0x6B0;
	
	//0 in title and lobby, some random number in other stages
	//i just realised its a sound engine thing, yeah no clue either. it works for what i need it so good enough for me
	int inGame:		"AkSoundEngine.dll", 0x20DC04;
}

state("Risk of Rain 2", "1.0.1") {
	byte load:		"mono-2.0-bdwgc.dll", 0x0491DC8, 0x58, 0x160, 0x160, 0x160, 0x160, 0x160, 0xBF0;
	byte load2:		"mono-2.0-bdwgc.dll", 0x049C218, 0x108, 0x80, 0x20, 0x78, 0x8C, 0x38;
	int stageCount:		"mono-2.0-bdwgc.dll", 0x0491DC8, 0x28, 0x50, 0x660;
	int inGame:		"AkSoundEngine.dll", 0x20DC04;
}

startup {

	settings.Add("stages", true, "Stages");
	settings.SetToolTip("stages", "The settings below indicate the END of which stage to split on. I.E. ticking \"Sky Meadow\" will split at the end of Sky Meadow etc.");

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
	
	settings.SetToolTip("1", "Splits when entering the Bazaar. Due to current limitations splitting after bazaar automatically is not possible");

	settings.Add("alwaysSplit", false, "Ignore the above setting and split on every stage counter increase (and credits)");
	
	//variable used to set the offset of the timer start, to account for timing rules
	vars.setOffset = false;
	
	//timing method reminder from Amnesia TDD autosplitter, all credits to those guys
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {        
        	var timingMessage = MessageBox.Show (
          		"This game uses Loadless (time without loads) as the main timing method.\n"+
          		"LiveSplit is currently set to show Real Time (time INCLUDING loads).\n"+
          		"Would you like the timing method to be set to Loadless for you?",
         		"RoR2 Autosplitter | LiveSplit",
         		MessageBoxButtons.YesNo,MessageBoxIcon.Question
       		);
		
        	if (timingMessage == DialogResult.Yes) {
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
}

init {

	string dll_path = modules.First().FileName + "\\..\\Risk of Rain 2_Data\\Managed\\Assembly-CSharp.dll";
	
	long dll_size = new System.IO.FileInfo(dll_path).Length;
 
	//print("ROR2ASL: Version: " + dll_size.ToString()); 
	
	//[17256] ROR2ASL: Version: 2858496 - 1.0.0.6
	//[17256] ROR2ASL: Version: 2865664 - 1.0.1.1

	switch (dll_size) {
	
		case 2858496:
		version = "1.0.0";
		break;
		
		case 2865664:
		version = "1.0.1";
		break;
		
		default:
		version = "Unrecognised";
		break;
	}
}

start {
	if (current.inGame != 0 && old.inGame == 0) {
		vars.setOffset = true;
		return true;
	}
}

reset {
	if (current.inGame != 0 && old.inGame == 0 && current.stageCount < 4) {
		vars.setOffset = true;
		return true;
	}
}

split {
	if (current.stageCount == old.stageCount + 1 && current.stageCount > 1) {
		
		if (settings["alwaysSplit"]) {
			return true;
		}
		
		if (!settings["alwaysSplit"] && settings[old.stageCount.ToString()]) {
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
	//using 2 different load addresses, mostly because unity sucks and one only works for some people and the combination of these two seems to work for everyone
	return (current.load == 1 || current.load2 == 1);
}
