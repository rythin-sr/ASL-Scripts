//Super Blue Boy Planet Autosplitter by rythin
//Original script by eddiesaurus87

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("006", "1.2") {
	int roomID: 	0x05CB860;
}

state("006", "1.1") {
	int roomID:		0x59D310;
}

state("Super Blue Boy Planet", "2.0") {
	int	roomID:		0x6C2D90;
} 

startup {
	settings.Add("disp", false, "Display level currently being played");

	vars.levelsDone = new List<int>();
	vars.lvlDisp = "Menu";	//for making the level display neater
	
	//got this from the Defy Gravity autosplitter, cheers for that
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
	vars.prevLevel = 0;
	
	if (modules.First().ModuleMemorySize == 6225920) {
		version = "1.1";
	}
	
	if (modules.First().ModuleMemorySize == 6311936) {
		version = "1.2";
	}
	
	if (modules.First().ModuleMemorySize == 7393280) {
		version = "2.0";
	}
}   

update {

	if (current.roomID == 0) {
		vars.lvlDisp = "Menu";
	}
		
	else if (current.roomID == 24 || current.roomID == 25) {
		vars.lvlDisp = "Ending";
	}
	
	else {
		vars.lvlDisp = current.roomID;
	}
	
	
	if (settings["disp"] == true) {
		vars.SetTextComponent("Level", (vars.lvlDisp).ToString());
	}
}

start {
	if (old.roomID == 0 && current.roomID == 1) {
		vars.levelsDone.Clear();
		vars.levelsDone.Add(0);
		vars.prevLevel = 1;
		return true;
	}
}

split {
	if (vars.prevLevel != current.roomID && !vars.levelsDone.Contains(current.roomID)) {
		vars.levelsDone.Add(vars.prevLevel);
		vars.prevLevel = current.roomID;
		return true;
	}
}

reset {
	return (old.roomID == 0 && current.roomID == 1);
}