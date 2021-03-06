state("Warhammer2") {
	//old addresses, kept for future reference 
	//byte loading_start:   0x385D412;
	//byte loading_stop:    0x3771BA9;
	//byte not_end_of_turn: 0x34EC67C;
	//byte world_event:     0x375CB4C;
	
	byte loading_start:   0x385EAA2;
	byte loading_stop:    0x3772FD9;
	byte not_end_of_turn: 0x34ED68C;
	byte world_event:     0x375DC7C;
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
