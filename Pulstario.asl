state("Pulstario") {
	int roomID:        0x6C2DB8;
	double frameCount: 0x4B2780, 0x2C, 0x10, 0x4E0, 0x1D0;
	double deathCount: 0x4B2780, 0x2C, 0x10, 0x0, 0x120;
}

startup {

	settings.Add("deathDisp", false, "Display death count");

	//display thing yoinked from the Defy Gravity autosplitter
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

update {
	if (settings["deathDisp"] == true) {
		vars.SetTextComponent("Deaths", (current.deathCount).ToString());
	}
}

start {
	return (old.roomID != 2 && current.roomID == 2);
}

split {
	return (current.roomID != old.roomID && old.roomID != 25 && current.roomID != 1);
}

reset {
	return (current.roomID == 1 && old.roomID != 1);
}

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(current.frameCount / 60);
}
