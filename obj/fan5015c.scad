/* fan5015c.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later.
 * 
 * This is still pretty dirty code. do not include<this>, use<this> instead.
 */

// Main body
H = 15.0;
Dr = 26; // Rotor
Di = 31; // Intake

RLT = [
	[0, 22.09],
	[90, 23.80],
	[180, 25.65],
	[270, 27.50]
];

// Exaust walls
bwall = 1.8; // Bottom
twall = 1.0; // Top (air intake side)
swall = 1.2; // Sides

// Exaust opening / Air outlet
xow = 17.6;
xoh = 12.2;
xw = xow + 2*swall;
xl = 25.4;

// Screw hole offsets
s1dx = -18;
s1dy = -20;
s2dx = +20;
s2dy = +23;
Ds   = 4.5; // Screw hole diameter
Dsh  = 3.6*2; // Ds/2 + D/2 + s1dy; // Screw support diameter
//

// Original drawing position:
//   Flat side on XY plane
//   Origin at rotor axis
//   Blower towars -X
module __fan5015c() {
	$fn = 64;
	difference() {
		// Solid starting point
		union() {
			// Main body spiral
			hull() for(a=[-90:8:270]) {
				rotate([0,0,a]) translate([-lookup(a,RLT)+1,0,0]) rotate([0,0,180]) cylinder(r=1, h=H, $fn=3);
			}
			
			// Air exaust
			translate([-xl, 27.5-xw, 0]) cube([xl, xw, H]);
			
			// Screw wings
			hull() {
				translate([s1dx,s1dy,0]) cylinder(r=Dsh/2, h=H);
				translate([s2dx,s2dy,0]) cylinder(r=Dsh/2, h=H);
			}
		}
		
		// Carving
		union() {
			// Main body spiral
			hull() for(a=[-90:8:270]) {
				rotate([0,0,a]) translate([-lookup(a,RLT)+1+swall,0,bwall]) rotate([0,0,180]) cylinder(r=1, h=xoh, $fn=3);
			}
			
			// Air outlet
			translate([-xl-1, 27.5-xow-swall, bwall]) cube([xl+1, xow, xoh]);
			
			// Screw holes
			translate([s1dx,s1dy,-1]) cylinder(r=Ds/2, h=H+2);
			translate([s2dx,s2dy,-1]) cylinder(r=Ds/2, h=H+2);
			
			// Air intake
			translate([0,0,bwall]) cylinder(r=Di/2, h=H);
		}
	}
	
	// Rotor
	cylinder(r=Dr/2, h=H);
	
	// Fins
	for (a=[0:20:350]) {
		rotate([0,0,a]) translate([3-lookup(0,RLT),-swall/4, bwall]) cube([Dr, swall/2, xoh]);
	}
}

// Translate between two parts of the fan
module fan5015c_translate(from, to) {
	F = 
		from == "rotor base"    ? [0,0,0] :
		from == "rotor middle"  ? [0,0,H/2] :
		from == "rotor top"     ? [0,0,H] :
		from == "screw1 base"   ? [s1dx,s1dy,0] :
		from == "screw1 middle" ? [s1dx,s1dy,H/2] :
		from == "screw1 top"    ? [s1dx,s1dy,H] :
		from == "screw2 base"   ? [s2dx,s2dy,0] :
		from == "screw2 middle" ? [s2dx,s2dy,H/2] :
		from == "screw2 top"    ? [s2dx,s2dy,H] :
		from == "intake center" ? [0,0,H] :
		from == "exaust center" ? [-xl, lookup(210,RLT)-xow/2, bwall+xoh/2] :
		[0,0,0];

	T = 
		to == "rotor base"    ? [0,0,0] :
		to == "rotor middle"  ? [0,0,H/2] :
		to == "rotor top"     ? [0,0,H] :
		to == "screw1 base"   ? [s1dx,s1dy,0] :
		to == "screw1 middle" ? [s1dx,s1dy,H/2] :
		to == "screw1 top"    ? [s1dx,s1dy,H] :
		to == "screw2 base"   ? [s2dx,s2dy,0] :
		to == "screw2 middle" ? [s2dx,s2dy,H/2] :
		to == "screw2 top"    ? [s2dx,s2dy,H] :
		to == "intake center" ? [0,0,H] :
		to == "exaust center" ? [-xl, lookup(210,RLT)-xow/2, bwall+xoh/2] :
		[0,0,0];
	
	translate(T-F) children();
}

module fan5015c(ref="rotor base") {
	fan5015c_translate(ref,"origin") __fan5015c();
}