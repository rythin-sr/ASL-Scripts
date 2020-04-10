//Crazy Machines 2 Load Remover by rythin
//idk man i wanted to get autosplitting going too but game sucks

state("cm2") {
	bool gameLoading:	"faktum.dll", 0x00304BB4, 0x14, 0x43C;
}

isLoading {
	return current.gameLoading;
}
