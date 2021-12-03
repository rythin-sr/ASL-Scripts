state("Inscryption") {
	int loaded:  "UnityPlayer.dll", 0x12D6708, 0x28, 0x70;
	int loading: "UnityPlayer.dll", 0x12D6708, 0x18, 0x0, 0x70;
}

isLoading {
	return current.loading != current.loaded;
}
