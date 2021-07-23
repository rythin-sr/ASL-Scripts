state("Warhammer2") {
	byte loading_start:   0x3841EF4;
	byte loading_stop:    0x3E9D7D1;
	byte not_end_of_turn: 0x3BAFFAC;
	byte world_event:     0x392449C;
}

isLoading {
	if (current.loading_start == old.loading_start + 1) {
		return true;
	}
	
	if (current.loading_stop == old.loading_stop - 1) {
		return false;
	}
	
	if (current.loading_stop == 0) {
		return current.not_end_of_turn == 0 && current.world_event == 0;
	}
}
