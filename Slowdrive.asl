state("Slowdrive") {
	string20 stars_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x14, 0x5C, 0xC;
	string20 gwheels_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x18, 0x5C, 0xC;
	string20 leaves_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x1C, 0x5C, 0xC;
	string20 retries_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x20, 0x5C, 0xC;
	bool inDaLevel:		"mono.dll", 0x1F40AC, 0x2C4, 0x50;
	//bool cs:		"mono.dll", 0x1F40AC, 0x5F0, 0x10, 0x8, 0xB4, 0x148;
}

startup {
	
	settings.Add("stars", true, "Stars");
	
	settings.Add("allstar", false, "Any stars", "stars");
	settings.Add("40", true, "40", "stars");
	settings.Add("54", false, "54", "stars");
	settings.Add("60", true, "60", "stars");
	settings.Add("85", true, "85", "stars");
	settings.Add("108", false, "108", "stars");
	settings.Add("162", false, "162", "stars");
	settings.Add("216", false, "216", "stars");
	
	settings.Add("leaves", false, "Leaves");
	
	settings.Add("allleaves", false, "All", "leaves");
	settings.Add("72l", false, "Only the last Leaf", "leaves");
	
	settings.Add("gwheels", false, "Gold Wheels");
	
	settings.Add("allwheels", false, "All", "gwheels");
	settings.Add("72w", false, "Only the last Gold Wheel", "gwheels");
	
	settings.Add("misc", false, "Misc");
	
	settings.Add("bullets_mist", false, "Split on every 4th level in Mist", "misc");
	settings.SetToolTip("bullets_mist", "Might not work properly for any category other than Any%");
	
	settings.Add("star_disp", false, "Display your current Star count", "misc");
	settings.Add("leaf_disp", false, "Display your current Leaf count", "misc");
	settings.Add("wheel_disp", false, "Display your current Gold Wheel count", "misc");
	settings.Add("fail_disp", false, "Display your current Retry count", "misc");
	
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
	current.mist_counter = 0;
}

//also find creditsComic address

update {
	string[] stars = current.stars_stat.Split('/');
	string[] leaves = current.leaves_stat.Split('/');
	string[] gwheels = current.gwheels_stat.Split('/');
	
	current.stars = Int32.Parse(stars[0]);
	current.leaves = Int32.Parse(leaves[0]);
	current.gwheels = Int32.Parse(gwheels[0]);
	
	if (settings["star_disp"]) vars.SetTextComponent("Stars:", current.stars_stat);
	if (settings["leaf_disp"]) vars.SetTextComponent("Leaves:", current.leaves_stat);
	if (settings["wheel_disp"]) vars.SetTextComponent("Gold Wheels:", current.gwheels_stat);
	if (settings["fail_disp"]) vars.SetTextComponent("Retries:", current.retries_stat);
}

start {
	if (current.stars == 0 && current.inDaLevel && !old.inDaLevel) {
		vars.mist_counter = 0;
		return true;
	}
}

split {
	if (current.stars > old.stars) {
		if (current.stars >= 40 && old.stars < 40) return settings["40"] && !settings["allstar"];
		if (current.stars >= 54 && old.stars < 54) return settings["54"] && !settings["allstar"];
		if (current.stars >= 60 && old.stars < 60) return settings["60"] && !settings["allstar"];
		if (current.stars >= 85 && old.stars < 85) return settings["85"] && !settings["allstar"];
		if (current.stars >= 108 && old.stars < 108) return settings["108"] && !settings["allstar"];
		if (current.stars >= 162 && old.stars < 162) return settings["162"] && !settings["allstar"];
		if (current.stars >= 216 && old.stars < 216) return settings["216"] && !settings["allstar"];
		if (settings["allstar"]) return true;
		
		if (old.stars >= 85) {
			current.mist_counter++;
			if ((current.mist_counter == 4 || current.mist_counter == 8) && old.mist_counter == current.mist_counter - 1) {
				return settings["bullets_mist"];
			}
		}
	}
	
	if (current.leaves > old.leaves) {
		if (current.leaves == 72) return settings["72l"] && !settings["allleaves"];
		return settings["allleaves"];
	}
	
	if (current.gwheels > old.gwheels) {
		if (current.gwheels == 72) return settings["72w"] && !settings["allwheels"];
		return settings["allwheels"];
	}
} 
