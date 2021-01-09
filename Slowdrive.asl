state("Slowdrive") {
	string30 clvl:		"UnityPlayer.dll", 0x10C3898, 0x0;
	string20 stars_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x14, 0x5C, 0xC;
	string20 gwheels_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x18, 0x5C, 0xC;
	string20 leaves_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x1C, 0x5C, 0xC;
	string20 retries_stat:	"mono.dll", 0x1F40AC, 0xA8C, 0xC, 0x20, 0x5C, 0xC;
	bool inDaLevel:		"mono.dll", 0x1F40AC, 0x2C4, 0x50;
	int raceTime:		"mono.dll", 0x1F40AC, 0x94C, 0x14C;
	bool finished:		"mono.dll", 0x1F40AC, 0x94C, 0x15A;
}

startup {
	
	settings.Add("stars", true, "Stars");
	
	settings.Add("every3", false, "Every 3 stars", "stars");
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
	
	settings.Add("levels", true, "Levels");
	
	vars.valid_levels = new List<string>();
	
	var d = new Dictionary<string, string> {
		{"LevelFirst", "Narrow Road 1"},
		{"2Turns", "Narrow Road 2"},
		{"Jump4", "Narrow Road 3"},
		{"Chain1", "Narrow Road 4"},
		{"Choose2", "Narrow Road 5"},
		{"Dog_v3_o", "Narrow Road 6"},
		{"Dol_v2", "Narrow Road 7"},
		{"Chain2", "Narrow Road 8"},
		{"Dang1", "Narrow Road 9"},
		{"Dang2", "Narrow Road 10"},
		{"Back1", "Narrow Road 11"},
		{"Chain3", "Narrow Road 12"},
		{"Jump3", "High Skies 1"},
		{"Cut2", "High Skies 2"},
		{"Brake_v2", "High Skies 3"},
		{"Chain4", "High Skies 4"},
		{"Jump2_o", "High Skies 5"},
		{"LevelSnake", "High Skies 6"},
		{"LevelCli_v2", "High Skies 7"},
		{"Chain5_o", "High Skies 8"},
		{"LevelJump1FBX", "High Skies 9"},
		{"LevelTransfer", "High Skies 10"},
		{"LevelTube1FBX", "High Skies 11"},
		{"Chain6", "High Skies 12"},
		{"DynLevel2", "Obstacles 1"},
		{"DynLevel1", "Obstacles 2"},
		{"DynLevel3_o", "Obstacles 3"},
		{"DChain1", "Obstacles 4"},
		{"DynLevel4", "Obstacles 5"},
		{"DynLevel5", "Obstacles 6"},
		{"DynLevel6", "Obstacles 7"},
		{"DChain2", "Obstacles 8"},
		{"DynLevelJumpHole", "Obstacles 9"},
		{"DynLevel9", "Obstacles 10"},
		{"DynLevelLong", "Obstacles 11"},
		{"DChain3", "Obstacles 12"},
		{"Mist1", "Mist 1"},
		{"Mist2", "Mist 2"},
		{"Mist3", "Mist 3"},
		{"MistChain1", "Mist 4"},
		{"Mist4", "Mist 5"},
		{"Mist5", "Mist 6"},
		{"Mist6_o", "Mist 7"},
		{"MistChain2", "Mist 8"},
		{"Mist7_o", "Mist 9"},
		{"Mist8", "Mist 10"},
		{"Mist9_v2_o", "Mist 11"}
	};
	
	foreach (var h in d) {
		settings.Add(h.Key, false, h.Value, "levels");
		vars.valid_levels.Add(h.Key); 
	}
	
	settings.Add("MistChain3", true, "Mist 12", "levels");
	vars.valid_levels.Add("MistChain3");
	
	settings.Add("misc", false, "Misc");
	
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
	
	vars.igt = 0;
}

update {
	string[] stars = current.stars_stat.Split('/');
	string[] leaves = current.leaves_stat.Split('/');
	string[] gwheels = current.gwheels_stat.Split('/');
	string[] level = current.clvl.Split(' ');
	
	current.stars = Int32.Parse(stars[0]);
	current.leaves = Int32.Parse(leaves[0]);
	current.gwheels = Int32.Parse(gwheels[0]);
	current.level = level[1].Replace("\n", "");
	
	if (current.level != old.level && vars.valid_levels.Contains(current.level)) {
		vars.last_valid_level = current.level;
	}
	
	if (settings["star_disp"]) vars.SetTextComponent("Stars:", current.stars_stat);
	if (settings["leaf_disp"]) vars.SetTextComponent("Leaves:", current.leaves_stat);
	if (settings["wheel_disp"]) vars.SetTextComponent("Gold Wheels:", current.gwheels_stat);
	if (settings["fail_disp"]) vars.SetTextComponent("Retries:", current.retries_stat);
	
	if (current.raceTime == 0 && old.raceTime > 0) {
		vars.igt += old.raceTime;
	}
}

start {
	if (current.stars == 0 && current.inDaLevel && !old.inDaLevel) {
		vars.igt = 0;
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
		if (current.stars % 3 == 0 && settings["every3"]) return true;
	}
	
	if (current.finished && !old.finished && vars.last_valid_level != "MistChain3") {
		return settings[vars.last_valid_level];
	}
	
	if (vars.last_valid_level == "MistChain3" && !current.finished && old.finished) {
		return settings["MistChain3"];
	}
	
	if (current.leaves > old.leaves) {
		if (current.leaves == 72) return settings["72l"] && !settings["allleaves"];
		return settings["allleaves"];
	}
} 

isLoading {
	return true;
}

gameTime {
	return TimeSpan.FromSeconds(Convert.ToSingle(vars.igt + current.raceTime - 1) / 60.0);
}
