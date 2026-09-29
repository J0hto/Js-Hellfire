/*
 * Portions adapted from ACE3 and modified for J's Hellfire by Johto, 2026-09-29.
 * GPL-2.0-or-later; see LICENSE and ACE3-NOTICE.md in the source package.
 */
/*
 * Standalone namespace adaptation of ACE3 Hellfire
 * fnc_midCourseTransition.sqf. Upstream author: tcvm.
 */
params ["_args", "_timestep"];
_args params ["", "", "", "", "_stateParams"];
_stateParams params ["", "", "_attackProfileStateParams"];
_attackProfileStateParams params ["_state"];
_state isEqualTo 4
