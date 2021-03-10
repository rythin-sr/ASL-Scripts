//Minecraft Dungeons Autosplitter + Load Remover
//Code and Launcher Version addresses by rythin
//Windows Store Version addresses by KunoDemetries, Krvne, Birdi

state("Dungeons-Win64-Shipping", "Launcher, 1.0") {

	//increases by 1 every frame, up to 255 then back to 0, counting pauses during loads or lag
	byte counter:   0x3B1C7B8;
	
	//0 during loading AND end-of-mission chest animations
	byte lc:        0x3F5D26A;
	
	//seed given to the level when its loaded, 0 in menu and tutorial, 1 in lobby
	int seed:       0x03FA1B98, 0xD80, 0x440, 0x50;
	
	//1 when in a cutscene, 0 otherwise
	int cs:         0x03FA1AF8, 0x8;
}

state("Dungeons", "Windows Store, 1.0") {
	byte counter:   0x3F1A789;
	byte lc:        0x3F5F32A;
	int seed:       0x03CED8A8, 0x20, 0xD80, 0x4E8;
	int cs:         0x03FA3BB8, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.2.1.0") {
	byte counter:   0x3B2B648;
	byte lc:        0x3F6C6E5;
	int seed:       0x03FB1018, 0xD80, 0x380, 0x50;
	int cs:         0x03FB0F78, 0x8;
}

state("Dungeons", "Windows Store, 1.2.1.0") {
	byte counter:   0x3B2E648;
	byte lc:        0x3F6F7A5;
	int seed:      	0x03FB40D8, 0xCA0, 0xD80, 0x380, 0x50;
	int cs:         0x03FB4038, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.3.2.0") {
	byte counter:   0x3F4F414;
	byte lc:        0x3FA12E5;
	int seed:       0x03FD84B8, 0x8, 0x2F0, 0x50;
	int cs:         0x03FD8588, 0x8;
}

state("Dungeons", "Windows Store, 1.3.2.0") {
	byte counter:   0x3B58688;
	byte lc:        0x3FA7425;
	int seed:       0x03FDE5F8, 0x8, 0x4D8, 0x20, 0x438;
	int cs:         0x03FDE6C8, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.4.3.0") {
	byte counter:   0x4021824;
	byte lc:        0x4073702;
	int seed:       0x040AA8D8, 0x8, 0xB8, 0x498;
	int cs:         0x040AA9A8, 0x8;
}

state("Dungeons", "Windows Store, 1.4.3.0") {
	byte counter:   0x3C23B98;
	byte lc:        0x4079842;
	int seed:       0x03EAE618, 0x90, 0x8, 0x218, 0x3C0, 0x20, 0x498;
	int cs:         0x040B0AE8, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.4.6.0") {
	byte counter:   0x4023924;
	byte lc:        0x4075802;
	int seed:       0x03C13328, 0x230, 0x8, 0x170, 0x170, 0x2A8, 0x20, 0x498;
	int cs:         0x040ACAA8, 0x8;
}

state("Dungeons", "Windows Store, 1.4.6.0") {
	byte counter:   0x3C25C48;
	byte lc:        0x3FB4DC2;
	int seed:       0x040B2B18, 0x8, 0x7F8, 0x1F8, 0x20, 0x498;
	int cs:         0x040B2BE8, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.5") {
	byte counter:   0x3CEC568;
	byte lc:        0x414A8C2;
	int seed:       0x4181A98, 0x8, 0x3F0;
	int cs:         0x4181B68, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.7.2") {
	byte counter:    0x3D5CD88;
	byte lc:         0x41BBAC2;
	int seed:        0x041DA5B0, 0x498, 0x20, 0x278, 0x458, 0x5A0, 0x950, 0x30;
	int cs:	         0x041F2D68, 0x8;
}

state("Dungeons", "Windows Store, 1.7.2") {
	byte counter:    0x416BD24;
	byte lc:         0x41BDC02;
	int seed:        0x041F4DD8, 0x498, 0x440, 0x898, 0x20, 0x5E0, 0x8;
	int cs:          0x041F4EA8, 0x8;
}

state("Dungeons-Win64-Shipping", "Launcher, 1.8.0.0") {
	byte counter:    0x42CE2E4;
	byte lc:         0x43201C2;
	int seed:        0x4357398, 0x8, 0x678, 0x20, 0x4F0;	//'Fixed' for Panda smh
	int cs:          0x4357468, 0x8;
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
	
	var mem_size = modules.First().ModuleMemorySize;
	
	switch(mem_size) {
		case 93192192:
		version = "Launcher, 1.0";
		break;
		
		case 93487104:
		version = "Windows Store, 1.0";
		break;
	
		case 93143040:
		version = "Launcher, 1.2.1.0";
		break;
	
		case 93814784:
		version = "Windows Store, 1.2.1.0";
		break;
	
		case 93663232:
		version = "Launcher, 1.3.2.0";
		break;
	
		case 94089216:
		version = "Windows Store, 1.3.2.0";
		break;
	
		case 94253056:
		version = "Launcher, 1.4.3.0";
		break;
	
		case 94683136:
		version = "Windows Store, 1.4.3.0";
		break;
	
		case 94937088:
		version = "Launcher, 1.4.6.0";
		break;
	
		case 94216192:
		version = "Windows Store, 1.4.6.0";
		break;
		
		case 95961088:
		version = "Launcher, 1.5";
		break;
		
		case 96776192:
		version = "Launcher, 1.7.2";
		break;
		
		case 96251904:
		version = "Windows Store, 1.7.2";
		break;
		
		case 98217984:
		version = "Launcher, 1.8.0.0";
		break;
	
		default:
		version = "Currently Not Supported";
		break;
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
		vars.SetTextComponent("count:", (current.counter).ToString());
		vars.SetTextComponent("lc:", (current.lc).ToString());
		vars.SetTextComponent("seed:", (current.seed).ToString());
		vars.SetTextComponent("cs:", (current.cs).ToString());
		vars.SetTextComponent("ModuleMemorySize:", (modules.First().ModuleMemorySize).ToString());
	}
	
	//logic for determining when the game is loading
	//this needs to be in update so that the variable updates even when the timer isnt running
	if (current.lc == 0) {						//only run this logic during loads (and chest anims but shh)
		Thread.Sleep(50);					//specifically on win store version the value flickers mid-load, so have 50ms of leeway
		if (current.lc == 0) {					//check again just to be sure
			if (old.counter == current.counter) {		//when the value stops updating
				vars.h = current.counter;		//set h to that value	
				Thread.Sleep(10);			//wait 10ms
				if (vars.h == current.counter) {	//if the value is still the same
					vars.L = 1;
				}
		
				else if (current.counter == vars.h + 1) {	//sometimes the value can advance 1 during loads
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
