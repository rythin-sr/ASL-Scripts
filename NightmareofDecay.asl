state("NightmareOfDecay") {}

startup
{

    //UnityASL setup thanks to Ero
    vars.Log = (Action<object>)(output => print("[] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
    vars.Unity.LoadSceneManager = true;

    //temp
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
    settings.Add("Splits", true);
    settings.CurrentDefaultParent = "Splits";
    settings.Add("basement_sidestart-manor_frontyard", true, "1st Key");
    settings.Add("manor_servantdining-manor_easthallway", true, "Shotgun");
    settings.Add("manor_dining-manor_foyer", true, "Club Key");
    settings.Add("manor_servantstorage-manor_servanthallway", true, "Spade Key");
    settings.Add("manor_familybathroom-manor_familyhallway", true, "Square Crank");
    settings.Add("manor_gallery-manor_westhallway", true, "Diamond Key");
    settings.Add("manor_cabin-manor_courtyard", true, "Hex Crank");
    settings.Add("manor_armor-manor_gallery", true, "Crown");
    settings.Add("manor_ballroom-basement_elevator", true, "Guardians Bossfight");
    settings.Add("basement_sewer-basement_psychosave", true, "Bolt Cutters");
    settings.Add("basement_psycho-basement_westhallway", true, "Wardrobe Key");
    settings.Add("dungeon_cellar-dungeon_startstairway", true, "Cellar Disk");
    settings.Add("dungeon_rabbitcave-dungeon_rabbitcaveentrance", true, "Rabbit Disk");
    settings.Add("dungeon_spiderboss-dungeon_spiderlair", true, "Spider Disk");
    settings.Add("dungeon_lastboss-apartment_bedroom", true, "Lord of the Nightmare");
    settings.CurrentDefaultParent = null;

    settings.Add("Debug");
    settings.Add("dbg", false, "Enable debug displays", "Debug");
    settings.SetToolTip("dbg", "This will display the current room and cutscene playing as a layout component.\nThese displays must be manually removed from the layout editor after disabling.\nUse to find room/cutscene names to add/request adding additional splits.");
} 


init
{
    vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {
        
        var gm  = helper.GetClass("Assembly-CSharp", "GameManager");
        var sd  = helper.GetClass("Assembly-CSharp", "GameSaveData");
        var rm  = helper.GetClass("Assembly-CSharp", "RoomManager");
        var ro  = helper.GetClass("Assembly-CSharp", "Room");
        var csm = helper.GetClass("Assembly-CSharp", "CutsceneManager");
        var cs  = helper.GetClass("Assembly-CSharp", "Cutscene");
        var gui = helper.GetClass("Assembly-CSharp", "GameGUI");

        vars.Unity.MakeString(rm.Static, rm["currentRoom"], ro["ID"]).Name = "room";
        vars.Unity.Make<float>(gm.Static, gm["currentGameData"], sd["playTime"]).Name = "igt";
        vars.Unity.MakeString(csm.Static, csm["currentCutscene"], cs["ID"]).Name = "cs";
        vars.Unity.Make<bool>(gui.Static, gui["instance"], gui["_isOverGUI"]).Name = "gui";
        

        return true;
    });

    vars.Unity.Load(game);
}

update
{
    if (!vars.Unity.Loaded) return false;

    vars.Unity.Update();
    current.room = vars.Unity["room"].Current;
    current.cs = vars.Unity["cs"].Current;
    current.gui = vars.Unity["gui"].Current;
    current.igt = vars.Unity["igt"].Current;

    //debug stuff
    if (settings["dbg"]){
        vars.SetTextComponent("Room", vars.Unity["room"].Current);
        if (!string.IsNullOrEmpty(current.cs))
            vars.SetTextComponent("Cutscene", current.cs);
        else
            vars.SetTextComponent("Cutscene", "");
    }
}

start {
    return current.igt > 0 && old.igt == 0;
}

split {
    if (current.room != old.room) {
        return settings[old.room.ToString() + "-" + current.room.ToString()];
    }

    if (current.room == "apartment_hallway" && current.cs == "ending" && current.gui && !old.gui)
        return true;
}

reset {
    return current.igt == 0 && old.igt > 0;
}

isLoading {
    return true;
}

gameTime {
    return TimeSpan.FromSeconds(vars.Unity["igt"].Current);
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}
