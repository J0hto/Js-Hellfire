class CfgMagazines
{
    class PylonRack_1Rnd_Missile_AGM_02_F;
    class PylonRack_3Rnd_Missile_AGM_02_F;
    class PylonRack_4Rnd_LG_scalpel;

    class PylonMissile_1Rnd_J_Hellfire_AGM114K: PylonRack_1Rnd_Missile_AGM_02_F
    {
        author = "Johto";
        scope = 2;
        displayName = "1x AGM-114K Hellfire II";
        displayNameShort = "AGM-114K";
        ammo = "J_Hellfire_AGM114K";
        count = 1;
        pylonWeapon = "J_Hellfire_Launcher_K";
        hardpoints[] = {"J_Hellfire","UNI_SCALPEL","B_MISSILE_PYLON"};
    };

    class PylonRack_3Rnd_J_Hellfire_AGM114K: PylonRack_3Rnd_Missile_AGM_02_F
    {
        author = "Johto";
        scope = 2;
        displayName = "3x AGM-114K Hellfire II";
        displayNameShort = "AGM-114K";
        ammo = "J_Hellfire_AGM114K";
        count = 3;
        pylonWeapon = "J_Hellfire_Launcher_K";
        hardpoints[] = {"J_Hellfire","UNI_SCALPEL","B_MISSILE_PYLON"};
    };

    class PylonRack_4Rnd_J_Hellfire_AGM114K: PylonRack_4Rnd_LG_scalpel
    {
        author = "Johto";
        scope = 2;
        displayName = "4x AGM-114K Hellfire II";
        displayNameShort = "AGM-114K";
        ammo = "J_Hellfire_AGM114K";
        count = 4;
        pylonWeapon = "J_Hellfire_Launcher_K";
        hardpoints[] = {"J_Hellfire","UNI_SCALPEL","B_MISSILE_PYLON"};
    };

    class PylonMissile_1Rnd_J_Hellfire_AGM114N: PylonMissile_1Rnd_J_Hellfire_AGM114K
    {
        displayName = "1x AGM-114N Hellfire II";
        displayNameShort = "AGM-114N";
        ammo = "J_Hellfire_AGM114N";
        pylonWeapon = "J_Hellfire_Launcher_N";
    };
    class PylonRack_3Rnd_J_Hellfire_AGM114N: PylonRack_3Rnd_J_Hellfire_AGM114K
    {
        displayName = "3x AGM-114N Hellfire II";
        displayNameShort = "AGM-114N";
        ammo = "J_Hellfire_AGM114N";
        pylonWeapon = "J_Hellfire_Launcher_N";
    };
    class PylonRack_4Rnd_J_Hellfire_AGM114N: PylonRack_4Rnd_J_Hellfire_AGM114K
    {
        displayName = "4x AGM-114N Hellfire II";
        displayNameShort = "AGM-114N";
        ammo = "J_Hellfire_AGM114N";
        pylonWeapon = "J_Hellfire_Launcher_N";
    };

    class PylonMissile_1Rnd_J_Hellfire_AGM114L: PylonMissile_1Rnd_J_Hellfire_AGM114K
    {
        displayName = "1x AGM-114L Longbow";
        displayNameShort = "AGM-114L";
        ammo = "J_Hellfire_AGM114L";
        pylonWeapon = "J_Hellfire_Launcher_L";
    };
    class PylonRack_3Rnd_J_Hellfire_AGM114L: PylonRack_3Rnd_J_Hellfire_AGM114K
    {
        displayName = "3x AGM-114L Longbow";
        displayNameShort = "AGM-114L";
        ammo = "J_Hellfire_AGM114L";
        pylonWeapon = "J_Hellfire_Launcher_L";
    };
    class PylonRack_4Rnd_J_Hellfire_AGM114L: PylonRack_4Rnd_J_Hellfire_AGM114K
    {
        displayName = "4x AGM-114L Longbow";
        displayNameShort = "AGM-114L";
        ammo = "J_Hellfire_AGM114L";
        pylonWeapon = "J_Hellfire_Launcher_L";
    };
};
