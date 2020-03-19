//GalGun 2 Load Remover by rythin
//i hate anime

state("GalGun2-Win64-Shipping") {
	int gameLoading:	0x28FDC88;
}
	
isLoading {
	return (current.gameLoading != 0);
}

exit {
	timer.IsGameTimePaused = true;
}
