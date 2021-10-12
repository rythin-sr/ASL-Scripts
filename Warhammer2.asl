state("Warhammer2") {
	bool loading_start:   0x3841EF4;
	bool loading_stop:    0x3E9D701;
	bool turn:            0x3BAFF6C;
	byte world_event:     0x392443C;
}

isLoading {
	if (current.loading_start || current.loading_stop) {
		return true;
	} else {
		return !current.turn && current.world_event == 0;
	}
}
