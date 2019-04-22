state("MgBase") {
	int Loading: 0x059B844;
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