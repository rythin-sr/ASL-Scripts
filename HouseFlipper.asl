state("HouseFlipper") {
	//Statistics
	int completedOrders:    "UnityPlayer.dll", 0x1812E70, 0x58, 0x130, 0xF0, 0xB8, 0x58, 0x3C;
	
	//Code.GameManagers.HFSceneManager
	string30 map:           "UnityPlayer.dll", 0x17B2E10, 0x8, 0x48, 0x3A0, 0xC0, 0x108, 0x30, 0x14; //real name of the variable was obfuscated
	
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
