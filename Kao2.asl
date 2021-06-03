state("kao2") {} 

startup {
	settings.Add("Level Completion");
	settings.CurrentDefaultParent = "Level Completion";
		settings.Add("0", true, "The Ship");
		settings.Add("2", true, "Beavers' Forest");
		settings.Add("3", true, "The Great Escape");
		settings.Add("4", true, "Great Trees");
		settings.Add("5", true, "River Raid");
		settings.Add("6", true, "Shaman's Cave");
		settings.Add("7", true, "Igloo Village");
		settings.Add("8", true, "Ice Cave");
		settings.Add("9", true, "Down the Mountain");
		settings.Add("10", true, "Crystal Mines");
		settings.Add("11", true, "The Station");
		settings.Add("12", true, "The Race");
		settings.Add("13", true, "Hostile Reef");
		settings.Add("14", true, "Deep Ocean");
		settings.Add("15", true, "Lair of Poison");
		settings.Add("16", true, "Trip to Island");
		settings.Add("17", true, "Treasure Island");
		settings.Add("18", true, "The Volcano");
		settings.Add("19", true, "Pirate's Bay");
		settings.Add("20", true, "Abandoned Town");
		settings.Add("21", true, "Hunter's Galleon");
		settings.Add("22", true, "Final Duel");
		settings.Add("23", true, "Bonus: Jumprope");
		settings.Add("24", true, "Bonus: Trees");
		settings.Add("25", true, "Bonus: Shooting");
		settings.Add("26", true, "Bonus: The Race");
		settings.Add("27", true, "Bonus: Mini Baseball");
	settings.CurrentDefaultParent = null;
	settings.Add("Level Entry", false);
	settings.CurrentDefaultParent = "Level Entry";
		settings.Add("102", true, "Beavers' Forest");
		settings.Add("107", true, "Igloo Village");
		settings.Add("112", true, "The Race");
		settings.Add("116", true, "Trip to Island");
		settings.Add("120", true, "Abandoned Town");
		
	settings.CurrentDefaultParent = null;
	vars.doneSplits = new List<int>();
}

init {
	vars.threadScan = new Thread(() => {
		var scanner = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
		
		SigScanTarget levelSig;
		SigScanTarget menuSig;
		SigScanTarget loadSig;
		SigScanTarget cutsceneSig;
		SigScanTarget posSig;
		
		if (modules.First().ModuleMemorySize > 8000000 && modules.First().ModuleMemorySize < 10000000) {
			levelSig = new SigScanTarget(12, "83 E8 01 50 8B 8D E8 FB FF FF 51 B9 ?? ?? ?? ??");
			menuSig = new SigScanTarget(13, "0F B6 8D CF FE FF FF 85 C9 74 73 C6 05 ?? ?? ?? ??");
			loadSig = new SigScanTarget(2, "C6 05 ?? ?? ?? ?? 01 8B 85 94");
			cutsceneSig = new SigScanTarget(2, "89 0D ?? ?? ?? ?? 8B 55 08 C6 42 40 01");
			posSig = new SigScanTarget(1, "BF ?? ?? ?? ?? F3 A5 5F 5E 8B E5");
		
			levelSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
			menuSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
			loadSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
			cutsceneSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
			posSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
			
			vars.sigsFound = false;
			Thread.Sleep(1000);
			int sigAttempt = 0;
			while (sigAttempt++ <= 20) {
				if ((vars.levelPtr = scanner.Scan(levelSig)) != IntPtr.Zero && 
				(vars.menuPtr = scanner.Scan(menuSig)) != IntPtr.Zero && 
				(vars.loadPtr = scanner.Scan(loadSig)) != IntPtr.Zero && 
				(vars.cutscenePtr = scanner.Scan(cutsceneSig)) != IntPtr.Zero && 
				(vars.posPtr = scanner.Scan(posSig)) != IntPtr.Zero) 
				{
					vars.sigsFound = true;
					break;
				}
				print("Couldn't find sigs. Retrying.");
			}
	
			if (vars.sigsFound) {
				vars.level = new MemoryWatcher<int>(vars.levelPtr + 0xC);
				vars.menu = new MemoryWatcher<bool>(vars.menuPtr);
				vars.load = new MemoryWatcher<bool>(vars.loadPtr);
				vars.cutscene = new MemoryWatcher<bool>(vars.cutscenePtr);
				vars.yPos = new MemoryWatcher<float>(vars.posPtr + 0x14);
				
			}
		} else {
			switch (modules.First().ModuleMemorySize) {
				case 2523136: //PL
				vars.level = new MemoryWatcher<int>(modules.First().BaseAddress + 0x22B7D4);
				vars.menu = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x23D9AC);
				vars.load = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x22451C);
				vars.cutscene = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x21E6EC);
				vars.yPos = new MemoryWatcher<float>(modules.First().BaseAddress + 0x22C64C);
				break;
				
				case 2912256: //EU
				vars.level = new MemoryWatcher<int>(modules.First().BaseAddress + 0x28765C);
				vars.menu = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x27C4B0);
				vars.load = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x279D44);
				vars.cutscene = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x273CFC);
				vars.yPos = new MemoryWatcher<float>(modules.First().BaseAddress + 0x29E27C);
				break;
				
				case 2920448: //RU
				vars.level = new MemoryWatcher<int>(modules.First().BaseAddress + 0x28765C);
				vars.menu = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x27C4B0);
				vars.load = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x279D44);
				vars.cutscene = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x273CFC);
				vars.yPos = new MemoryWatcher<float>(modules.First().BaseAddress + 0x29E27C);
				break;
				
				case 2940928: //AU
				vars.level = new MemoryWatcher<int>(modules.First().BaseAddress + 0x28DFC4);
				vars.menu = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x282E18);
				vars.load = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x2806A4);
				vars.cutscene = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x27A65C);
				vars.yPos = new MemoryWatcher<float>(modules.First().BaseAddress + 0x28EE9C);
				break;
				
				case 15024128: //US
				vars.level = new MemoryWatcher<int>(modules.First().BaseAddress + 0x290584);
				vars.menu = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x2A4914);
				vars.load = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x282C64);
				vars.cutscene = new MemoryWatcher<bool>(modules.First().BaseAddress + 0x27CC18);
				vars.yPos = new MemoryWatcher<float>(modules.First().BaseAddress + 0x29147C);
				break;
			}
			vars.sigsFound = true;
		}
	});
	vars.threadScan.Start();
}

update {
	if (!vars.sigsFound) return false;
	
    vars.level.Update(game);
	vars.menu.Update(game);
	vars.load.Update(game);
	vars.cutscene.Update(game);
	vars.yPos.Update(game);
	
	current.level = vars.level.Current;
	current.menu = vars.menu.Current;
	current.load = vars.load.Current;
	current.cutscene = vars.cutscene.Current;
	current.yPos = vars.yPos.Current;
} 

start {
	if (current.level == 0 && current.cutscene && !old.cutscene) {
		vars.doneSplits.Clear();
		return true;
	}
}

split {
	if (current.level != old.level && current.level > 0) {
		//level completion
		if (!vars.doneSplits.Contains(old.level)) {
			vars.doneSplits.Add(old.level);
			return settings[old.level.ToString()];
		}
		
		//level entry
		if (!vars.doneSplits.Contains(current.level + 100)) {
			vars.doneSplits.Add(current.level + 100);
			return settings[(current.level + 100).ToString()];
		}
	}
	
	if (current.level == 22 && current.cutscene && !old.cutscene && current.yPos > 9000) {
		return settings["22"];
	}
}

reset {
	return current.level == 0 && current.cutscene && !old.cutscene;
}

isLoading {
	return current.load;
}
