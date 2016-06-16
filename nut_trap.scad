/* nut_trap.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

 include <MCAD/units.scad>
include <nut.scad>

// Original drawing position: origin at the center of the nut
// __nut_trap(5, 10, 25, 1);
module __nut_trap(
	insert_depth_top,  // Center of the nut to the bolt's flush face
	insert_depth_side, // Depth of the nut insertion hole, face to center of nut
	bolt_len,          // Length of the bolt hole from the top face
	clear=0,           // General clearances
    nutmodel = NUT_1_8_INCH
) {
	intersection() {
		// "Slide" the nut in place
		hull() {
			cylinder(r=nutDiameter(nutmodel)/2+clear/cos(30), h=nutHeight(nutmodel)+2*clear, $fn=6, center=true);
			translate([insert_depth_side,0,0]) cylinder(r=nutDiameter(nutmodel)/2+clear/cos(30), h=nutHeight(nutmodel)+2*clear, $fn=6, center=true);
		}
//		cube([2*insert_depth_side+2*clear, 2*nut_1_8_d, 2*nut_1_8_h], center = true);
	}
	// Bolt body
	translate([0,0,insert_depth_top-bolt_len-clear]) cylinder(r=nutDmaj(nutmodel)/2+clear, h=bolt_len+2*clear, $fn=32);
}

function nut_trap_pos(ref, nutmodel=NUT_1_8_INCH) =
	ref == "top face"   ? [0,0,insert_depth_top] :
	ref == "side face"  ? [insert_depth_side,0,0] :
	ref == "nut base"   ? [0,0,-nutHeight(nutmodel)/2] :
	ref == "nut top"    ? [0,0,+nutHeight(nutmodel)/2] :
	ref == "bolt end"   ? [0,0,insert_depth_top-bolt_len] :
	[0,0,0]; // nut middle

module nut_trap_translate(
	insert_depth_top,  // Center of the nut to the bolt's flush face
	insert_depth_side, // Depth of the nut insertion hole, face to center of nut
	bolt_len,          // Length of the bolt hole from the top face
	from,to,
    nutmodel
) {
	F = nut_trap_pos(from, nutmodel);
	T = nut_trap_pos(to,   nutmodel);

	translate(T-F) children();
}

//nut_trap(5, 10, 25, 0, "side face", NUT_1_8_INCH);
module nut_trap(
	insert_depth_top,  // Center of the nut to the bolt's flush face
	insert_depth_side, // Depth of the nut insertion hole, face to center of nut
	bolt_len,          // Length of the bolt hole from the top face
	clear=0,           // General clearances
	ref = "nut middle",
	nutmodel = NUT_1_8_INCH
) {
	nut_trap_translate(
		insert_depth_top, insert_depth_side, bolt_len,
		ref, "origin", nutmodel
	) __nut_trap(
		insert_depth_top, insert_depth_side, bolt_len, clear, nutmodel
	);
}
