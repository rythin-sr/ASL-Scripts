state("Bendy and the Ink Machine") {
	//TMG.Data.SaveFileData
	byte chapter: "mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x4C;	
	float igt:    "mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x54;
}

startup {

	//settings setup
	settings.Add("Chapter 1", true);
		settings.Add("IsStarted1", false, "IsStarted", "Chapter 1");
			settings.Add("obj-1-1-0", false, "Inkwell", "IsStarted1");
			settings.Add("obj-1-2-0", false, "Doll", "IsStarted1");
			settings.Add("obj-1-3-0", false, "Record", "IsStarted1");
			settings.Add("obj-1-4-0", false, "Book", "IsStarted1");
			settings.Add("obj-1-5-0", false, "Wrench", "IsStarted1");
			settings.Add("obj-1-6-0", false, "Gear", "IsStarted1");
			settings.Add("obj-1-7-0", false, "InkMachineRevealObjective", "IsStarted1");
			settings.Add("obj-1-8-0", false, "CollectablesObjective", "IsStarted1");
			settings.Add("obj-1-9-0", false, "TheatreObjective", "IsStarted1");
			settings.Add("obj-1-10-0", false, "InkMachineObjective", "IsStarted1");
			settings.Add("obj-1-11-0", false, "BendyChaseObjective", "IsStarted1");
			settings.Add("obj-1-12-0", false, "BasementObjective", "IsStarted1");
		settings.Add("IsComplete1", false, "IsComplete", "Chapter 1");
			settings.Add("obj-1-1-1", false, "Inkwell", "IsComplete1");
			settings.Add("obj-1-2-1", false, "Doll", "IsComplete1");
			settings.Add("obj-1-3-1", false, "Record", "IsComplete1");
			settings.Add("obj-1-4-1", false, "Book", "IsComplete1");
			settings.Add("obj-1-5-1", false, "Wrench", "IsComplete1");
			settings.Add("obj-1-6-1", false, "Gear", "IsComplete1");
			settings.Add("obj-1-7-1", false, "InkMachineRevealObjective", "IsComplete1");
			settings.Add("obj-1-8-1", false, "CollectablesObjective", "IsComplete1");
			settings.Add("obj-1-9-1", false, "TheatreObjective", "IsComplete1");
			settings.Add("obj-1-10-1", false, "InkMachineObjective", "IsComplete1");
			settings.Add("obj-1-11-1", false, "BendyChaseObjective", "IsComplete1");
			settings.Add("obj-1-12-1", false, "BasementObjective", "IsComplete1");
		settings.Add("ch1", true, "Chapter Completion", "Chapter 1");
	settings.Add("Chapter 2", true);
		settings.Add("IsStarted2", false, "IsStarted", "Chapter 2");
			settings.Add("obj-2-1-0", false, "RitualObjective", "IsStarted2");
			settings.Add("obj-2-2-0", false, "GateObjective", "IsStarted2");
			settings.Add("obj-2-3-0", false, "MusicDepartmentObjective", "IsStarted2");
			settings.Add("obj-2-4-0", false, "LostKeysObjective", "IsStarted2");
			settings.Add("obj-2-5-0", false, "MusicPuzzleObjective", "IsStarted2");
			settings.Add("obj-2-6-0", false, "SanctuaryObjective", "IsStarted2");
			settings.Add("obj-2-7-0", false, "InfirmaryObjective", "IsStarted2");
			settings.Add("obj-2-8-0", false, "SewersObjective", "IsStarted2");
			settings.Add("obj-2-9-0", false, "SammysOfficeObjective", "IsStarted2");
		settings.Add("IsComplete2", false, "IsComplete", "Chapter 2");
			settings.Add("obj-2-1-1", false, "RitualObjective", "IsComplete2");
			settings.Add("obj-2-2-1", false, "GateObjective", "IsComplete2");
			settings.Add("obj-2-3-1", false, "MusicDepartmentObjective", "IsComplete2");
			settings.Add("obj-2-4-1", false, "LostKeysObjective", "IsComplete2");
			settings.Add("obj-2-5-1", false, "MusicPuzzleObjective", "IsComplete2");
			settings.Add("obj-2-6-1", false, "SanctuaryObjective", "IsComplete2");
			settings.Add("obj-2-7-1", false, "InfirmaryObjective", "IsComplete2");
			settings.Add("obj-2-8-1", false, "SewersObjective", "IsComplete2");
			settings.Add("obj-2-9-1", false, "SammysOfficeObjective", "IsComplete2");
		settings.Add("ch2", true, "Chapter Completion");
	settings.Add("Chapter 3", true);
		settings.Add("IsStarted3", false, "IsStarted", "Chapter 3");
			settings.Add("obj-3-1-0", false, "SqueakyToys", "IsStarted3");
			settings.Add("obj-3-2-0", false, "AccountingRoom", "IsStarted3");
			settings.Add("obj-3-3-0", false, "SafehouseObjective", "IsStarted3");
			settings.Add("obj-3-4-0", false, "DarkHallwaysObjective", "IsStarted3");
			settings.Add("obj-3-5-0", false, "HeavenlyToysObjective", "IsStarted3");
			settings.Add("obj-3-6-0", false, "AliceRevealObjective", "IsStarted3");
			settings.Add("obj-3-7-0", false, "DecisionObjective", "IsStarted3");
			settings.Add("obj-3-8-0", false, "BorisJumpscareObjective", "IsStarted3");
			settings.Add("obj-3-9-0", false, "PosterPiperObjective", "IsStarted3");
			settings.Add("obj-3-10-0", false, "EnterLiftObjective", "IsStarted3");
			settings.Add("obj-3-11-0", false, "AliceLairObjective", "IsStarted3");
			settings.Add("obj-3-12-0", false, "AliceTasksObjective", "IsStarted3");
			settings.Add("gear0", false, "GearTask", "IsStarted3");
			settings.Add("ink0", false, "ThickInkTask", "IsStarted3");
			settings.Add("power0", false, "PowerCoreTask", "IsStarted3");
			settings.Add("cutout0", false, "CutoutTask", "IsStarted3");
			settings.Add("obj-3-17-0", false, "ButcherGangTask", "IsStarted3");
			settings.Add("heart0", false, "HeartTask", "IsStarted3");
		settings.Add("IsComplete3", false, "IsComplete", "Chapter 3");
			settings.Add("obj-3-1-1", false, "SqueakyToys", "IsComplete3");
			settings.Add("obj-3-2-1", false, "AccountingRoom", "IsComplete3");
			settings.Add("obj-3-3-1", false, "SafehouseObjective", "IsComplete3");
			settings.Add("obj-3-4-1", false, "DarkHallwaysObjective", "IsComplete3");
			settings.Add("obj-3-5-1", false, "HeavenlyToysObjective", "IsComplete3");
			settings.Add("obj-3-6-1", false, "AliceRevealObjective", "IsComplete3");
			settings.Add("obj-3-7-1", false, "DecisionObjective", "IsComplete3");
			settings.Add("obj-3-8-1", false, "BorisJumpscareObjective", "IsComplete3");
			settings.Add("obj-3-9-1", false, "PosterPiperObjective", "IsComplete3");
			settings.Add("obj-3-10-1", false, "EnterLiftObjective", "IsComplete3");
			settings.Add("obj-3-11-1", false, "AliceLairObjective", "IsComplete3");
			settings.Add("obj-3-12-1", false, "AliceTasksObjective", "IsComplete3");
			settings.Add("gear1", false, "GearTask", "IsComplete3");
			settings.Add("ink1", false, "ThickInkTask", "IsComplete3");
			settings.Add("power1", false, "PowerCoreTask", "IsComplete3");
			settings.Add("cutout1", false, "CutoutTask", "IsComplete3");
			settings.Add("obj-3-17-1", false, "ButcherGangTask", "IsComplete3");
			settings.Add("heart1", false, "HeartTask", "IsComplete3");
		settings.Add("ch3", true, "Chapter Completion");
	settings.Add("Chapter 4", true);
		settings.Add("IsStarted4", false, "IsStarted", "Chapter 4");
			settings.Add("obj-4-3-0", false, "AccountingObjective", "IsStarted4");
			settings.Add("obj-4-4-0", false, "BridgeMachineObjective", "IsStarted4");
			settings.Add("obj-4-5-0", false, "LostOnesObjective", "IsStarted4");
			settings.Add("obj-4-6-0", false, "VentObjective", "IsStarted4");
			settings.Add("obj-4-7-0", false, "MapRoomObjective", "IsStarted4");
			settings.Add("obj-4-8-0", false, "WarehouseObjective", "IsStarted4");
			settings.Add("obj-4-9-0", false, "FairGamesObjective", "IsStarted4");
			settings.Add("obj-4-10-0", false, "ResearchObjective", "IsStarted4");
			settings.Add("obj-4-11-0", false, "RideStorageObjective", "IsStarted4");
			settings.Add("obj-4-12-0", false, "MaintenanceObjective", "IsStarted4");
			settings.Add("obj-4-13-0", false, "HauntedHouseObjective", "IsStarted4");
		settings.Add("IsComplete4", false, "IsComplete", "Chapter 4");
			settings.Add("obj-4-3-1", false, "AccountingObjective", "IsComplete4");
			settings.Add("obj-4-4-1", false, "BridgeMachineObjective", "IsComplete4");
			settings.Add("obj-4-5-1", false, "LostOnesObjective", "IsComplete4");
			settings.Add("obj-4-6-1", false, "VentObjective", "IsComplete4");
			settings.Add("obj-4-7-1", false, "MapRoomObjective", "IsComplete4");
			settings.Add("obj-4-8-1", false, "WarehouseObjective", "IsComplete4");
			settings.Add("obj-4-9-1", false, "FairGamesObjective", "IsComplete4");
			settings.Add("obj-4-10-1", false, "ResearchObjective", "IsComplete4");
			settings.Add("obj-4-11-1", false, "RideStorageObjective", "IsComplete4");
			settings.Add("obj-4-12-1", false, "MaintenanceObjective", "IsComplete4");
			settings.Add("obj-4-13-1", false, "HauntedHouseObjective", "IsComplete4");
		settings.Add("ch4", true, "Chapter Completion");
	settings.Add("Chapter 5", true);
		settings.Add("IsStarted5", false, "IsStarted", "Chapter 5");
			settings.Add("obj-5-1-0", false, "PipePuzzleBasic", "IsStarted5");
			settings.Add("obj-5-2-0", false, "PipePuzzleCorner", "IsStarted5");
			settings.Add("obj-5-3-0", false, "PipePuzzleThreeWay", "IsStarted5");
			settings.Add("obj-5-4-0", false, "SafehouseObjective", "IsStarted5");
			settings.Add("obj-5-5-0", false, "CavesObjective", "IsStarted5");
			settings.Add("obj-5-6-0", false, "DockObjective", "IsStarted5");
			settings.Add("obj-5-7-0", false, "TunnelsObjective", "IsStarted5");
			settings.Add("obj-5-8-0", false, "LostHarbourObjective", "IsStarted5");
			settings.Add("obj-5-9-0", false, "AdministrationObjective", "IsStarted5");
			settings.Add("obj-5-10-0", false, "VaultObjective", "IsStarted5");
			settings.Add("obj-5-11-0", false, "GiantInkMachineObjective", "IsStarted5");
			settings.Add("obj-5-12-0", false, "ThroneRoomObjective", "IsStarted5");
			settings.Add("obj-5-13-0", false, "BendyArena", "IsStarted5");
		settings.Add("IsComplete5", false, "IsComplete", "Chapter 5");
			settings.Add("obj-5-1-1", false, "PipePuzzleBasic", "IsComplete5");
			settings.Add("obj-5-2-1", false, "PipePuzzleCorner", "IsComplete5");
			settings.Add("obj-5-3-1", false, "PipePuzzleThreeWay", "IsComplete5");
			settings.Add("obj-5-4-1", false, "SafehouseObjective", "IsComplete5");
			settings.Add("obj-5-5-1", false, "CavesObjective", "IsComplete5");
			settings.Add("obj-5-6-1", false, "DockObjective", "IsComplete5");
			settings.Add("obj-5-7-1", false, "TunnelsObjective", "IsComplete5");
			settings.Add("obj-5-8-1", false, "LostHarbourObjective", "IsComplete5");
			settings.Add("obj-5-9-1", false, "AdministrationObjective", "IsComplete5");
			settings.Add("obj-5-10-1", false, "VaultObjective", "IsComplete5");
			settings.Add("obj-5-11-1", false, "GiantInkMachineObjective", "IsComplete5");
			settings.Add("obj-5-12-1", false, "ThroneRoomObjective", "IsComplete5");
			settings.Add("obj-5-13-1", false, "BendyArena", "IsComplete5");
		settings.Add("ch5", true, "Chapter Completion");
		
	vars.CH1 = new MemoryWatcherList();
	vars.CH2 = new MemoryWatcherList();
	vars.CH3 = new MemoryWatcherList();
	vars.CH4 = new MemoryWatcherList();
	vars.CH5 = new MemoryWatcherList();
	vars.objCounts = new int[]{12, 9, 18, 13, 13}; 
	vars.chapterWatchers = new MemoryWatcherList[] {vars.CH1, vars.CH2, vars.CH3, vars.CH4, vars.CH5};
}

init {	
	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < vars.objCounts[i]; j++) {
			for (int g = 0; g < 2; g++) {
				vars.chapterWatchers[i].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x20 + (i * 0x8), 0x28 + (j * 0x8), 0x10 + g)) { Name = "obj-" + (i + 1).ToString() + "-" + (j + 1).ToString() + "-" + g.ToString() });
			}
		}
	}
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0x88, 0x18, 0x10)) { Name = "gear0" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0x88, 0x18, 0x11)) { Name = "gear1" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0x90, 0x18, 0x10)) { Name = "ink0" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0x90, 0x18, 0x11)) { Name = "ink1" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0x98, 0x18, 0x10)) { Name = "power0" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0x98, 0x18, 0x11)) { Name = "power1" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0xA0, 0x18, 0x10)) { Name = "cutout0" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0xA0, 0x18, 0x11)) { Name = "cutout1" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0xB0, 0x18, 0x10)) { Name = "heart0" });
	vars.chapterWatchers[2].Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x268758, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0, 0x28, 0x18, 0x30, 0xB0, 0x18, 0x11)) { Name = "heart1" });
}

update {
	if (current.chapter > 0) {
		vars.chapterWatchers[current.chapter - 1].UpdateAll(game);
	}
}

start {
	return current.chapter == 1 && current.igt > 0 && old.igt == 0;
}

split {
	if (current.chapter > 0) {
		foreach (var watcher in vars.chapterWatchers[current.chapter - 1]) {
			if (watcher.Changed && watcher.Current) {
				return settings[watcher.Name];
			}
		}
		
		if (current.chapter == old.chapter + 1) {
			return settings["ch" + old.chapter.ToString()];
		}
	}
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.igt);
}
