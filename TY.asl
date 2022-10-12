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
    bool hardcore:   0x288730, 0xE;
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
    vars.vars = new Tuple<float, float, int, int>(0f, 0f, 0, 0); //todo: remake this to only have 3 floats for position
    vars.levelTEs = 0; //temp
    vars.levelCogs = 0; //cog counter per level, could be replaced with a better address
    vars.canSplit = false; //variable used to prevent false level exit splits when starting a new run (workaround for how the map variable behaves)
    vars.bilbySplit = false; //variable used to split on the 5th bilby on any stage

    settings.Add("start", true, "Autostart settings");
    settings.Add("0", true, "Start on savefile 1", "start");
    settings.Add("1", true, "Start on savefile 2", "start");
    settings.Add("2", true, "Start on savefile 3", "start");
    settings.Add("hc-t", false, "Only start the timer if hardcore mode is enabled", "start");
    settings.Add("hc-f", false, "Only start the timer if hardcore mode is disabled", "start");
    
    settings.Add("IL", false, "IL Mode", "start");
    settings.SetToolTip("IL", "Start the timer on entering a level, rather than Rainbow Cliffs");

    settings.Add("Splits", true);

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

    vars.splits = new List<Tuple<float, float, float, string, string>> {
        //TWO UP
        {Tuple.Create(-2259f, 550.6962f, 8759f, "room_a1_02.mdl", "ROCK JUMP")},
        {Tuple.Create(-1301f, -217.5831f, 3217f, "room_a1_02.mdl", "SUPER CHOMP")},
        {Tuple.Create(-4882f, 603.5223f, -255f, "room_a1_02.mdl", "LOWER THE PLATFORMS")},
        {Tuple.Create(-6942f, 494.3602f, -1579f, "room_a1_02.mdl", "GLIDE THE GAP")},
        {Tuple.Create(-3825.801f, 300.3356f, 8393.806f, "room_a1_02.mdl", "TIME ATTACK")},
        //WALK IN THE PARK
        {Tuple.Create(-1842f, -1302.103f, -6165f, "room_a2_02.mdl", "DRIVE ME BATTY")},
        {Tuple.Create(-1473f, -1691.341f, -1398f, "room_a2_02.mdl", "LOG CLIMB")},
        {Tuple.Create(729f, -772.8774f, 2807f, "room_a2_02.mdl", "TREE BOUNCE")},
        {Tuple.Create(7553f, -253.759f, 6605f, "room_a2_02.mdl", "TRUCK TROUBLE")},
        {Tuple.Create(-8649.206f, -1477.341f, 7160.691f, "room_a2_02.mdl", "WOMBAT RACE")},
        //SHIP REX
        {Tuple.Create(9921f, -1030f, 24087f, "room_a3_02.mdl", "SHIP WRECK")},
        {Tuple.Create(3867f, 2047.916f, 22420f, "room_a3_02.mdl", "NEST EGG")},
        {Tuple.Create(10850f, 1021.472f, 11690f, "room_a3_02.mdl", "QUICKSAND COCONUTS")},
        {Tuple.Create(-7846f, -334f, 15949f, "room_a3_02.mdl", "AURORA'S KIDS")},
        {Tuple.Create(1501.111f, 5812.578f, -11761.9f, "room_a3_02.mdl", "WHERE'S ELLE?")},
        {Tuple.Create(-13532.11f, 294.7795f, 22441.28f, "room_a3_02.mdl", "RACE REX")},
        //BRIDGE ON THE RIVER TY
        {Tuple.Create(4445.541f, 74.05637f, -2405.105f, "room_b1_water", "TY DIVING")},
        {Tuple.Create(-4644.387f, 607.7163f, -7329.457f, "room_b1_water", "HEAT DENNIS' HOME")},
        {Tuple.Create(-2997.268f, -616.8137f, 6198.507f, "room_b1_water", "TIME ATTACK")},
        //OUTBACK SAFARI
        {Tuple.Create(-15511.79f, 4634.075f, 15988.18f, "Room_b3_water", "EMU ROUNDUP")},
        {Tuple.Create(-13764.2f, 4754.766f, 16096.4f, "Room_b3_water", "RACE SHAZZA")},
        {Tuple.Create(-10611.29f, 3878.148f, 9710.021f, "Room_b3_water", "FRILL FRENZY")},
        {Tuple.Create(20719.66f, 4294.997f, 13578.78f, "Room_b3_water", "FIRE FIGHT")},
        {Tuple.Create(59610.53f, 5118.196f, -32225.18f, "Room_b3_water", "TOXIC TROUBLE")},
        {Tuple.Create(39631f, 3843f, -31211f, "Room_b3_water", "SECRET THUNDER EGG")},
        //SNOW WORRIES
        {Tuple.Create(44084.36f, -2909.695f, -22901.12f, "room_b2_02.mdl", "MUSICAL ICICLES")},
        {Tuple.Create(41312f, -383.0116f, 2091f, "room_b2_02.mdl", "SNOWY PEAK")},
        {Tuple.Create(40510f, 825.3049f, 1204f, "room_b2_02.mdl", "THE OLD MILL")},
        {Tuple.Create(-636.1082f, -2604.479f, 634.0028f, "room_b2_02.mdl", "KOALA CHAOS")},
        {Tuple.Create(180.5436f, -2785.884f, -293.126f, "room_b2_02.mdl", "TIME ATTACK")},
        //LYRE, LYRE PANTS ON FIRE
        {Tuple.Create(-10908f, 495.2787f, 1676f, "Room_c1_04.mdl", "MUDDY TOWERS")},
        {Tuple.Create(-11592.39f, -642.2922f, 9706.435f, "Room_c1_04.mdl", "WATER WORRIES")},
        {Tuple.Create(-5861f, -224.1317f, 8936f, "Room_c1_04.mdl", "GANTRY GLIDE")},
        {Tuple.Create(-2764f, -433.3239f, -393f, "Room_c1_04.mdl", "LENNY THE LYREBIRD")},
        {Tuple.Create(-2095f, -4036.624f, 7493f, "Room_c1_04.mdl", "FIERY FURNACE")},
        {Tuple.Create(-3998.144f, -122.8365f, 1227.54f, "Room_c1_04.mdl", "TIME ATTACK")},
        //BEYOND THE BLACK STUMP
        {Tuple.Create(865f, 1368.838f, -475f, "Room_c2_04.mdl", "PILLAR PONDER")},
        {Tuple.Create(-5233.104f, 1468.222f, 1169.391f, "Room_c2_04.mdl", "CATCH BOONIE")},
        {Tuple.Create(-22388.59f, -5561.117f, 21909.55f, "Room_c2_04.mdl", "FLAME FRILLS")},
        {Tuple.Create(-5949.919f, -560.6786f, -6749.906f, "Room_c2_04.mdl", "KOALA CRISIS")},
        {Tuple.Create(-5482.391f, -570.0165f, -6684.068f, "Room_c2_04.mdl", "WOMBAT REMATCH")},
        {Tuple.Create(6823.748f, 1468.222f, 3157.422f, "Room_c2_04.mdl", "CABLE CAR CAPERS")},
        //REX MARKS THE SPOT
        {Tuple.Create(-15300.64f, -436.468f, -3191.551f, "room_c3_02.mdl", "PARROT BEARD'S BOOTY")},
        {Tuple.Create(19601f, -2171f, 2635f, "room_c3_02.mdl", "FRILL BOAT BATTLE")},
        {Tuple.Create(32446f, -1191.854f, 71f, "room_c3_02.mdl", "VOLCANIC PANIC")},
        {Tuple.Create(26109f, -1251.71f, -12980f, "room_c3_02.mdl", "GEYSER HOP")},
        {Tuple.Create(-17877.4f, -1713.9f, -10551.81f, "room_c3_02.mdl", "TREASURE HUNT")},
        {Tuple.Create(-5650.959f, -1689.456f, -1590.563f, "room_c3_02.mdl", "RACE REX")}
    };

    vars.splitsnew = new Dictionary<string, List<Tuple<float, float, float, string>>> {
        {"room_a1_02.mdl", new List<Tuple<float, float, float, string>>{Tuple.Create(-2259f, 550.6962f, 8759f, "ROCK JUMP"), Tuple.Create(-1301f, -217.5831f, 3217f, "SUPER CHOMP"), Tuple.Create(-4882f, 603.5223f, -255f, "LOWER THE PLATFORMS"), Tuple.Create(-6942f, 494.3602f, -1579f, "GLIDE THE GAP"), Tuple.Create(-3825.801f, 300.3356f, 8393.806f, "TIME ATTACK")}},
        {"room_a2_02.mdl", new List<Tuple<float, float, float, string>>{Tuple.Create(-1842f, -1302.103f, -6165f, "DRIVE ME BATTY"), Tuple.Create(-1473f, -1691.341f, -1398f, "LOG CLIMB"), Tuple.Create(729f, -772.8774f, 2807f, "TREE BOUNCE"), Tuple.Create(7553f, -253.759f, 6605f, "TRUCK TROUBLE"), Tuple.Create(-8649.206f, -1477.341f, 7160.691f, "WOMBAT RACE")}},
        {"room_a3_02.mdl", new List<Tuple<float, float, float, string>>{Tuple.Create(9921f, -1030f, 24087f, "SHIP WRECK"), Tuple.Create(3867f, 2047.916f, 22420f, "NEST EGG"), Tuple.Create(10850f, 1021.472f, 11690f, "QUICKSAND COCONUTS"), Tuple.Create(-7846f, -334f, 15949f, "AURORA'S KIDS"), Tuple.Create(1501.111f, 5812.578f, -11761.9f, "WHERE'S ELLE?"), Tuple.Create(-13532.11f, 294.7795f, 22441.28f, "RACE REX")}},
        {"room_b1_water",  new List<Tuple<float, float, float, string>>{Tuple.Create(4445.541f, 74.05637f, -2405.105f, "TY DIVING"), Tuple.Create(-4644.387f, 607.7163f, -7329.457f, "HEAT DENNIS' HOME"), Tuple.Create(-2997.268f, -616.8137f, 6198.507f, "TIME ATTACK")}},
        {"Room_b3_water",  new List<Tuple<float, float, float, string>>{Tuple.Create(-15511.79f, 4634.075f, 15988.18f, "EMU ROUNDUP"), Tuple.Create(-13764.2f, 4754.766f, 16096.4f, "RACE SHAZZA"), Tuple.Create(-10611.29f, 3878.148f, 9710.021f, "FRILL FRENZY"), Tuple.Create(20719.66f, 4294.997f, 13578.78f, "FIRE FIGHT"), Tuple.Create(59610.53f, 5118.196f, -32225.18f, "TOXIC TROUBLE"), Tuple.Create(39631f, 3843f, -31211f, "SECRET THUNDER EGG")}},
        {"room_b2_02.mdl", new List<Tuple<float, float, float, string>>{Tuple.Create(44084.36f, -2909.695f, -22901.12f, "MUSICAL ICICLES"), Tuple.Create(41312f, -383.0116f, 2091f, "SNOWY PEAK"), Tuple.Create(40510f, 825.3049f, 1204f, "THE OLD MILL"), Tuple.Create(-636.1082f, -2604.479f, 634.0028f, "KOALA CHAOS"), Tuple.Create(180.5436f, -2785.884f, -293.126f, "TIME ATTACK")}},
        {"Room_c1_04.mdl", new List<Tuple<float, float, float, string>>{Tuple.Create(-10908f, 495.2787f, 1676f, "MUDDY TOWERS"), Tuple.Create(-11592.39f, -642.2922f, 9706.435f, "WATER WORRIES"), Tuple.Create(-5861f, -224.1317f, 8936f, "GANTRY GLIDE"), Tuple.Create(-2764f, -433.3239f, -393f, "LENNY THE LYREBIRD"), Tuple.Create(-2095f, -4036.624f, 7493f, "FIERY FURNACE"), Tuple.Create(-3998.144f, -122.8365f, 1227.54f, "TIME ATTACK")}},
        {"Room_c2_04.mdl", new List<Tuple<float, float, float, string>>{Tuple.Create(865f, 1368.838f, -475f, "PILLAR PONDER"), Tuple.Create(-5233.104f, 1468.222f, 1169.391f, "CATCH BOONIE"), Tuple.Create(-22388.59f, -5561.117f, 21909.55f, "FLAME FRILLS"), Tuple.Create(-5949.919f, -560.6786f, -6749.906f, "KOALA CRISIS"), Tuple.Create(-5482.391f, -570.0165f, -6684.068f, "WOMBAT REMATCH"), Tuple.Create(6823.748f, 1468.222f, 3157.422f, "CABLE CAR CAPERS")}},
        {"room_c3_02.mdl", new List<Tuple<float, float, float, string>>{Tuple.Create(-15300.64f, -436.468f, -3191.551f, "PARROT BEARD'S BOOTY"), Tuple.Create(19601f, -2171f, 2635f, "FRILL BOAT BATTLE"), Tuple.Create(32446f, -1191.854f, 71f, "VOLCANIC PANIC"), Tuple.Create(26109f, -1251.71f, -12980f, "GEYSER HOP"), Tuple.Create(-17877.4f, -1713.9f, -10551.81f, "TREASURE HUNT"), Tuple.Create(-5650.959f, -1689.456f, -1590.563f, "RACE REX")}}
    };
        
            
    var id = "";
        
    foreach (var lev in vars.levels) {
        
        settings.Add(lev.Key, true, lev.Value, "Splits");
        id = lev.Key;

        if (!lev.Key.Contains("#")) {
            if (lev.Key.Contains("*"))
                id = lev.Key.Remove(0, 1);
            settings.Add(id + "-i", false, "Level Entry", lev.Key);
        }

        if (lev.Key.Contains("#")) {
            id = lev.Key.Remove(0, 2);
        } else if (lev.Key.Contains("*")) {
            id = lev.Key.Remove(0, 1);
        }

        settings.Add(id + "-o", true, "Level Completion", lev.Key);

        

        if (!lev.Key.Contains("*")) {
            settings.Add(lev.Key + "-TE", false, "Thunder Eggs", lev.Key);

            settings.Add(lev.Key + "Cogs", false, "Cogs", lev.Key);
            for (int i = 1; i < 11; i++) {
                settings.Add(lev.Key + "-c" + i, false, "Cog #" + i, lev.Key + "Cogs");
            }

            settings.Add(lev.Key + "Bilbies", false, "Bilbies", lev.Key);
            for (int i = 1; i <= 5; i++) {
                settings.Add(lev.Key + "-b" + i, false, "Bilby #" + i, lev.Key + "Bilbies");
            }
            settings.SetToolTip(lev.Key + "-b5", "Will split when picking up the TE.");
        }

    }

    foreach (var entry in vars.splits) {
        settings.Add(entry.Item5 + "-" + entry.Item4, false, entry.Item5, entry.Item4 + "-TE");
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
            if (version == "V1.44") {
                return settings["hc-t"] && current.hardcore || settings["hc-f"] && !current.hardcore || !settings["hc-f"] && !settings["hc-t"];
            } else {
                return true;
            }
        }
    } else {
        if (current.map != old.map && old.map == "room_z1_05.mdl") {
            vars.vars = Tuple.Create(0f, 0f, 0, 0);
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
    }

    if(!vars.canSplit && current.map != "room_z1_05.mdl" && old.map == "room_z1_05.mdl") {
        vars.canSplit = true;
    }

    //on autosave start
    if (current.autosave != 0 && old.autosave == 0) {
        vars.SaveVars();
        vars.autosaveTime.Restart();
    }

    //on autosave end
    if (current.autosave == 0 && old.autosave != 0) {
        vars.autosaveTime.Stop();
        vars.diff = vars.timeAdd - vars.autosaveTime.ElapsedMilliseconds;
    }
}

split {

    if (current.map == "room_e4_02.mdl" && current.anim == -1 && old.anim == 50)
            return settings["end-o"];

    
    if (vars.canSplit && current.map != old.map && current.map.Length > 2) {
        vars.levelTEs = 0;
        vars.levelCogs = 0;
        return settings[old.map + "-o"] || settings[current.map + "-i"];    
    }
    
    if (current.TE == old.TE + 1) {
        foreach (var split in vars.splitsnew[current.map]) {
            if 
            (current.x > split.Item1 - 2.0 && 
            current.x < split.Item1 + 2.0 &&
            current.z > split.Item3 - 2.0 &&
            current.z < split.Item3 + 2.0) {
                return settings[split.Item4 + "-" + current.map];
            }
            
        }
    }

    if (current.cogs == old.cogs + 1) {
        vars.levelCogs++;
        return settings[current.map + "-c" + vars.levelCogs];
    }

    if (current.bilbies == old.bilbies + 1 && current.bilbies <= 4) {
        return settings[current.map + "-b" + current.bilbies];
    }

    if (current.bilbies == 5 && old.bilbies == 4) {
        vars.bilbySplit = true;
    }

    if (vars.bilbySplit && current.anim == 33 || current.bull_anim == 11) {
        vars.bilbySplit = false;
        return settings[current.map + "-b5"];
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
            return vars.time.Add(new TimeSpan (0, 0, 0, 0, Int32.Parse(vars.diff.ToString()))); //not sure why i need to cast to int again but it works this way :shrug:
        } else {
            return vars.time.Add(new TimeSpan (0, 0, 0, 0, vars.timeAdd));
        }
    }
}
