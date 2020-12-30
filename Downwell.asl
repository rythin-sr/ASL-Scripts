// By Ero, JPlay, rythin.

state("Downwell_v1_0_5") {
	double level         : 0x445C40, 0x60, 0x10, 0xDB4, 0x10;
	//double world         : 0x445C40, 0x60, 0x10, 0xDB4, 0x20;
	double health        : 0x445C40, 0x60, 0x10, 0xDB4, 0x140;
	//double air           : 0x445C40, 0x60, 0x10, 0xDB4, 0x2F0;
	//double ammo          : 0x445C40, 0x60, 0x10, 0xDB4, 0x370;
	//double money         : 0x445C40, 0x60, 0x10, 0xDB4, 0x920;
	double frameCount    : 0x445C40, 0x60, 0x10, 0xDB4, 0x9B0;
	double bossState     : 0x43550C, 0x710, 0x60, 0x10, 0x670, 0x0;
}

startup {
	vars.timerModel = new TimerModel {CurrentState = timer};
}

start {
	return current.frameCount != old.frameCount && old.frameCount <= 1.0;
}

split {
	return old.level != current.level || old.bossState == 4.0 && current.bossState == 5.0;
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
	vars.timerModel.Reset();
}
