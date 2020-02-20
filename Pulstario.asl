//Pulstario Autosplitter + Game Time by rythin

state("Pulstario") {
	int roomID:			0x6C2DB8;
	double frameCount:		0x004B2780, 0x2C, 0x10, 0x4E0, 0x1D0;
	double deathCount:		0x004B2780, 0x2C, 0x10, 0x0, 0x120;
}

start {
	return (old.roomID != 2 && current.roomID == 2);
}

split {
	return (current.roomID != old.roomID && old.roomID != 25 && current.roomID != 1);
}

reset {
	return (current.roomID == 1 && old.roomID != 1);
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.frameCount / 60);
}
