state("CrazyMachines") {
	
	//bool that is true when theres a textbox on screen
	byte tb:    0x11066C; 	
	
	//2 when a level is finished
	byte win:   0x10F344, 0xE0, 0xC, 0x4, 0x4, 0x8, 0x50;
	
	//bool that is true in the main menu
	byte menu:  0x10F344, 0x28C, 0x1F0, 0x9C, 0xF30;
}

state("cm_family"){
	byte tb:    0x1117BC;
	byte win:   0x110484, 0xE0, 0xC, 0x4, 0x4, 0x8, 0x50;
	byte menu:  0x110484, 0x28C, 0x1F0, 0x9C, 0xF30;
}

state("cmnftl") {
	byte tb:    0x113ABC;
	byte win:   0x112764, 0xE0, 0xC, 0x4, 0x4, 0x8, 0x50;
	byte menu:  0x112764, 0x28C, 0x1F0, 0x9C, 0xF30;
}

init {
	vars.startReady = false;
}

start {
	if (current.menu == old.menu - 1) vars.startReady = true;
	
	if (vars.startReady && current.tb == 1) {
		vars.startReady = false;
		return true;
	}
}

split {
	return current.win > old.win;
}

reset {
	return current.menu == 1;
}
