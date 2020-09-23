//Enclave Autosplitter + Load Remover by rythin

state("enclave") {
	uint counter:		"MXR.dll", 0x15A090;
	int movingForward:	"DINPUT.dll", 0x1ECF0;
	int results:		"GameWorld.dll", 0x1ACFA0;
	int map:		"GameWorld.dll", 0x1ACFF8;
	int fmv:		"GameWorld.dll", 0x1AD048;
}

startup {
	
	vars.stopwatch = new Stopwatch();
	
	vars.L = 0;
	vars.counterPausedValue = 1;
	
	refreshRate = 30;
	
}

update {	
	
	if (current.counter == old.counter) {
		vars.counterPausedValue = current.counter;
	}
	
	if (current.counter == vars.counterPausedValue) {
		vars.stopwatch.Start();
	}
	
	if (vars.stopwatch.ElapsedMilliseconds > 30) {
		if (current.counter == vars.counterPausedValue) {
			vars.L = 1;
		}
		
		else {
			vars.counterPausedValue = 1;
			vars.stopwatch.Reset();
			vars.L = 0;
		}
	}
}

start {
	return (current.movingForward > old.movingForward);
}

split {
	return (current.results == 1 && old.results == 0);
}

isLoading {
	
	if (current.map != 0 || current.results != 0 || current.fmv != 0) {
		return false;
	}
	
	if (vars.L == 1) {
		return true;
	}
	
	else {
		return false;
	}
}
