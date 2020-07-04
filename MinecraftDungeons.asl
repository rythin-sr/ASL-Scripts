//Minecraft Dungeons Autosplitter + Load Remover
//Code and Launcher Version addresses by rythin
//Windows Store Version addresses by KunoDemetries, Krvne, Birdi

state("Dungeons-Win64-Shipping", "Launcher, 1.0") {

	//increases by 1 every frame, up to 255 then back to 0, counting pauses during loads or lag
	byte what:	0x3B1C7B8;
	
	//0 during loading AND end-of-mission chest animations
	byte lc:	0x3F5D26A;
	
	//seed given to the level when its loaded, 0 in menu and tutorial, 1 in lobby
	int seed:	0x03FA1B98, 0xD80, 0x440, 0x50;
	
	//1 when in a cutscene, 0 otherwise
	int cs:		0x03FA1AF8, 0x8;
}

state("Dungeons", "Windows Store, 1.0") {
	byte what:	0x3F1A789;
	byte lc:	0x3F5F32A;
	int seed:	0x03CED8A8, 0x20, 0xD80, 0x4E8;
	int cs:		0x03FA3BB8, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.2.1.0") {
	byte what:	0x3B2B648;
	byte lc:	0x3F6C6E5;
	int seed:	0x03FB1018, 0xD80, 0x380, 0x50;
	int cs:		0x03FB0F78, 0x8;
}

state("Dungeons", "Windows Store, 1.2.1.0") {
	byte what:      0x3B2E648;
	byte lc:        0x3F6F7A5;
	int seed:      	0x03FB40D8, 0xCA0, 0xD80, 0x380, 0x50;
	int cs:         0x03FB4038, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.3.2.0") {
	byte what:	0x3F4F414;
	byte lc:	0x3FA12E5;
	int seed:	0x03FD84B8, 0x8, 0x2F0, 0x50;
	int cs:		0x03FD8588, 0x8;
}

state("Dungeons", "Windows Store, 1.3.2.0") {
    byte what:      	0x3B58688;
    byte lc:        	0x3FA7425;
    int seed:       	0x03FDE5F8, 0x8, 0x4D8, 0x20, 0x438;
    int cs:         	0x03FDE6C8, 0x8;
}

startup {
	vars.h = 0;						//used for isLoading logic
	vars.inTut = 0;						//used for dumb shit fuck you
	vars.dispS = 1;						//used for seed display
	vars.L = 0;						//for some split logic dependant on loads
	vars.aslName = "Minecraft Dungeons Autosplitter";	//for the text popup


	refreshRate = 30;
	
	settings.Add("csc", true, "Require a cutscene at the start of the level to autostart the timer");
	settings.SetToolTip("csc", "Disabling this will start the timer in the main menu, can't really do much about that.");
	settings.Add("seedD", false, "Display the current level's seed");
	settings.Add("levelS", true, "Split upon completing a level");
	settings.Add("IL", false, "Enable IL-Mode");
	settings.Add("dbg", false, "Display autosplitter debug info");
	
	//in-livesplit variable display shamelessly stolen from the Defy Gravity script 
	
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

	//timing method popup also stolen, this time from Amnesia TDD

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {        
        	var timingMessage = MessageBox.Show (
           		"This game uses Loadless (time without loads) as the main timing method.\n"+
            	"LiveSplit is currently set to show Real Time (time INCLUDING loads).\n"+
            	"Would you like the timing method to be set to Loadless for you?",
           		 vars.aslName + " | LiveSplit",
           		 MessageBoxButtons.YesNo,MessageBoxIcon.Question
       		);
		
        	if (timingMessage == DialogResult.Yes) {
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
	
	if (modules.First().ModuleMemorySize == 93192192) {
		version = "Launcher, 1.0";
	}
	
	else if (modules.First().ModuleMemorySize == 93487104) {
		version = "Windows Store, 1.0";
	}
	
	else if (modules.First().ModuleMemorySize == 93143040) {
		version = "Launcher, 1.2.1.0";
	}
	
	else if (modules.First().ModuleMemorySize == 93814784) {
		version = "Windows Store, 1.2.1.0";
	}
	
	else if (modules.First().ModuleMemorySize == 93663232) {
		version = "Launcher, 1.3.2.0";
	}
	
	else if (modules.First().ModuleMemorySize == 94089216) {
		version = "Windows Store, 1.3.2.0";
	}
	
	else {
		version = "Currently Not Supported";
	}
	
	//print("VERSION THING: " + modules.First().ModuleMemorySize.ToString()); 

}


start {
	if (settings["IL"] == false) {
 		if (settings["csc"] == false && current.seed != 1 && vars.L == 0) {
           		return true;
        	}
		
		if (settings["csc"] == true && current.seed != 1 && vars.L == 0 && current.cs == 1) {
           		return true;
        	}
    	}
	
	if (settings["IL"] == true) {
		if (current.seed > 1 || current.seed == 0 ) {
			if (current.cs == 0 && old.cs == 1 || current.cs == 0 && vars.L == 0) {
				return true;
			}
		}
	}
}

split {	
	//mission splits (also final split)
	
	if (settings["levelS"] || settings["IL"]) {
		if (current.cs == old.cs + 1 && vars.L == 0) {
			return true;
		}
	}
	
}

reset {
	if (settings["IL"]) {
		if (current.seed == 1) {
			return true;
		}
	}	
}

update {
	
	if (current.seed == 0 && vars.L == 0) {
		vars.inTut = 1;
	}
	
	else {
		vars.inTut = 0;
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
	
	//actual bit that does the displaying
	
	if (settings["seedD"]) {
		vars.SetTextComponent("Seed:", (vars.dispS).ToString());
	}
	
	if (settings["dbg"]) {
		vars.SetTextComponent("count:", (current.what).ToString());
		vars.SetTextComponent("lc:", (current.lc).ToString());
		vars.SetTextComponent("seed:", (current.seed).ToString());
		vars.SetTextComponent("cs:", (current.cs).ToString());
	}
	
	//logic for determining when the game is loading
	//this needs to be in update so that the variable updates even when the timer isnt running
	if (current.lc == 0) {					//only run this logic during loads (and chest anims but shh)
		Thread.Sleep(50);				//specifically on win store version the value flickers mid-load, so have 50ms of leeway
		if (current.lc == 0) {				//check again just to be sure
			if (old.what == current.what) {		//when the value stops updating
				vars.h = current.what;		//set h to that value	
				Thread.Sleep(10);		//wait 10ms
				if (vars.h == current.what) {	//if the value is still the same
					vars.L = 1;
				}
		
				else if (current.what == vars.h + 1) {	//sometimes the value can advance 1 during loads
					vars.L = 1;
				}
		
				else {
					vars.L = 0;
				}
			}
		
			else {
				vars.L = 0;
			}
		}
		
		else {
				vars.L = 0;
		}
	}
	
	else {
		vars.L = 0;
	}
}

isLoading {
	return (vars.L == 1);
}
