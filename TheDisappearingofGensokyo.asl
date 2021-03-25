state("The Disappearing of Gensokyo") {
	int load: 0x1058C4C; //1 when loading
}

isLoading {
	return current.load == 1;
}
