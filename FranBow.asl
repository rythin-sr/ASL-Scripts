//Fran Bow Load Remover by rythin

//Contanct info in case issues arise:
//Discord: rythin#0135
//Twitter: rythin_sr
//Twitch:  rythin_sr

state("Fran Bow") {
	int gameLoading:	0x385990;	//0 when gameplay
	int roomID:			0x59D310;
}

//in case i wanna support demo runs at some point later on
//state("Fran Bow Demo") {
//	byte gameLoading:	0x00084E00, 0x66C;	//84 when loading
//}

startup {
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
	
	settings.Add("roomDisp", false, "Display the current room's ID");
	//temporary roomID display for runners to decide where they want autosplitting to happen
}

update {
	if (settings["roomDisp"]) {
		vars.SetTextComponent("Room ID:", (current.roomID).ToString());
	}
}

start {
	return (old.roomID == 6 && current.roomID == 134);
}

isLoading {	
	return (current.gameLoading != 0);
}
