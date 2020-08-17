//Garfield: Lasagna World Tour Autosplitter by rythin

state("Garfield", "International") {
	//string with some file path, includes the map name which is the important part
	string30 map:		0x1685E7;
	
	//a value that goes up/down as the text in menus grows/shrinks
	//is consistently 215 on the main menu and 86 in the "new game" selection menu
	//may be related to the text font size?
	byte menuState:		0x1094EC;
	
	//final boss hp
	float boss:		0x00126A34, 0x308;
}

state ("Garfield", "Russian") {
	string30 map:		0x16BD0F;
	byte menuState:		0x10CC1C;
	float boss:		0x0012A154, 0x308;
}

startup {

	vars.d = new Dictionary<string, string> {
		{@"Single\Level_01\Level_01.ins", "Intro"},
		{@"Single\Race_01\Race_01.ins", "Run, Odie! Run!"},
		{@"Single\Level_04\Level_04.ins", "Bandages and sarcophagi"},
		{@"Single\Level_05\Level_05.ins", "Temple almost of doom"},
		{@"Single\Race_02\Race_02.ins", "Roll, you ball!"},
		{@"Single\Level_27\Level_27.ins", "The good, the bad and the spicy"},
		{@"Single\Level_08\Level_08.ins", "For a fistful of lasagna"},
		{@"Single\Level_09\Level_09.ins", "Meow home is your home"},
		{@"Single\Level_10\Level_10.ins", "Carnivore carnival"},
		{@"Single\Level_02\Level_02.ins", "The return of the orange King"},
	};
	
	foreach (var Tag in vars.d) {							
		settings.Add(Tag.Key, true, Tag.Value);				
    };
	
	vars.startReady = false;
	vars.doneSplits = new List<string>();	
}

update {
	
	//for the starting condition we check if menuState starts going down from 86,
	//since the value goes up and down one by one and 86 is the max value for the menu we want
	//unfortunately, the previous menu is 215 and going to the desired menu goes 215 -> 0 -> 86
	//which can set off the autostart early (215 -> 86 (midway through) -> 0 -> 86)
	//this logic should prevent most* misfires of the autostart

	if (current.map == @"Level_00\Level_00.ins") {				//while in the main menu
		if (current.menuState == 86 && old.menuState < 86) {		//the value just went from <86 to 86
			vars.startReady = true;					//ready to autostart
		}
	
		else if (current.menuState == 86 && old.menuState > 86) {	//if the value went DOWN to 86 (on the way from 215 to 0)
			print("[LASAGASPLIT]: Early start prevented"); 		//debug note 
			vars.startReady = false;				//not ready to autostart
		}
										//in case you ever go from the autostart menu (86) to the main menu (215)
		else if (current.menuState > 86) {				//there's a chance you'll set startReady to true "on the way" from 0 to 215
			vars.startReady = false;				//this should prevent that, as any menu above the desired one will set startReady to false
		}
	}
	
	//*autostart will still misfire when you go from the autostart menu back into the main menu
	//if you ever do that for whatever reason, autoreset will take care of it
	//it'll just inflate the attempt count a bit
}

init {

	if (modules.First().ModuleMemorySize == 2084864) {
		version = "Russian";
	}
	
	else if (modules.First().ModuleMemorySize == 2068480) {
		version = "International";
	}
	
	//print(modules.First().ModuleMemorySize.ToString()); 
}

start {
	if (current.map == @"Level_00\Level_00.ins" && current.menuState < old.menuState && vars.startReady == true) {
		vars.startReady = false;
		vars.doneSplits.Clear();
		return true;
	}
}

split {
	//level splits
	if (current.map != old.map && current.map != @"Level_00\Level_00.ins" && settings[old.map] && !vars.doneSplits.Contains(old.map)) {
		vars.doneSplits.Add(old.map);
		return true;
	}
	
	//final split
	if (current.map == @"Single\Boss\Boss.ins" && current.boss == 0 && old.boss == 1) {
		return true;
	}
}

reset {
	if (current.map == @"Level_00\Level_00.ins") {
		if (old.map != current.map || current.menuState == 215) {
			return true;
		}
	}
}
