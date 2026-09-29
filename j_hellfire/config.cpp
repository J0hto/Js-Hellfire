class CfgPatches
{
    class J_Hellfire
    {
        name = "J's Hellfire";
        author = "Johto";
        requiredVersion = 2.10;
        requiredAddons[] = {"A3_Weapons_F","cba_main"};
        units[] = {};
        weapons[] =
        {
            "J_Hellfire_Launcher_K",
            "J_Hellfire_Launcher_N",
            "J_Hellfire_Launcher",
            "J_Hellfire_Launcher_L"
        };
    };
};

class CfgFunctions
{
    class J
    {
        class Hellfire
        {
            file = "\j_hellfire\functions";
            class postInit {postInit = 1;};
            class addActions {};
            class setEmitterCode {};
            class setMissileCode {};
            class registryLoop {};
            class missileInit {};
            // ACE3-derived Hellfire/missileguidance core used by AGM-114K/N.
            class aceCoreInit {};
            class aceGuidancePFH {};
            class aceDoSeekerSearch {};
            class aceSeekerSALH {};
            class aceFindLaserSpot {};
            class aceDoAttackProfile {};
            class aceHellfireGetAttackProfileSettings {};
            class aceHellfireAttackProfile {};
            class aceHellfireMidCourseTransition {};
            class aceNavigationDirect {};
            class aceNavigationZEM {};
            // Retained attack-profile helper used by the AGM-114L Longbow path.
            class attackProfileACE {};
            class longbowInit {};
            class longbowGuidanceLoop {};
            class longbowSeeker {};
            class longbowCheckLOS {};
            class longbowCheckSeekerAngle {};
            class longbowDirect {};
            class longbowZEM {};
            class longbowAutopilot {};
            class getControlPlatform {};
            class controlLoop {};
            class hudLoop {};
            class getCapabilities {};
            class openSystemDialog {};
            class applySystemDialog {};
            class cycleAttackProfile {};
        };
    };
};

#include "Dialog.hpp"
#include "CfgAmmo.hpp"
#include "CfgMagazines.hpp"
#include "CfgMagazineWells.hpp"
#include "CfgWeapons.hpp"
