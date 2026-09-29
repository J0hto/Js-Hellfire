/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
class CfgAmmo
{
    class M_Scalpel_AT;

    class J_Hellfire_AGM114K: M_Scalpel_AT
    {
        author = "Johto";
        displayName = "AGM-114K Hellfire II";
        displayNameShort = "AGM-114K";

        model = "\A3\Weapons_F\Ammo\Missile_AT_03_fly_F";
        proxyShape = "\A3\Weapons_F\Ammo\Missile_AT_03_F";
        effectsMissile = "missile2";

        // J's Hellfire controls this projectile after launch.
        // Do not globally alter vanilla ammo/weapon classes.
        laserLock = 0;
        irLock = 0;
        airLock = 0;
        manualControl = 0;

        /*
         * v0.8.2: K/L deliberately inherit the complete M_Scalpel_AT
         * anti-armor warhead instead of replacing it with custom scalar damage.
         * This mirrors ACE's K -> M_Scalpel_AT and L -> K inheritance.
         */

        // ACE3 AGM-114K flight envelope (current upstream).
        maxSpeed = 450;
        thrustTime = 2.5;
        thrust = 250;
        timeToLive = 40;

        class EventHandlers
        {
            init = "_this call J_fnc_missileInit";
        };
    };

    class J_Hellfire_AGM114N: J_Hellfire_AGM114K
    {
        displayName = "AGM-114N Hellfire II";
        displayNameShort = "AGM-114N";

        // ACE3 AGM-114N MAC warhead values (current upstream).
        // Guidance is inherited unchanged from K.
        hit = 200;
        indirectHit = 200;
        indirectHitRange = 12;
        submunitionAmmo = "";
        explosionEffects = "BombExplosion";

        // ACE's vehicle_damage module consumes this when present. It is kept
        // as source-compatible metadata; J's standalone build does not require
        // ace_vehicle_damage.
        ace_vehicle_damage_incendiary = 0.3;

        // Do not override EventHandlers: inherit K's ACE-core missile init.
    };

    class J_Hellfire_AGM114L: J_Hellfire_AGM114K
    {
        displayName = "AGM-114L Longbow Hellfire";
        displayNameShort = "AGM-114L";

        // Longbow only: do not alter vanilla or K/N classes.
        // Flight values aligned to current ACE AGM-114L.
        maxSpeed = 450;
        thrustTime = 2.5;
        thrust = 250;
        timeToLive = 40;

        laserLock = 0;
        irLock = 0;
        airLock = 1;
        manualControl = 0;
        weaponLockSystem = 8;
        maneuvrability = 0;
        missileLockMaxDistance = 8000;
        missileLockMinDistance = 250;
        missileLockMaxSpeed = 600;
        missileKeepLockedCone = 70;
        cmImmunity = 0.9;

        class Components
        {
            class SensorsManagerComponent
            {
                class Components
                {
                    class LongbowRadar
                    {
                        componentType = "ActiveRadarSensorComponent";
                        class AirTarget
                        {
                            minRange = 0;
                            maxRange = 8000;
                            objectDistanceLimitCoef = -1;
                            viewDistanceLimitCoef = -1;
                        };
                        class GroundTarget
                        {
                            minRange = 0;
                            maxRange = 8000;
                            objectDistanceLimitCoef = -1;
                            viewDistanceLimitCoef = -1;
                        };
                        typeRecognitionDistance = 4000;
                        angleRangeHorizontal = 70;
                        angleRangeVertical = 70;
                        groundNoiseDistanceCoef = 0;
                        maxGroundNoiseDistance = 250;
                        minSpeedThreshold = 0;
                        maxSpeedThreshold = 600;
                        nightRangeCoef = 1;
                        maxFogSeeThrough = 0.8;
                    };
                };
            };
        };

        class EventHandlers
        {
            init = "_this call J_fnc_longbowInit";
        };
    };
};
