state("backinthegroove") {
	byte transition: "UnityPlayer.dll", 0x144B900, 0x180, 0x178, 0xD0, 0x40, 0x38, 0x1E8;
}

split {
	return (current.transition == old.transition + 1);
}

isLoading {
	return (current.transition == 1); 
}
