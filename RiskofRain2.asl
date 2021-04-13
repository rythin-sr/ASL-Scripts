//INSTALL INSTRUCTIONS:
//Go to Edit Splits in LiveSplit
//Set the game name to "Risk of Rain 2"
//Click "Activate"
//You can change the settings as you wish, though it is recommended to keep autostart and at least the last split enabled
//Make sure to exit out of the Edit Splits menu by pressing OK, and not the red X. IF YOU DO NOT PRESS "OK", THE CHANGES WILL NOT BE SAVED

state("Risk of Rain 2", "1.0.0") {
	int stageCount:        "mono-2.0-bdwgc.dll", 0x491DC8, 0x28, 0x50, 0x6B0;
	int inGame:            "AkSoundEngine.dll",  0x20DC04;
	string15 scene:        "UnityPlayer.dll", 0x15A95D8, 0x48, 0x40;
	string15 loadingScene: "UnityPlayer.dll", 0x15A95D8, 0x28, 0x0, 0x40;
}

state("Risk of Rain 2", "1.0.1") {
	int stageCount:        "mono-2.0-bdwgc.dll", 0x491DC8, 0x28, 0x50, 0x660;
	int inGame:            "AkSoundEngine.dll",  0x20DC04;
	string15 scene:        "UnityPlayer.dll",    0x15A95D8, 0x48, 0x40;
	string15 loadingScene: "UnityPlayer.dll", 0x15A95D8, 0x28, 0x0, 0x40;
}

state("Risk of Rain 2", "1.1.0.1") {
	int stageCount:        "mono-2.0-bdwgc.dll", 0x491DC8, 0x28, 0x50, 0x6B0;
	int inGame:            "AkSoundEngine.dll", 0x20DC04;
	string15 scene:        "UnityPlayer.dll", 0x15A95D8, 0x48, 0x40;
	string15 loadingScene: "UnityPlayer.dll", 0x15A95D8, 0x28, 0x0, 0x40;
}

state("Risk of Rain 2", "1.1.1.2") {
	int stageCount:        "mono-2.0-bdwgc.dll", 0x491DC8, 0x28, 0xA0, 0x6B0;
	int inGame:            "AkSoundEngine.dll", 0x20DC04;
	string15 scene:        "UnityPlayer.dll", 0x15A95D8, 0x48, 0x40;
	string15 loadingScene: "UnityPlayer.dll", 0x15A95D8, 0x28, 0x0, 0x40;
}

startup {

	settings.Add("fin", false, "Split when entering the final cutscene");
	settings.SetToolTip("fin", "Enabling this setting will disable splitting on stage transitions");
	settings.Add("bazaar", false, "Split when leaving Bazaar Between Time");
	settings.Add("arena", false, "Split when leaving Void Fields");
	settings.Add("goldshores", false, "Split when leaving Gilded Coast");
	settings.Add("artifactworld", false, "Split when leaving Bulwark's Ambry");
	
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
 
	print("ROR2ASL: Version: " + dll_size.ToString()); 
	
	//[17256] ROR2ASL: Version: 2858496 - 1.0.0.6
	//[17256] ROR2ASL: Version: 2865664 - 1.0.1.1
	//[16320] ROR2ASL: Version: 3048960 - 1.1.0.1

	switch (dll_size) {
	
		case 2858496:
		version = "1.0.0";
		break;
		
		case 2865664:
		version = "1.0.1";
		break;
		
		case 3048960:
		version = "1.1.0.1";
		break;
		
		case 3082240:
		version = "1.1.1.2";
		break;
		
		default:
		version = "Unrecognised";
		break;
	}
}

start {
	timer.Run.Offset = TimeSpan.FromSeconds(0);
	
	if (current.inGame != 0 && old.inGame == 0) {
		timer.Run.Offset = TimeSpan.FromSeconds(-0.56);
		return true;
	}
}

reset {
	if (current.inGame != 0 && old.inGame == 0 && current.stageCount < 4) {
		return true;
	}
}

split {
	if (current.scene == null) 
		current.scene = old.scene;

	if (!settings["fin"]) {
		if (current.stageCount == old.stageCount + 1 && current.stageCount > 1) {
			return true;
		}
	} else {
		if (current.scene != old.scene && current.scene == "outro") {
			return true;
		}
	}

	if (current.scene != old.scene && current.scene != "title" && current.scene != "lobby") {
		return settings[old.scene];
	}
}

isLoading {
	return (current.scene != current.loadingScene);
}

exit {
	timer.Run.Offset = TimeSpan.FromSeconds(0);
}
