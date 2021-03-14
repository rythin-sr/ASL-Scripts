state("HouseFlipper") {
	//Statistics
	int completedOrders:    "UnityPlayer.dll", 0x1800A50, 0x58, 0x130, 0xF0, 0xA8, 0x58, 0x3C;
	
	//Code.GameManagers.HFSceneManager
	byte loadingInProgress: "UnityPlayer.dll", 0x17A0A38, 0x8, 0x48, 0x250, 0xC0, 0x108, 0x48;
	string30 map:           "UnityPlayer.dll", 0x17A0A38, 0x8, 0x48, 0x250, 0xC0, 0x108, 0x30, 0x14; //real name of the variable was obfuscated
	
}

start {
	if (current.map != old.map && old.map == "scn_Start") {
		return true;
	}
}

split {
	return current.completedOrders > old.completedOrders;
}

reset {
	return current.map == "scn_Start";
}

isLoading {
	return current.loadingInProgress == 1;
}
