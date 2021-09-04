state("ENDO") {
	int loaded:  "UnityPlayer.dll", 0x1813838, 0x48, 0x98;
	int loading: "UnityPlayer.dll", 0x1813838, 0x28, 0x0, 0x98;
}

start {
	return current.loading == 1 && old.loading == 0;
}

split {
	return current.loading > old.loading && old.loading > 0 || current.loading == 0 && old.loading == 10;
}

reset {
	return current.loaded == 0 && old.loading == 0;
}

isLoading {
	return current.loading != current.loaded;
}
