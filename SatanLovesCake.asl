//Satan Loves Cake Autosplitter + Game Time by rythin

state("SATAN LOVES CAKE 1.4") {
	double igt: 		0x004B392C, 0x12C, 0x10, 0x390, 0x400;	//frame count
	double charge:		0x004B27F8, 0x2C, 0x10, 0x768, 0x430;	//	
	double walljump:	0x004B27F8, 0x2C, 0x10, 0xB40, 0x10;	//
	double bossT:		0x004B2780, 0x2C, 0x10, 0x1EC, 0x3E0;	//taiyaki
	double bossK:		0x004B2780, 0x2C, 0x10, 0x1EC, 0x3D0;	//kajkage
	double hpM:		0x004B2780, 0x2C, 0x10, 0x7A4, 0x3B0;	//max hp
	double hpC:		0x004B2780, 0x2C, 0x10, 0xB88, 0x3D0;	//current hp
	double d:		0x004B2780, 0x2C, 0x10, 0x27C, 0x380;	//1 when there's dialogue on screen, 0 otherwise
	int roomID:		0x6C2DB8;
}

startup {
	//setting groups
	settings.Add("boss", true, "Bosses");
	settings.Add("ups", true, "Upgrades");
	settings.Add("misc", true, "Misc");
	
	//settings
	settings.Add("bT", true, "Taiyaki", "boss");
	settings.Add("bK", true, "Kajkage", "boss");
	settings.Add("uC", false, "Charge", "ups");
	settings.Add("uWJ", false, "Walljump", "ups");
	settings.Add("hp1", false, "Life Upgrade 1", "ups");
	settings.Add("hp2", false, "Life Upgrade 2", "ups");
	settings.Add("dc", false, "Death Counter", "misc");
	
	vars.igtD = 0;
	vars.dc = 0; //dialogue counter used for final split
	vars.deathc = 0; //death counter
	vars.done = new List<string>();	//since dying resets progress, we need to prevent splitting a second time upon completing a goal

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

start {
	if (current.roomID == 4 && old.roomID == 2) {
		vars.done.Clear();
		vars.deathc = 0;
		vars.igtD = 0;
		vars.dc = 0;
		return true;
	}
}

split {
	if (settings["bT"]) {
		if (current.bossT == 1 && old.bossT == 0 && !vars.done.Contains("b1")) {
			vars.done.Add("b1");
			return true;
		}
	}

	if (settings["bK"]) {
		if (current.bossK == 1 && old.bossK == 0 && !vars.done.Contains("b2")) {
			vars.done.Add("b2");
			return true;
		}	
	}
	
	if (settings["uC"]) {
		if (current.charge == 1 && old.charge == 0 && !vars.done.Contains("up1")) {
			vars.done.Add("up1");
			return true;
		}
	}
	
	if (settings["uWJ"]) {
		if (current.walljump == 1 && old.walljump == 0 && !vars.done.Contains("up2")) {
			vars.done.Add("up2");
			return true;
		}
	}
	
	if (settings["hp1"]) {
		if (current.hpM == 4 && old.hpM == 3 && !vars.done.Contains("hp1")) {
			vars.done.Add("hp1");
			return true;
		}
	}
	
	if (settings["hp2"]) {
		if (current.hpM == 5 && old.hpM == 4 && !vars.done.Contains("hp2")) {
			vars.done.Add("hp2");
			return true;
		}
	}

	//final split
	if (vars.dc == 2) {
		vars.dc = 0;
		return true;
	}
}
reset {
	return (current.roomID == 2);
}

update {
	if ((current.igt - 1) / 60 > 0) {
		vars.igtD = (current.igt - 1) / 60;
	}
	
	if (current.hpC == 0 && old.hpC > 0) {
		vars.deathc++;
	}
	
	if (settings["dc"]) {
		vars.SetTextComponent("Deaths:", (vars.deathc).ToString());
	}
	
	//before the credits roll, in the final room 
	//there happen 2 instances of dialogue, which we need to count
	if (current.roomID == 13 && current.d == 0 && old.d == 1) {
		vars.dc++;
	}
}
	

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(vars.igtD);
}
