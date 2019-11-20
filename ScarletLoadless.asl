state("Kokishin") {
	int Loading: 0x05A5464;
}

update {
	vars.Loading = false;
	if (current.Loading == 257) {
		vars.Loading = true;
	}
}

isLoading {
	return vars.Loading;
}