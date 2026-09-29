class CfgWeapons
{
    class missiles_SCALPEL;

    class J_Hellfire_Launcher_K: missiles_SCALPEL
    {
        author = "Johto";
        displayName = "AGM-114K Hellfire";
        magazines[] =
        {
            "PylonMissile_1Rnd_J_Hellfire_AGM114K",
            "PylonRack_3Rnd_J_Hellfire_AGM114K",
            "PylonRack_4Rnd_J_Hellfire_AGM114K"
        };
        canLock = 0;
        weaponLockSystem = 0;
    };

    class J_Hellfire_Launcher_N: J_Hellfire_Launcher_K
    {
        displayName = "AGM-114N Hellfire";
        magazines[] =
        {
            "PylonMissile_1Rnd_J_Hellfire_AGM114N",
            "PylonRack_3Rnd_J_Hellfire_AGM114N",
            "PylonRack_4Rnd_J_Hellfire_AGM114N"
        };
    };

    // Legacy class retained so old editor/loadout references do not become
    // undefined. New K/N magazines no longer use this shared launcher.
    class J_Hellfire_Launcher: J_Hellfire_Launcher_K
    {
        scope = 1;
        displayName = "AGM-114 Hellfire (Legacy)";
    };

    class J_Hellfire_Launcher_L: J_Hellfire_Launcher_K
    {
        displayName = "AGM-114L Longbow Hellfire";
        magazines[] =
        {
            "PylonMissile_1Rnd_J_Hellfire_AGM114L",
            "PylonRack_3Rnd_J_Hellfire_AGM114L",
            "PylonRack_4Rnd_J_Hellfire_AGM114L"
        };
        canLock = 2;
        weaponLockSystem = 8;
        magazineWell[] = {"J_Hellfire_L"};
    };
};
