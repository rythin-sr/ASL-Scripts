// By Ero, JPlay, rythin.
// to do: final split

state("Downwell_v1_0_5") {
	double health        : 0x445C40, 0x60, 0x10, 0xD18, 0x10;
	double pauseDouble   : 0x445C40, 0x60, 0x10, 0xD18, 0x330;
	double inLevelDouble : 0x445C40, 0x60, 0x10, 0xD18, 0x3F0;
	double money         : 0x445C40, 0x60, 0x10, 0xD18, 0x7F0;
	double frameCount    : 0x445C40, 0x60, 0x10, 0xD18, 0x880;
}

update {
	current.isPaused = current.pauseDouble == 1.0;
	current.isInLevel = current.inLevelDouble == 1.0;
}

start {
	return current.frameCount != old.frameCount && old.frameCount <= 1;
}

split {
	return current.isInLevel && !old.isInLevel && !current.isPaused && !old.isPaused;
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
