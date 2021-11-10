state("Warhammer2") {
	bool loading_start:   0x3842EF4;
	bool loading_stop:    0x3E9E711;
	bool turn:            0x3BB0F6C;
	byte world_event:     0x392543C;
}

isLoading {
	if (current.loading_start || current.loading_stop) {
		return true;
	} else {
		return !current.turn && current.world_event == 0;
	}
}
