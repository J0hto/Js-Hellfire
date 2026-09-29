class J_RscText
{
    type = 0; idc = -1; style = 0; colorBackground[] = {0,0,0,0}; colorText[] = {1,1,1,1};
    font = "RobotoCondensed"; sizeEx = 0.04; text = "";
};
class J_RscEdit
{
    type = 2; idc = -1; style = 0x00 + 0x40; colorBackground[] = {0.08,0.08,0.08,0.95}; colorText[] = {1,1,1,1};
    colorSelection[] = {0.3,0.3,0.3,1}; colorDisabled[] = {0.5,0.5,0.5,1};
    font = "RobotoCondensed"; sizeEx = 0.055; autocomplete = ""; text = ""; shadow = 0;
};
class J_RscButton
{
    type = 1; idc = -1; style = 2; text = ""; font = "RobotoCondensed"; sizeEx = 0.04;
    colorText[] = {1,1,1,1}; colorDisabled[] = {0.4,0.4,0.4,1}; colorBackground[] = {0.2,0.2,0.2,1};
    colorBackgroundDisabled[] = {0.1,0.1,0.1,1}; colorBackgroundActive[] = {0.35,0.35,0.35,1};
    colorFocused[] = {0.35,0.35,0.35,1}; colorShadow[] = {0,0,0,0}; colorBorder[] = {0,0,0,0};
    offsetX = 0; offsetY = 0; offsetPressedX = 0; offsetPressedY = 0; borderSize = 0;
    soundEnter[] = {"",0,1}; soundPush[] = {"",0,1}; soundClick[] = {"",0,1}; soundEscape[] = {"",0,1};
};

class J_SystemDialog
{
    idd = 89143;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['J_SystemDialog_Display', _this select 0]";
    onUnload = "uiNamespace setVariable ['J_SystemDialog_Display', displayNull]";

    class controlsBackground
    {
        class BG: J_RscText
        {
            idc = 1000;
            x = 0.32; y = 0.26; w = 0.36; h = 0.47;
            colorBackground[] = {0.02,0.02,0.02,0.94};
        };
        class Title: J_RscText
        {
            idc = 1001;
            x = 0.34; y = 0.31; w = 0.32; h = 0.05;
            text = "J's Hellfire System";
            sizeEx = 0.04;
        };
        class LaserSection: J_RscText
        {
            idc = 1100;
            x = 0.34; y = 0.375; w = 0.32; h = 0.035;
            text = "LASER DESIGNATOR";
            sizeEx = 0.032;
        };
        class LaserLabel: J_RscText
        {
            idc = 1101;
            x = 0.35; y = 0.415; w = 0.12; h = 0.045;
            text = "Laser Code";
            sizeEx = 0.032;
        };
        class MissileSection: J_RscText
        {
            idc = 1200;
            x = 0.34; y = 0.485; w = 0.32; h = 0.035;
            text = "AGM-114K/N SEEKER";
            sizeEx = 0.032;
        };
        class MissileLabel: J_RscText
        {
            idc = 1201;
            x = 0.35; y = 0.525; w = 0.12; h = 0.045;
            text = "Hellfire Code";
            sizeEx = 0.032;
        };
        class ProfileNote: J_RscText
        {
            idc = 1300;
            x = 0.35; y = 0.585; w = 0.30; h = 0.035;
            text = "LOW / HI: 1.7 km+ recommended";
            sizeEx = 0.026;
            colorText[] = {0.7,0.7,0.7,1};
        };
    };

    class controls
    {
        class LaserEdit: J_RscEdit
        {
            idc = 1400;
            x = 0.49; y = 0.412; w = 0.14; h = 0.05;
        };
        class MissileEdit: J_RscEdit
        {
            idc = 1401;
            x = 0.49; y = 0.522; w = 0.14; h = 0.05;
        };
        class ApplyButton: J_RscButton
        {
            idc = 1600;
            x = 0.39; y = 0.665; w = 0.10; h = 0.045;
            text = "APPLY";
            action = "[] call J_fnc_applySystemDialog";
        };
        class CancelButton: J_RscButton
        {
            idc = 1601;
            x = 0.51; y = 0.665; w = 0.10; h = 0.045;
            text = "CANCEL";
            action = "closeDialog 0";
        };
    };
};

class RscTitles
{
    class J_Hellfire_HUD
    {
        idd = 89141;
        duration = 1e10;
        fadeIn = 0;
        fadeOut = 0;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['J_Hellfire_HUD_Display', _this select 0]";
        onUnload = "uiNamespace setVariable ['J_Hellfire_HUD_Display', displayNull]";
        class controls
        {
            class CodeText: J_RscText
            {
                idc = 89142;
                text = "LASER CODE: 1111";
                x = safeZoneX + safeZoneW - 0.31;
                y = safeZoneY + 0.155;
                w = 0.28;
                h = 0.04;
                style = 1;
                sizeEx = 0.032;
                colorBackground[] = {0,0,0,0.35};
            };
        };
    };
};
