state("backinthegroove") {
	//ElevatorUp
	byte goingUp:	"mono-2.0-bdwgc.dll", 0x44EB18, 0x2F0, 0x30, 0xB8, 0xB8, 0x430;
	byte isVisible:	"mono-2.0-bdwgc.dll", 0x44EB18, 0x2F0, 0x30, 0xB8, 0xB8, 0x1C9;
	byte level:	"mono-2.0-bdwgc.dll", 0x44EB18, 0x2F0, 0x30, 0xB8, 0xB8, 0x1D8;
	
	//JShipPiece has a bool called "done", which could probably be used for final split eventually
	//theres also an int called "shipPiece", maybe that's a piece counter?
}

init {
	timer.Run.Offset = TimeSpan.FromSeconds(-2);
}

start {
	return (current.level == 1 && current.isVisible == 1 && old.isVisible == 0);
}

split {
	return (current.level == old.level + 1);
}

isLoading {
	return (current.isVisible == 0 && current.goingUp == 1); 
}
