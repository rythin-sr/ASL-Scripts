state("Risk of Rain 2", "1.0") {	
	
	//0 in title and lobby, -1 in other stages
	int inGame:     "AkSoundEngine.dll",  0x20DC04;
	
	string15 scene: "UnityPlayer.dll",    0x15A95D8, 0x48, 0x40;
}

state("Risk of Rain 2", "1.1+") {
	int inGame:            "AkSoundEngine.dll", 0x20DC04;
	string15 scene:        "UnityPlayer.dll", 0x15A95D8, 0x48, 0x40;
}

startup {

	settings.Add("fin", false, "Don't split on stage transitions");
	settings.SetToolTip("fin", "Will still split when entering the final cutscene, just not between stages.");
	settings.Add("bazaar", false, "Split when leaving Bazaar Between Time");
	settings.Add("arena", false, "Split when leaving Void Fields");
	settings.Add("goldshores", false, "Split when leaving Gilded Coast");
	settings.Add("artifactworld", false, "Split when leaving Bulwark's Ambry");
	
	//timing method reminder from Amnesia TDD autosplitter, all credits to those guys
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {        
        	var timingMessage = MessageBox.Show (
          		"This game uses time without loads as the main timing method.\n"+
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
	var dll_size = new System.IO.FileInfo(modules.First().FileName + @"\..\Risk of Rain 2_Data\Managed\Assembly-CSharp.dll").Length;
	vars.watchers = new MemoryWatcherList();
		
	if (dll_size < 3000000 ) {
		version = "1.0";
		vars.watchers.Add(new MemoryWatcher<float>(new DeepPointer("mono-2.0-bdwgc.dll", 0x4940B8, 0x10, 0x1D0, 0x8, 0x4E0, 0x1E10, 0xD0, 0x8, 0x60, 0xC)) { Name = "fade" });
		vars.watchers.Add(new MemoryWatcher<int>(new DeepPointer("mono-2.0-bdwgc.dll", 0x4940B8, 0x10, 0x1D0, 0x8, 0x4E0, 0x2688, 0x108, 0xD0, 0x8, 0x1A0, 0x0, 0x140)) { Name = "stage" });
	} else {
		version = "1.1+";
		vars.watchers.Add(new MemoryWatcher<float>(new DeepPointer("mono-2.0-bdwgc.dll", 0x4940B8, 0x10, 0x1D0, 0x8, 0x4E0, 0x1E88, 0x108, 0xD0, 0x8, 0x60, 0xC)) { Name = "fade" });
		vars.watchers.Add(new MemoryWatcher<int>(new DeepPointer("mono-2.0-bdwgc.dll", 0x4940B8, 0x10, 0x1D0, 0x8, 0x4E0, 0x27A0, 0x108, 0xD0, 0x8, 0x1A0, 0x0, 0x150)) { Name = "stage" });
	}
}

update {
	vars.watchers.UpdateAll(game);
	current.stageCount = vars.watchers["stage"].Current;
	current.fade = vars.watchers["fade"].Current;
	if (vars.watchers["stage"].Changed)
		print(old.stageCount + " -> " + current.stageCount);
}

start {
	timer.Run.Offset = TimeSpan.FromSeconds(0);
	
	if (current.scene.Contains("beach") || current.scene.Contains("golem")) {
		return current.fade < 1.0f && old.fade >= 1.0f;
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
		if (current.stageCount == old.stageCount + 1 && current.stageCount >= 1) {
			return true;
		}
	} else {
		if (current.scene != old.scene && current.scene == "outro") {
			return true;
		}
	}

	if (current.scene != old.scene && current.scene != "title" && current.scene != "lobby" && settings[old.scene]) {
		return true;
	}
}

isLoading {
	if (current.fade > old.fade) return true;
	if (current.fade < old.fade && current.fade > 0) return false;
}

exit {
	timer.Run.Offset = TimeSpan.FromSeconds(0);
}
