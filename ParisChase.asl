state("ParisChase") {
	byte state:   0x39144F;  // different, inconsistent value when in game, in menu, in car select or load
	byte wins:    0x38A794;  // win counter
	byte overlay: 0x3913A3;  // non-0 in pause menu, car select and loads
}

start {
	return current.state != old.state && current.overlay == old.overlay;
}

split {
	return current.wins > old.wins;
}

isLoading {
	return current.overlay != 0;
}
