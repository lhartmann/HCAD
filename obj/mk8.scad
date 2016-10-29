/* mk8.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later.
 */
 
include <MCAD/units.scad>
include <MCAD/materials.scad>
include <HCAD/m4.scad>

mk8_di  =  5.03*mm; // Inner Diameter
mk8_d   =  8.95*mm; // Main Diameter
mk8_h   = 11.00*mm; // Total Height
mk8_df  =  7.29*mm; // Filament channel diameter
mk8_hf  =  3.47*mm; // Filament channel height
mk8_ffb =  8.40*mm; // Filament channel center from MK8 bottom
mk8_sod =  2.95*mm; // Fixation screw outer diameter (UTS #3 or #4)
mk8_sfb =  2.79*mm; // Fixation screw center from bottom.
mk8_chm =  0.25*mm; // Chamfered edges

module __mk8() {
	// This profile creates a tube with chamfered edges
	profile = [
		[mk8_di/2,         mk8_h-mk8_chm],
		[mk8_di/2+mk8_chm, mk8_h],
		[mk8_d/2-mk8_chm,  mk8_h],
		[mk8_d/2,          mk8_h-mk8_chm],
		[mk8_d/2,          mk8_chm],
		[mk8_d/2-mk8_chm,  0],
		[mk8_di/2+mk8_chm, 0],
		[mk8_di/2,         mk8_chm]
	];

	color(Aluminum) rotate_extrude(, $fn=32) {
		difference() {
			polygon(points=profile);
			translate([mk8_d/2, mk8_ffb])
				scale([(mk8_d-mk8_df)/mk8_hf,1,1])
				circle(r=mk8_hf/2, $fn=32);
		}
	}
}

function mk8_tm(ref, fd=1.75) = 
	ref == "top"      ? m4tr([0,0,mk8_h]) :
	ref == "filament" ? m4tr([0,0,mk8_ffb]) :
	ref == "screw"    ? m4tr([0,0,mk8_sfb]) :
	ref == "base"     ? m4tr([0,0,0]) :
	[0,0,0];

module mk8(ref="base") {
	multmatrix(m4inv(mk8_tm(ref))) __mk8();
}

// Testing:
if(0) mk8("filament");
