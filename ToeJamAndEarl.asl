state("backinthegroove") {
	byte level: "mono-2.0-bdwgc.dll", 0x43DC80, 0x90, 0x10, 0x3A0, 0x10, 0x10, 0x60, 0xE8;
	byte transition: "UnityPlayer.dll", 0x14B67E8, 0x258, 0x68, 0x30, 0x10, 0x238, 0x228;
}

split {
	return (current.level == old.level + 1);
}

isLoading {
	return (current.transition == 1); 
}
