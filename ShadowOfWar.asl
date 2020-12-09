state("ShadowOfWar") {
	//most of the time 65536 in loads and 65537 outside loads 
	//seems to randomly go to a different number, though consistently goes down by 1 when entering a load
	int load:	0x2A26D90, 0x38, 0xFC;
}

isLoading {
	if (current.load != old.load && current.load != old.load + 1) {
		return true;
	}
	
	if (current.load == old.load + 1) {
		return false;
	}
}
