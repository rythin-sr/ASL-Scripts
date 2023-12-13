//1.0.2
//data file size 83994796 
//1.0.4
//data file size 83726636 

state("Risk of Rain Returns", "1.0 - 1.0.3") {
    int room: 0x1DD0A80;
}

state("Risk of Rain Returns", "1.0.4") {
    int room: 0x1E1BA80;
}

init {
    //print("VERSION: " + new FileInfo(modules.First().FileName + @"\..\data.win").Length);
    //print("VERSION: " + modules.First().ModuleMemorySize);

    switch (modules.First().ModuleMemorySize) {
        case 36605952:
            version = "1.0.4";
        break;

        default:
            version = "1.0 - 1.0.3";
        break;
    }
}

startup {
    vars.menu_rooms = new List<int>(new int[] {18, 19});
    vars.dont_split = false;

    settings.Add("splits", true, "Split on stage transition");
    settings.SetToolTip("splits", "Disabling this will still split at the end of the run,\njust not for the intermediate stages.");
    settings.Add("smart_resets", false, "Only auto-reset on the first split");
    settings.SetToolTip("smart_resets", "Use this setting for multi-character runs.");
}

start {
   return vars.menu_rooms.Contains(old.room) && !vars.menu_rooms.Contains(current.room) && current.room != 64 && !vars.dont_split;
}

update {
    //if (current.room != old.room)
    //    print("ROOM CHANGE: " + old.room + " -> " + current.room);

    //on startup all rooms are loaded in order, this should prevent any split spam when restarting the game
    if (current.room == 19 && old.room == 0) 
        vars.dont_split = true;

    if (current.room == 19 && old.room == 20) 
        vars.dont_split = false;
}

split {
    if (current.room != old.room && !vars.dont_split) {
        if (!vars.menu_rooms.Contains(current.room) && !vars.menu_rooms.Contains(old.room)) {
            if (current.room == 16)
                return true;
            else 
                return settings["splits"];
        }
    }
}

reset {
   if (current.room == 19 || current.room == 18) {
        if (settings["smart_resets"]) {
            return timer.CurrentSplitIndex == 0;
        } else {
            return true;
        }
    }
}

