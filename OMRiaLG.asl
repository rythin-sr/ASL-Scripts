//Oh! My Roommate is a Laser Gun Autosplitter by rythin

state("stdrt") {
	byte win: 0x00585A4, 0xC2, 0x8, 0xB4, 0xC, 0x1C, 0xB80;
}

split {
	return (current.win == old.win + 1);
}
