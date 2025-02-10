state("Rusted_Moss") {
    int room: 0x8A9E28;
}

startup {
    var settings_creator = new List<Tuple<int, int, string>> {
        Tuple.Create(47, 562, "Ichor Refinery"),
        Tuple.Create(572, 575, "Shotgun Room Exit"),
        Tuple.Create(506, 337, "Rocket Launcher Room Exit"),
        Tuple.Create(243, 491, "Elflame Entry"),
        Tuple.Create(818, 557, "Seer Entry")
    };

    foreach (var entry in settings_creator) {
        settings.Add(entry.Item1 + "-" + entry.Item2, false, entry.Item3);
    }
}

start {
    return current.room == 19 && old.room == 1;
}

split {

    if (current.room != old.room) {
        //ending split
        if (current.room == 10 && old.room > 800)
            return true;
        else
            return settings[old.room.ToString() + "-" + current.room.ToString()];
    }
}
