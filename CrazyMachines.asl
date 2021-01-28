state("CrazyMachines") {
	
	//bool related to a textbox being on screen
	byte tb:	0x11066C; 	
	
	//2 when a level is finished
	byte win:	0x10F344, 0xE0, 0xC, 0x4, 0x4, 0x8, 0x50;
}

state("cm_family"){
	byte tb:	0x1117BC;
	byte win:	0x110484, 0xE0, 0xC, 0x4, 0x4, 0x8, 0x50;
}

state("cmntfl") {
	byte tb:	0x113ABC;
	byte win:	0x112764, 0xE0, 0xC, 0x4, 0x4, 0x8, 0x50;
}

start {
	return current.tb == old.tb + 1 && current.win == 0;
}

split {
	return current.win > old.win;
}
