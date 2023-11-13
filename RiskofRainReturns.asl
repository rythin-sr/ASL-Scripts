//1.0.2
//exe size 36282368 
//data file size 83994796 

state("Risk of Rain Returns", "1.0.2") {
    int room: 0x1DD0A80;
}

startup {
    vars.dontSplit = new List<int>(new int[] {18, 19});

    settings.Add("splits", true, "Split on stage transition");
    settings.SetToolTip("splits", "Disabling this will still split at the end of the run,\njust not for the intermediate stages.");
    settings.Add("smart_resets", false, "Only auto-reset on the first split");
    settings.SetToolTip("smart_resets", "Use this setting for multi-character runs.");
}

init {
    //print("VERSION: " + new FileInfo(modules.First().FileName + @"\..\data.win").Length);
}

start {
   return current.room != 19 && old.room == 19 && current.room != 64 && current.room != 18;
}

update {
    //if (current.room != old.room)
    //    print("ROOM CHANGE: " + old.room + " -> " + current.room);
}

split {
    if (current.room != old.room) {
        //print("ROOM CHANGE: " + old.room + " -> " + current.room);
        if (!vars.dontSplit.Contains(current.room) && !vars.dontSplit.Contains(old.room)) {
            if (current.room == 16)
                return true;
            else 
                return settings["splits"];
        }
    }
}

reset {
   if (current.room == 19) {
        if (settings["smart_resets"]) {
            return timer.CurrentSplitIndex == 0;
        } else {
            return true;
        }
    }
}
