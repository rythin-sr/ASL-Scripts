state("Warhammer2") {
	bool loading_start:   0x3841EF4;
	bool loading_stop:    0x3E9D7D1;
	bool not_end_of_turn: 0x3BAFFAC;
	byte world_event:     0x392449C;
}

isLoading {
	if (current.loading_start || current.loading_stop) {
		return true;
	} else {
		return !current.not_end_of_turn && current.world_event == 0;
	}
}
