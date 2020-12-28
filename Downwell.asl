// By Ero, JPlay, rythin.

state("Downwell_v1_0_5") {
	//double level         : 0x445C40, 0x60, 0x10, 0xDB4, 0x10;
	//double world         : 0x445C40, 0x60, 0x10, 0xDB4, 0x20;
	double health        : 0x445C40, 0x60, 0x10, 0xDB4, 0x140;
	//double air           : 0x445C40, 0x60, 0x10, 0xDB4, 0x2F0;
	double pauseDouble   : 0x445C40, 0x60, 0x10, 0xDB4, 0x460;
	//double money         : 0x445C40, 0x60, 0x10, 0xDB4, 0x920;
	double frameCount    : 0x445C40, 0x60, 0x10, 0xDB4, 0x9B0;
	double inLevelDouble : 0x445C40, 0x60, 0x10, 0xDB4, 0xA50;
}

startup {
	vars.timerModel = new TimerModel {CurrentState = timer};
	vars.stopWatch = new Stopwatch();
}

update {
	current.isPaused = current.pauseDouble == 1.0;
	current.isInLevel = current.inLevelDouble == 1.0;
	
	if (old.frameCount == current.frameCount) vars.stopWatch.Start();
	if (old.frameCount != current.frameCount) vars.stopWatch.Reset();
}

start {
	return current.frameCount != old.frameCount && old.frameCount <= 1;
}

split {
	return
		current.isInLevel && !old.isInLevel && !current.isPaused && !old.isPaused ||
		!current.isPaused && vars.stopWatch.ElapsedMilliseconds >= 50;
}

reset {
	return current.health == 0 && old.health > 0 || current.frameCount < old.frameCount;
}

gameTime {
	return TimeSpan.FromSeconds(current.frameCount / 60);
}

isLoading {
	return true;
}

exit {
	vars.stopWatch.Reset();
	vars.timerModel.Reset();
}
