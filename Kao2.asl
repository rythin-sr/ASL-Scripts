//Kao the Kangaroo: Round 2 Autosplitter + Load Remover by RibShark
//base script by rythin, Mr. Mary

/*state("Kao2", "Polish Retail") {
}

state("Kao2", "European Retail") {
}

state("Kao2", "Russian Retail") {
}

state("Kao2", "Australian Retail") {
}

state("Kao2", "United States Retail") {}*/

state("Kao2") {}


startup {
	settings.Add("lc", true, "Level Completion");
	settings.Add("le", true, "Level Entry");
	settings.Add("newb", true, "Newbie-friendly auto-resets");
	settings.SetToolTip("newb", "Only auto-reset if going to the menu before The Race, but after The Ship");
	
	vars.level = new Dictionary<int, string> {
		{0, "The Ship"},
		{2, "Beavers' Forest"},
		{3, "The Great Escape"},
		{4, "Great Trees"},
		{5, "River Raid"},
		{6, "Shaman's Cave"},
		{7, "Igloo Village"},
		{8, "Ice Cave"},
		{9, "Down the Mountain"},
		{10, "Crystal Mines"},
		{11, "The Station"},
		{12, "The Race"},
		{13, "Hostile Reef"},
		{14, "Deep Ocean"},
		{15, "Lair of Poison"},
		{16, "Trip to Island"},
		{17, "Treasure Island"},
		{18, "The Volcano"},
		{19, "Pirate's Bay"},
		{20, "Abandoned Town"},
		{21, "Hunter's Galleon"},
		{23, "Bonus: Jumprope"},
		{24, "Bonus: Trees"},
		{25, "Bonus: Shooting"},
		{26, "Bonus: The Race"},
		{27, "Bonus: Mini Baseball"},
	};
	
	vars.levelEntry = new Dictionary<string, string> {
		{"2e", "Beavers' Forest"},
		{"7e", "Igloo Village"},
		{"12e", "The Race"},
		{"16e", "Trip to Island"},
		{"20e", "Abandoned Town"}
	};
	
	foreach (var Tag in vars.level) {
		settings.Add(Tag.Key.ToString(), true, Tag.Value, "lc");
	};
	
	foreach (var Tag in vars.levelEntry) {
		settings.Add(Tag.Key, false, Tag.Value, "le");
	};

	vars.doneSplits = new List<string>();
}

init {
	var module = modules.First();
	IntPtr baseaddr = module.BaseAddress;
	string name = module.ModuleName.ToLower();
	int memsize = module.ModuleMemorySize;
	if(!name.Contains("kao2")) return; // fix for when first module isn't Kao2

	if (memsize == 2523136) {
		version = "Polish Retail";
		vars.level		= new MemoryWatcher<int>(baseaddr+0x22B7D4);
		vars.menu		= new MemoryWatcher<int>(baseaddr+0x23D9AC);
		vars.loading		= new MemoryWatcher<int>(baseaddr+0x22451C);
		vars.cutscene		= new MemoryWatcher<int>(baseaddr+0x21E6EC);
		vars.Xpos		= new MemoryWatcher<float>(baseaddr+0x22C648);
		vars.Ypos		= new MemoryWatcher<float>(baseaddr+0x22C64C);
		vars.Zpos		= new MemoryWatcher<float>(baseaddr+0x22C650);
	}
	
	else if (memsize == 2912256) {
		version = "European Retail";
		vars.level		= new MemoryWatcher<int>(baseaddr+0x28765C);
		vars.menu		= new MemoryWatcher<int>(baseaddr+0x27C4B0);
		vars.loading		= new MemoryWatcher<int>(baseaddr+0x279D44);
		vars.cutscene		= new MemoryWatcher<int>(baseaddr+0x273CFC);
		vars.Xpos		= new MemoryWatcher<float>(baseaddr+0x29E278);
		vars.Ypos		= new MemoryWatcher<float>(baseaddr+0x29E27C);
		vars.Zpos		= new MemoryWatcher<float>(baseaddr+0x29E280);
	}
	else if (memsize == 2920448) {
		version = "Russian Retail";
		vars.level		= new MemoryWatcher<int>(baseaddr+0x28765C);
		vars.menu		= new MemoryWatcher<int>(baseaddr+0x27C4B0);
		vars.loading		= new MemoryWatcher<int>(baseaddr+0x279D44);
		vars.cutscene		= new MemoryWatcher<int>(baseaddr+0x273CFC);
		vars.Xpos		= new MemoryWatcher<float>(baseaddr+0x29E278);
		vars.Ypos		= new MemoryWatcher<float>(baseaddr+0x29E27C);
		vars.Zpos		= new MemoryWatcher<float>(baseaddr+0x29E280);
	}
	else if (memsize == 2940928) {
		version = "Australian Retail";
		vars.level		= new MemoryWatcher<int>(baseaddr+0x28DFC4);
		vars.menu		= new MemoryWatcher<int>(baseaddr+0x282E18);
		vars.loading		= new MemoryWatcher<int>(baseaddr+0x2806A4);
		vars.cutscene		= new MemoryWatcher<int>(baseaddr+0x27A65C);
		vars.Xpos		= new MemoryWatcher<float>(baseaddr+0x28EE98);
		vars.Ypos		= new MemoryWatcher<float>(baseaddr+0x28EE9C);
		vars.Zpos		= new MemoryWatcher<float>(baseaddr+0x28EEA0);
	}
	else if (memsize == 15024128) {
		version = "United States Retail";
		vars.level		= new MemoryWatcher<int>(baseaddr+0x290584);
		vars.menu		= new MemoryWatcher<int>(baseaddr+0x2A4914);
		vars.loading		= new MemoryWatcher<int>(baseaddr+0x282C64);
		vars.cutscene		= new MemoryWatcher<int>(baseaddr+0x27CC18);
		vars.Xpos		= new MemoryWatcher<float>(baseaddr+0x291478);
		vars.Ypos		= new MemoryWatcher<float>(baseaddr+0x29147C);
		vars.Zpos		= new MemoryWatcher<float>(baseaddr+0x291480);
	}
	else if (memsize == 8679424 // itch.io
		  || memsize == 8826880 // steam
	) {
		version = "Digital";
		
		// init memory watches
		vars.watcher = new MemoryWatcherList();
		print("Running signature scans...");
		IntPtr ptr;
		foreach (var page in game.MemoryPages(true)){
			var scanner = new SignatureScanner(game, baseaddr, (int)page.RegionSize);
			
			// level
			{
				ptr = IntPtr.Zero;
				ptr = scanner.Scan(
					new SigScanTarget(12,
					"83 E8 01 50 8B 8D E8 FB FF FF 51 B9 ?? ?? ?? ??"
					));
				if (ptr != IntPtr.Zero) {
					vars.level = new MemoryWatcher<int>((IntPtr)memory.ReadValue<int>(ptr) + 0xC);
				}
			}
			
			// menu
			{
				ptr = IntPtr.Zero;
				ptr = scanner.Scan(
					new SigScanTarget(13,
					"0F B6 8D CF FE FF FF 85 C9 74 73 C6 05 ?? ?? ?? ??"
					));
				if (ptr != IntPtr.Zero) {
					vars.menu = new MemoryWatcher<int>((IntPtr)memory.ReadValue<int>(ptr));
				}
			}
			
			// loading
			{
				ptr = IntPtr.Zero;
				ptr = scanner.Scan(
					new SigScanTarget(2,
					"C6 05 ?? ?? ?? ?? 01 8B 85 94"
					));
				if (ptr != IntPtr.Zero) {
					vars.loading = new MemoryWatcher<int>((IntPtr)memory.ReadValue<int>(ptr));
				}
			}
			
			// cutscene
			{
				ptr = IntPtr.Zero;
				ptr = scanner.Scan(
					new SigScanTarget(2,
					"89 0D ?? ?? ?? ?? 8B 55 08 C6 42 40 01"
					));
				if (ptr != IntPtr.Zero) {
					vars.cutscene = new MemoryWatcher<int>((IntPtr)memory.ReadValue<int>(ptr));
				}
			}
			
			// pos
			{
				ptr = IntPtr.Zero;
				ptr = scanner.Scan(
					new SigScanTarget(1,
					"BF ?? ?? ?? ?? F3 A5 5F 5E 8B E5"
					));
				if (ptr != IntPtr.Zero) {
					vars.Xpos = new MemoryWatcher<float>((IntPtr)memory.ReadValue<int>(ptr) + 0x10);
					vars.Ypos = new MemoryWatcher<float>((IntPtr)memory.ReadValue<int>(ptr) + 0x14);
					vars.Zpos = new MemoryWatcher<float>((IntPtr)memory.ReadValue<int>(ptr) + 0x18);
				}
			}
			
		}
	}
	else {
		version = "Unsupported";
	}
}

update {
	vars.level.Update(game);
	vars.menu.Update(game);
	vars.loading.Update(game);
	vars.cutscene.Update(game);
	vars.Xpos.Update(game);
	vars.Ypos.Update(game);
	vars.Zpos.Update(game);
}

start {
    if (vars.level.Current == 0 && vars.menu.Old == 1 
		&& vars.menu.Current == 0 && vars.cutscene.Current == 1)
	{
		vars.doneSplits.Clear();
		vars.counter = 0;
		return true;
	}
} 

split {
	if (vars.level.Current != vars.level.Old && vars.level.Current != 0) 
	{
		//level completion splits
		if (settings[vars.level.Old.ToString()] 
			&& !vars.doneSplits.Contains( vars.level.Old.ToString() )) {
			vars.doneSplits.Add(vars.level.Old.ToString());
			return true;
		}
		//level entry splits
		if (settings[vars.level.Current.ToString() + "e"]
			&& !vars.doneSplits.Contains( vars.level.Current.ToString() + "e" )) {
			vars.doneSplits.Add(vars.level.Current.ToString() + "e");
			return true;
		}
	}

	//final split
	if (vars.level.Current == 22 && vars.cutscene.Current == 1
		&& vars.cutscene.Old == 0 && vars.Ypos.Current > 9000)
	{
		return true;
	}
}

reset {
	if (vars.level.Current == 0)
	{
		if (settings["newb"] && vars.level.Old < 13 && vars.level.Old > 0) {
			return true;
		}
		if (!settings["newb"] && vars.loading.Current == 0 && vars.loading.Old == 1) {
			return true;
		}
	}
}

isLoading {
    return (vars.loading.Current == 1);
}
