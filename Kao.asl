state("kao") {}

startup {
	vars.dic = new Dictionary<int, string> {
		{1, "Lava 1"},
		{2, "Lava 2"},
		{3, "Lava 3 (Glider)"},
		{4, "Lava 4"},
		{5, "Ice 1"},
		{6, "Ice 2"},
		{7, "Bear Boss"},
		{8, "Ice 3"},
		{9, "Ice 4"},
		{10, "Ice 5 (Snowboard)"},
		{11, "Ice 6"},
		{12, "Greece 1"},
		{13, "Captain Boss"},
		{14, "Greece 2"},
		{15, "Greece 3 (Motorboat)"},
		{16, "Greece 4"},
		{17, "Greece 5"},
		{18, "Greece 6"},
		{19, "Zeus"},
		{20, "Space 1"},
		{21, "Space 2"},
		{22, "Space 3"},
		{23, "Space 4"},
		{24, "Alien"},
		{25, "Tropics 1"},
		{26, "Tropics 2"},
		{27, "Tropics 3"},
		{28, "Tropics 4"},
		{29, "Tropics 5"},
		{30, "Hunter"}
	};
	
	foreach (var Tag in vars.dic) {
		settings.Add(Tag.Key.ToString(), true, Tag.Value);
    };
	
	vars.doneLevels = new List<int>();
	vars.lastLevel = 0;
}

init {
	vars.threadScan = new Thread(() => {
		var scanner = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
		var levelSig = new SigScanTarget(2, "8B 0D ???????? 51 E8 ???????? 83 C4 04 8D 4C 24");
		var hunterSig = new SigScanTarget(9, "C6 85 ?????????? 89 85 ???????? 89 85 ???????? 89 9D");
		var loadSig = new SigScanTarget(2, "89 3D ???????? E8 ???????? 3B DF");
		levelSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
		hunterSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
		loadSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
	
		vars.sigsFound = false;
		int sigAttempt = 0;
		while (sigAttempt++ <= 20) {
			if (((vars.levelPtr = scanner.Scan(levelSig)) != IntPtr.Zero) && 
			((vars.hunterPtr = scanner.Scan(hunterSig)) != IntPtr.Zero) && 
			((vars.loadPtr = scanner.Scan(loadSig)) != IntPtr.Zero)) {
				vars.sigsFound = true;
				break;
			}
			print("Couldn't find sigs. Retrying.");
		}

		if (vars.sigsFound) {
			vars.level = new MemoryWatcher<int>(vars.levelPtr);
			vars.hunter = new MemoryWatcher<byte>(vars.hunterPtr);
			vars.load = new MemoryWatcher<byte>(vars.loadPtr);
		}
	});
	vars.threadScan.Start();
}

update {
	if (!vars.sigsFound) return false;
	
	vars.level.Update(game);
	vars.hunter.Update(game);
	vars.load.Update(game);
	
	current.level = vars.level.Current;
	current.load = vars.load.Current;
	current.hunterAnim = vars.hunter.Current;
}

start {
	if (current.level == 1 && (old.level == 100 || old.level == 101)) {
		vars.doneLevels.Clear();
		vars.lastLevel = 1;
		return true;
	}
}

split {
	//splits for levels 1-29, with the map menu inbetween
	if (current.level != 101 && old.level == 101 && current.level != vars.lastLevel && current.level != 100 && !vars.doneLevels.Contains(current.level)) {
		vars.lastLevel = current.level;
		return settings[vars.lastLevel.ToString()];
	}
	
	//final split
	if (old.level == 30 && current.hunterAnim == 5 && old.hunterAnim != 5)
		return settings["30"];
}

reset {
	return current.level == 100;
}
	
isLoading {
	return (current.load == 1);
}
