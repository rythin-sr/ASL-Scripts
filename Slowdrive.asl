

state("Slowdrive")
{
	int sNR:	"mono.dll", 0x0020A504, 0x10, 0x3C, 0xA00;
	int sHS:	"mono.dll", 0x001F62CC, 0x48, 0x8, 0x4A0, 0x8, 0x0, 0x824;
	int sO:		"mono.dll", 0x001F40AC, 0x4B0, 0x14, 0x44, 0x28, 0x4C, 0x108;
	int cs:		"mono.dll", 0x001F40AC, 0x5F0, 0x10, 0x8, 0xB4, 0x148;
}

startup {
	settings.Add("all", false, "Split when acquiring any amount of stars");
	settings.Add("40", true, "Split upon collecting the 40th star");
	settings.Add("60", true, "Split upon collecting the 60th star");
	settings.Add("85", true, "Split upon collecting the 85th star");

	vars.cStars = 0;
	vars.oStars = 0;
}

update {
	vars.cStars = current.sNR + current.sHS + current.sO;
	vars.oStars = old.sNR + old.sHS + old.sO;
}

start {
	if (vars.cStars == 0 && current.cs == 0 && old.cs == 1) {
		return true;
	}
}

split {
	if (vars.cStars > vars.oStars && settings["all"]) {
		return true;
	}
	
	if (vars.cStars >= 40 && vars.oStars < 40 && settings["40"]) {
		return true;
	}
	
	if (vars.cStars >= 60 && vars.oStars < 60 && settings["60"]) {
		return true;
	}
	
	if (vars.cStars >= 85 && vars.oStars < 85 && settings["85"]) {
		return true;
	}
	
	if (vars.cStars > 85 && old.cs == 0 && current.cs == 1) {
		return true;
	}
} 
