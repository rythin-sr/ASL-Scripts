state("RedFactionArmageddon_DX11", "Steam") {
    bool loading:      0x1CEA928;  //1 on loads and fmvs leading to a load
    int map:           0x98DE28;   //0-27 on the according levels, large number in loads
    bool fmv:          0x121CDB8;  //1 in fmv cutscenes
    string25 fmv_name: 0x996BA8;   //the filename of the fmv currently playing
}

state("RedFactionArmageddon", "Steam") {
    bool loading:      0xC1C653;
    int map:           0x99DE28;
    bool fmv:          0x122B82B;
    string25 fmv_name: 0x9A6BA8;
}

state("RedFactionArmageddon_DX11", "GOG") {
    bool loading:      0x1CF7D28;
    int map:           0x1A50714;
    bool fmv:          0x9A4C8C;
    string25 fmv_name: 0x9A4BF8;
}

state("RedFactionArmageddon", "GOG") {
    bool loading:      0x1D07828;
    int map:           0x9ACE28;
    bool fmv:          0x9B5C8C;
    string25 fmv_name: 0x9B5BF8;
}

startup {
    vars.last_level = 0;
    vars.last_fmv = "";
    vars.sw = new Stopwatch();
}

init {
    switch (modules.First().ModuleMemorySize) {
        case 51249152:
        case 49659904:
            version = "GOG";
            break;
        case 51187712:
        case 49602560: 
        default:
            version = "Steam";
            break;
    }
}

update {
    if (current.fmv && !old.fmv) {
        vars.sw.Restart();
    }
    
    if (vars.sw.ElapsedMilliseconds > 900) {
        vars.last_fmv = current.fmv_name;
        vars.sw.Reset();
    }
}

start {
    if ((current.map == 0 || current.map == 28) && !current.loading && old.loading) {
        vars.last_level = current.map;
        return true;
    }
}

split {
    if (current.map == vars.last_level + 1) {
        vars.last_level++;
        return true;
    }
    
    if (!current.fmv && old.fmv && (vars.last_fmv.ToLower() == "m17_mo_theend_cs_19.bik" || vars.last_fmv.ToLower() == "dlc04_m04_end.bik")) {
        return true;
    }
}

isLoading {
    return (current.loading && !current.fmv || current.map == -1);
}

exit {
    timer.IsGameTimePaused = true;
}
