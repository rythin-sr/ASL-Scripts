//Downwell Autosplitter by JPlay and rythin.

// to do: final split

state("Downwell_v1_0_5") {
	double frameCount:		0x00445C40, 0x60, 0x10, 0x448, 0x3A0;
	bool gamePaused:		0x00420EA0, 0x54, 0x7C, 0x2C, 0xCC;						//1 when game paused
	bool levelTransition:	0x00420EA8, 0x10, 0x2EC;								//1 when in a level, 0 when in a level transition	
	double health:			0x00662A3C, 0x84, 0x28, 0x770;
	double money:			0x0041C858, 0x8, 0x4F8, 0x8, 0x50, 0x18, 0x2F8, 0xA70;	//initially was gonna use this for resets but then i realised you could just spend all your money in a shop so lol

}

start {
	if (current.frameCount != old.frameCount && old.frameCount <= 1) {
		return true;
	}
}


split {
	// split on level transitions
	if (current.levelTransition && !old.levelTransition && !current.gamePaused && !old.gamePaused) {
		return true;
	}
}

reset {
	//reset on death to prevent extra split shenanigans
	if (current.health == 0 && old.health > 0) {
		return true;
	}
	
	//reset on retry from menu
	if (current.frameCount < old.frameCount) {
		return true;
	}
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.frameCount / 60);
}
