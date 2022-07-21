state("TY", "V1.44") {
    byte loading:    0x286555;
    byte autosave:   0x28DC9D;
    float ty_x:      0x270B78;
    float ty_y:      0x270B7C;
    float ty_z:      0x270B80;
    float bull_x:    0x254268;
    float bull_y:    0x25426C;
    float bull_z:    0x254270;
    int bilbies:     0x2651AC;
    int cogs:        0x265260;
    int anim:        0x27158C;
    int bull_anim:   0x254560;
    string50 map:    0x288A90;
    byte TE:         0x288730, 0xD;

    byte mm_index:   0x286640;
    byte save_index: 0x28E6C4;
    byte menu_state: 0x28DCA0;
}

state("TY", "V1.11") {
    byte loading:    0x274085;
    byte autosave:   0x27F910; 
    float ty_x:      0x2608D4;
    float ty_y:      0x2608D8;
    float ty_z:      0x2608DC;
    float bull_x:    0x2472A4;
    float bull_y:    0x2472A8;
    float bull_z:    0x2472AC;
    int bilbies:     0x279CF8;
    int cogs:        0x279DAC;
    int anim:        0x2612E0;
    int bull_anim:   0x247594;
    string50 map:    0x278590;
    byte TE:         0x278230, 0xD;

    byte mm_index:   0x2741D0;
    byte save_index: 0x280950;
    byte menu_state: 0x27F918;
}

startup {
    vars.changeTime = false;
    vars.time = null;
    vars.autosaveTime = new Stopwatch();
    vars.diff = 0;
    vars.timeAdd = 1400; //time added per load in ms
    vars.vars = new Tuple<float, float, float>(0f, 0f, 0f); 
    vars.levelTEs = 0; //temp
    vars.levelCogs = 0; //temp, cog counter per level, could be replaced with a better address
    vars.canSplit = false; //variable used to prevent false level exit splits when starting a new run (workaround for how the map variable behaves)
    vars.bilbySplit = false; //variable used to split on the 5th bilby on any stage, tbd

    settings.Add("start", true, "Autostart only on the following savefiles");
    settings.Add("0", true, "Game 1", "start");
    settings.Add("1", true, "Game 2", "start");
    settings.Add("2", true, "Game 3", "start");
    
    settings.Add("IL", false, "IL Mode");
    settings.SetToolTip("IL", "Start the timer on entering a level, rather than Rainbow Cliffs");

    settings.Add("Splits", true);

    //identifier legend
    //* - doesn't contain TE's
    //! - hub world
    //# - exit only

    //end trigger
    //x -2231
    //y 8363
    //z -570
    //Left, Right, Left, Right, Action, Action, Bite, Bite, Action, Bite, Bite, Action

    vars.levels = new Dictionary<string, string>{
        //{"!*room_z1_05.mdl", "Rainbow Cliffs"},
        {"room_a1_02.mdl", "Two Up"},
        {"room_a2_02.mdl", "Walk in the Park"},
        {"room_a3_02.mdl", "Ship Rex"},
        {"*room_a4_02.mdl", "Bull's Pen"},
        {"room_b1_water", "Bridge on the River Ty"},
        {"room_b2_02.mdl", "Snow Worries"},
        {"Room_b3_water", "Outback Safari"},
        {"*room_d4_02.mdl", "Crikey's Cove"},
        {"Room_c1_04.mdl", "Lyre, Lyre Pants on Fire"},
        {"Room_c2_04.mdl", "Beyond the Black Stump"},
        {"room_c3_02.mdl", "Rex Marks the Spot"},
        {"*room_c4_02.mdl", "Fluffy's Fjord"},
        {"*room_e1_water.qsm", "Cass' Pass"},
        {"#*room_d2_03.mdl", "Cass' Crest"},
        {"#*end", "Final Battle"}
    };  
            
    var id = "";
        
    foreach (var lev in vars.levels) {
        
        settings.Add(lev.Key, true, lev.Value, "Splits");
        id = lev.Key;

        if (!lev.Key.Contains("#")) {
            if (lev.Key.Contains("*"))
                id = lev.Key.Remove(0, 1);
            settings.Add(id + "-i", false, "Level Entry", lev.Key);
            settings.SetToolTip(id + "-i", id + "-i");
        }

        if (lev.Key.Contains("#")) {
            id = lev.Key.Remove(0, 2);
        } else if (lev.Key.Contains("*")) {
            id = lev.Key.Remove(0, 1);
        }

        settings.Add(id + "-o", true, "Level Completion", lev.Key);
        settings.SetToolTip(id + "-o", id + "-o");

    }
}


init {

    current.x = 0.0f;
    current.y = 0.0f;
    current.z = 0.0f;

    vars.SaveVars = (Action)(() => {
        vars.vars = Tuple.Create(current.x, current.y, current.z);
    });

    vars.CheckPos = (Func<bool>)(() => {
        return 
        current.x > vars.vars.Item1 - 2.0 && 
        current.x < vars.vars.Item1 + 2.0 &&
        current.y > vars.vars.Item2 - 2.0 &&
        current.y < vars.vars.Item2 + 2.0 &&
        current.z > vars.vars.Item3 - 2.0 &&
        current.z < vars.vars.Item3 + 2.0;
    });

    print("[TY VERSION] " + modules.First().ModuleMemorySize);

    switch (modules.First().ModuleMemorySize) {
        case 5623808:
            version = "V1.44";
            break;
        case 3985408:
            version = "V1.11";
            break; 
        default:
            version = "Unknown";
        break;
    }
}

start {
    if (!settings["IL"]) {
        if (current.mm_index == 1 && current.menu_state == 0 && old.menu_state == 9 && settings[current.save_index.ToString()]) {
            vars.vars = Tuple.Create(21f, 37f, 0f);
            vars.canSplit = false;
            vars.diff = 0;
            vars.time = null;
            File.Delete("TY_Log.txt");
            return true;
        }
    } else {
        if (current.map != old.map && old.map == "room_z1_05.mdl") {
            vars.vars = Tuple.Create(21f, 37f, 0f);
            vars.canSplit = true;
            vars.diff = 0;
            return true;
        }
    }
}

update {

    //remove the map variable being blank from logic
    if (current.map != old.map && string.IsNullOrEmpty(current.map))
        current.map = old.map;

    if (current.map == "Room_b3_water") {
        current.x = current.bull_x;
        current.y = current.bull_y;
        current.z = current.bull_z;
    } else {
        current.x = current.ty_x;
        current.y = current.ty_y;
        current.z = current.ty_z;
    }

    //on load start
    if (current.loading != 0 && old.loading == 0) {
        vars.time = timer.CurrentTime.GameTime;
        vars.changeTime = true;
        print("\n\n\n[TY AUTOSPLITTER] Load starting! \nTime: " + timer.CurrentTime.GameTime + "\nchangeTime: " + vars.changeTime + "\n\n\n");
    }

    if(!vars.canSplit && current.map != "room_z1_05.mdl" && old.map == "room_z1_05.mdl") {
        print("[CANSPLIT] Hub entered, allowing splitting.");
        vars.canSplit = true;
    }

    //on autosave start
    if (current.autosave != 0 && old.autosave == 0) {
        print("autosave started, storing position");
        vars.SaveVars();
        vars.autosaveTime.Restart();
    }

    //on autosave end
    if (current.autosave == 0 && old.autosave != 0) {
        vars.autosaveTime.Stop();
        vars.diff = vars.timeAdd - vars.autosaveTime.ElapsedMilliseconds;
        print("Autosave finished, total elapsed " + vars.autosaveTime.ElapsedMilliseconds.ToString() + " ms.");
    }
}

split {

    if (current.map == "room_e4_02.mdl" && current.anim == -1 && old.anim == 50)
            return settings["end-o"];

    
    if (vars.canSplit && current.map != old.map && current.map.Length > 2) {
        return settings[old.map + "-o"] || settings[current.map + "-i"];    
    }
}

reset {
    return current.mm_index == 1 && current.menu_state == 9 && old.menu_state != 9;
}

isLoading {
    return current.loading != 0;
}

gameTime {
    if (vars.changeTime) {
        vars.changeTime = false;
        if (vars.CheckPos()) {
            print("Entered load without moving, subtracting " + vars.autosaveTime.ElapsedMilliseconds.ToString() + " ms.");
            return vars.time.Add(new TimeSpan (0, 0, 0, 0, Int32.Parse(vars.diff.ToString()))); //not sure why i need to cast to int again but it works this way :shrug:
        } else {
            print("Entered load after movement. No time will be subtracted.");
            return vars.time.Add(new TimeSpan (0, 0, 0, 0, vars.timeAdd));
        }
    }
}
