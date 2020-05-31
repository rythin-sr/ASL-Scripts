//todo: 
//find addresses for" the map you're currently in and when a cutscene is playing
//final split
//smarter splits between levels
//better autostart & reset

//build 4142545, aka 1.0(?)
state("Dungeons-Win64-Shipping", "MCD Launcher") {

	//increases by 1 every frame(?), up to 255 then back to 0, counting pauses during loads or lag
	byte what:		0x3B1C7B8;
	
	//0 during loading AND end-of-mission chest animations
	byte lc:	0x3F5D26A;
	
	//seed given to the level when its loaded
	int seed:		0x03FA1B98, 0xD80, 0x440, 0x50;
}

startup {
	vars.h = 0;		//used for isLoading logic
	vars.inTut = 0;		//used for autoreset logic
	vars.dispS = 1;		//used for seed display
	vars.lastSeed = 0;	//used for autosplitting (hopefully not for long)
	
	refreshRate = 30;
	
	settings.Add("seedD", false, "Display the current level's seed");
	settings.Add("introS", false, "Split upon completing Squid Coast");
	settings.Add("levelS", true, "Split upon completing a level (final split is still manual)");
	
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
		var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
		var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
		if (textSetting == null)
		{
		var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
		var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
		timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

		textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
		textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
		}

		if (textSetting != null)
		textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});
}

init {
	if (modules.First().ModuleMemorySize == 93192192) {
		version = "MCD Launcher";
	}
	
	else {
		version = "Windows Store Currently Not Supported";
	}
}


start {
	if (current.seed == 0 && current.lc != 0 && old.lc == 0) {
		vars.inTut = 1;
		return true;
	}
}

split {

	//tutorial split
	if (settings["introS"]) {
		if (current.seed == 1 && old.seed == 0 && vars.inTut == 1) {
			vars.inTut = 0;
			return true;
		}
	}
	
	//mission splits
	
	if (settings["levelS"]) {
		if (current.seed == 1 && old.seed == 0 && vars.lastSeed != 0) {
			vars.lastSeed = 0;
			return true;
		}
	}
	
	//final split
	//TBD
}

reset {
	if (current.seed == 0 && vars.inTut == 0) {
		//Thread.Sleep(2000);
		if (current.seed == 0 && current.lc != 0 && old.lc != 0) {
			return true;
		}
	}	
}

update {
	
	if (current.seed == 0 && old.seed > 1) {
		vars.lastSeed = old.seed;
	}
	
	int seedV = current.seed;
	
	switch (seedV) {
		
		case 1:
		vars.dispS = "Camp";
		break;
		
		case 0:
		if (vars.inTut == 1) {
			vars.dispS = "Tutorial";
		}
		break;
		
		default:
		vars.dispS = current.seed;
		break;
	}
	
	
	if (settings["seedD"]) {
		vars.SetTextComponent("Seed:", (vars.dispS).ToString());
	}
}

isLoading {
	if (current.lc == 0) {				//only run this logic during loads (and chest anims but shh)
		if (old.what == current.what) {		//when the value stops updating
			vars.h = current.what;		//set h to that value	
			Thread.Sleep(10);		//wait 10ms, probably unnecessary but bite me
			if (vars.h == current.what) {	//if the value is still the same
				return true;		//pause the timer
			}
		
			else if (current.what == vars.h + 1) {	//sometimes the value can advance 1 during loads
				return true;			//this should help with that
			}
		
			else {
				return false;
			}
		}
		
		else {
			return false;
		}
	}
	
	else {
		return false;
	}
	
}
