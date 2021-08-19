state("ParisChase", "PL") {
	byte ol: 0x3913A3;
}

state("ParisChase", "IT") {
	byte ol: 0x2CB573;
}

init {
	
	switch (modules.First().ModuleMemorySize) {
		case 3137536:
		version = "IT";
		break;
		
		case 3960832:
		version = "PL";
		break;
	}

	var scanner = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
	var stateSig = new SigScanTarget(2, "8B 0D ?? ?? ?? ?? 3B CD");
	var winSig = new SigScanTarget(2, "01 35 ?? ?? ?? ?? EB ?? 6A");
	
	stateSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);
	winSig.OnFound = (proc, s, ptr) => proc.ReadPointer(ptr);

	vars.sigsFound = false;
	int sigAttempt = 0;
	while (sigAttempt++ <= 20) {
		if ((vars.statePtr = scanner.Scan(stateSig)) != IntPtr.Zero &&
		(vars.winPtr = scanner.Scan(winSig)) != IntPtr.Zero) {
			vars.sigsFound = true;
			//print("Address found: " + (vars.olPtr).ToString("x"));
			break;
		}
		print("Couldn't find sigs. Retrying.");
	}
    
	if (vars.sigsFound) {
		vars.state = new MemoryWatcher<byte>(vars.statePtr + 3);
		vars.wins = new MemoryWatcher<int>((IntPtr)vars.winPtr);
	}
}

update {
	if (vars.sigsFound) {
		vars.state.Update(game);
		vars.wins.Update(game);
	}
}

start {
	return vars.state.Changed && current.ol == old.ol;
}

split {
	return vars.wins.Current > vars.wins.Old;
}

isLoading {
	return current.ol != 0;
}
