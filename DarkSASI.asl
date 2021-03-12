state("Dark_SASI-Win64-Shipping") {
	//consistent value depending on what level youre on, 0 in loads
	int l:	0x293C1D8;
}

startup {
	//variables used for splitting
	vars.stopwatch = new Stopwatch();
}

start {
	if (current.l == 15 && old.l == 0) {
		vars.stopwatch.Reset();
		return true;
	}
}

split {
	switch (timer.CurrentSplitIndex) {
		case 0:
		return current.l == 8;
		break;
		
		case 1:
		return current.l == 12;
		break;
		
		case 2:
		vars.stopwatch.Restart();
		return current.l == 8;
		break;
	}
	
	//final split
	if (vars.stopwatch.ElapsedMilliseconds >= 52000) {
		vars.stopwatch.Reset();
		return true;
	}
}

isLoading {
	return (current.l == 0);
}
