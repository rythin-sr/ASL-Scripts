//Load Remover for The Disappearing of Gensokyo by rythin

state("The Disappearing of Gensokyo") {
	int gameLoading: 0x1058C4C;     //1 when loading
}

isLoading {
	return (current.gameLoading == 1);
} 
