state("Tytus")
{
    int level:         0xBEF8, 0x4;
    bool loading:      0x325D0, 0x4;
    bool pause:        0xAF718, 0x8;
    string20 dialogue: 0x1B02758;
}

start {
    return current.level == 1 && !current.loading && old.loading;
}

split 
{
    return current.level == old.level + 1 || current.level == 8 && current.pause && !old.pause && current.dialogue.Contains("Zaraz zabieram");
}

reset {
    return current.level == 1 && !current.loading && old.loading;
}

isLoading
{
    return current.loading;
}
