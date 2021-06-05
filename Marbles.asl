//i should really clean this up
state("MarblesOnStream-Win64-Shipping") {}

init {
	Func<IntPtr, int, int, IntPtr> PtrFromOpcode = (ptr, targetOperandOffset, totalSize) => {
		byte[] bytes = game.ReadBytes(ptr + targetOperandOffset, 4);
		if (bytes == null) return IntPtr.Zero;

		Array.Reverse(bytes);
		int offset = Convert.ToInt32(BitConverter.ToString(bytes).Replace("-", ""), 16);
		IntPtr actualPtr = IntPtr.Add((ptr + totalSize), offset);
		return actualPtr;
	};
	
	SigScanTarget target = new SigScanTarget("48 8B 1D ?? ?? ?? ?? 48 85 DB 74 ?? 41 B0 01");
	target.OnFound = (proc, s, ptr) => PtrFromOpcode(ptr, 3, 7);
	SignatureScanner scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);
	IntPtr address = IntPtr.Zero;
	
	int sigAttempt = 0;
	while (sigAttempt++ <= 20) {
		if ((address = scanner.Scan(target)) != IntPtr.Zero) break;
		print("Current iteration: " + sigAttempt);
	}
	
	if (!(vars.sigFound = address != IntPtr.Zero)) return;
	
	//previously 0x130, 0x3E8 and 0x130, 0x768
	vars.timer = new MemoryWatcher<float>(new DeepPointer(address, 0x120, 0x3D8));
	vars.level = new MemoryWatcher<int>(new DeepPointer(address, 0x120, 0x760));
}

update {
	if (!vars.sigFound) return false;
	vars.timer.Update(game);
	vars.level.Update(game);
	
	current.level = vars.level.Current;
	current.igt = vars.timer.Current;
}

start {
	return current.level == 1 && current.igt > 0 && old.igt == 0;
}

split {
	return current.level == old.level + 1;
}

reset {
	return current.igt == 0;
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.igt);
}
