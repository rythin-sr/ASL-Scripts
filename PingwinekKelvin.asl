state("pingwinek") {
	byte level: 0xD8238;
	bool load:  0xD0C50;

	//thanks to flower35 for finding these
	byte end:   0x153378;
	byte timer: 0x1537EC;
}

start {
	return current.level == 1 && old.level == 100;
}

split {
	if (current.level == 101)
		current.level = old.level;

	if (current.level == old.level + 1) 
		return true;
	

	if (current.level == 6 && current.end == 16 && current.timer <= 22 && old.timer > 22)
		return true;	
}

reset {
	return current.level == 100;
}

isLoading {
	return current.load;
}
