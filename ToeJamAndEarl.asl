state("backinthegroove") {
	//ElevatorUp
	byte goingUp:	"UnityPlayer.dll", 0x1450E68, 0x128, 0x10, 0x30, 0x30, 0x18, 0x28, 0x430;
	byte isVisible:	"UnityPlayer.dll", 0x1450E68, 0x128, 0x10, 0x30, 0x30, 0x18, 0x28, 0x1C9;
	byte level:	"UnityPlayer.dll", 0x1450E68, 0x128, 0x10, 0x30, 0x30, 0x18, 0x28, 0x1D8;
	
	//JShipPiece has a bool called "done", which could probably be used for final split eventually
	//theres also an int called "shipPiece", maybe that's a piece counter?
}

init {
	timer.Run.Offset = TimeSpan.FromSeconds(0);
}

split {
	return (current.level == old.level + 1);
}

isLoading {
	return (current.isVisible == 0 && current.goingUp == 1); 
}
