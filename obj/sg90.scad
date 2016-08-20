/* sg90.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later.
 */
 
 include <MCAD/units.scad>

// Main body
sg90_w = 22.5;
sg90_h = 22.0;
sg90_d = 12.4;

// Fixation wings
sg90_fw  = 32.15;
sg90_fh  =  2.50;
sg90_fdz =  4.15;

// Fixation screw cuts
sg90_fsd  =  2.0; // Diameter
sg90_fsdx = 27.0; // Distance on x axis
sg90_fsc  = 1.21; // Slot cut width

// Top face
sg90_th =  4.5;
sg90_tw = 14.5;
sg90_td =  5.4;

// Shaft
sg90_sd  = 4.9;
sg90_sh  = 2.9;
sg90_sdy = -(sg90_w-sg90_d)/2; // Position

// Wires
sg90_wh  = 1;
sg90_ww  = 3.5;
sg90_wdz = 4.5;

// Position of anchor points
function sg90_pos(ref) =
	ref == "shaft top"           ? [0, sg90_sdy, sg90_th+sg90_sh] :
	ref == "shaft middle"        ? [0, sg90_sdy, sg90_th+sg90_sh/2] :
	ref == "shaft base"          ? [0, sg90_sdy, sg90_th] :
	ref == "body top center"     ? [0,0,0] :
	ref == "body bottom center"  ? [0,0,-sg90_h] :
	ref == "left screw top"      ? [0, -sg90_fsdx/2, -sg90_fdz] :
	ref == "left screw middle"   ? [0, -sg90_fsdx/2, -sg90_fdz-sg90_fh/2] :
	ref == "left screw bottom"   ? [0, -sg90_fsdx/2, -sg90_fdz-sg90_fh] :
	ref == "right screw top"     ? [0, +sg90_fsdx/2, -sg90_fdz] :
	ref == "right screw middle"  ? [0, +sg90_fsdx/2, -sg90_fdz-sg90_fh/2] :
	ref == "right screw bottom"  ? [0, +sg90_fsdx/2, -sg90_fdz-sg90_fh] :
	ref == "center screw top"    ? [0, 0, -sg90_fdz] : // center body on screw height
	ref == "center screw middle" ? [0, 0, -sg90_fdz-sg90_fh/2] :
	ref == "center screw bottom" ? [0, 0, -sg90_fdz-sg90_fh] :
	ref == "wire"                ? [0, -sg90_w/2, sg90_wdz-sg90_h] :
	[0,0,0];
	
// Translation helper
module sg90_translate(from,to) {
	F = sg90_pos(from);
	T = sg90_pos(to);
	translate(T-F) children();
}

// Original drawing referenced to center of top face
module __sg90() {
	$fn=64;
	
	// Shaft
	color([1,1,1]) translate([0, sg90_sdy, sg90_th])
		cylinder(r=sg90_sd/2, h=sg90_sh);
		
	color([0.25, 0.25, 1]) difference() {
		union() {
			// Main body
			translate([0,0,-sg90_h/2]) cube([sg90_d, sg90_w, sg90_h], center=true);
			
			// Fixation wings
			translate([0, 0, -sg90_fh/2-sg90_fdz]) 
				cube([sg90_d, sg90_fw, sg90_fh], center = true);
			
			// Top face gear protrusions - Big gear
			translate([0,sg90_sdy,0])
				cylinder(r=sg90_d/2, h=sg90_th);
			
			// Top face gear protrusions - Small gear
			translate([0,sg90_sdy,0]) hull() {
				cylinder(r=sg90_td/2, h=sg90_th);
				translate([0,sg90_tw-sg90_d/2-sg90_td/2,0])
				cylinder(r=sg90_td/2, h=sg90_th);
			}
		}
		
		// Fixation screws
		translate([0, -sg90_fsdx/2, 0])
			cylinder(r=sg90_fsd/2, h=sg90_h, center = true);
		translate([0, +sg90_fsdx/2, 0])
			cylinder(r=sg90_fsd/2, h=sg90_h, center = true);

		// Cuts
		translate([0, -sg90_fw/2, 0])
			cube([sg90_fsc, sg90_fw-sg90_fsdx, sg90_h], center=true);
		translate([0, +sg90_fw/2, 0])
			cube([sg90_fsc, sg90_fw-sg90_fsdx, sg90_h], center=true);
		
	}	
}

// Renders the servo motor with the selected position at the origin
module sg90(ref="body top center") {
	sg90_translate(ref,"") __sg90();
}

module sg90_anchor_demo(ref) {
	h = 10;
	module anchor() {
		color([0,0,1]) cylinder(r1=0, r2=0.5, h=h);
		color([0,0,1]) mirror([0,0,1])   cylinder(r1=0, r2=0.5, h=h);
		color([0,1,0]) rotate([+90,0,0]) cylinder(r1=0, r2=0.5, h=h);
		color([0,1,0]) rotate([-90,0,0]) cylinder(r1=0, r2=0.5, h=h);
		color([1,0,0]) rotate([0,+90,0]) cylinder(r1=0, r2=0.5, h=h);
		color([1,0,0]) rotate([0,-90,0]) cylinder(r1=0, r2=0.5, h=h);
	}
	
	sg90_translate(ref,"shaft top") anchor();
	sg90_translate(ref,"shaft middle") anchor();
	sg90_translate(ref,"shaft base") anchor();
	sg90_translate(ref,"left screw top") anchor();
	sg90_translate(ref,"left screw middle") anchor();
	sg90_translate(ref,"left screw bottom") anchor();
	sg90_translate(ref,"right screw top") anchor();
	sg90_translate(ref,"right screw middle") anchor();
	sg90_translate(ref,"right screw bottom") anchor();
	sg90_translate(ref,"center screw top") anchor();
	sg90_translate(ref,"center screw middle") anchor();
	sg90_translate(ref,"center screw bottom") anchor();
	sg90_translate(ref,"wire") anchor();
	sg90_translate(ref,"body top center") anchor();
	sg90_translate(ref,"body bottom center") anchor();
	
	sg90(ref);
}

//sg90_anchor_demo("body bottom center");
