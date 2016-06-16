include <MCAD/units.scad>

// Bolts = [ Dmaj, diameter, head diameter, head height, head tool, thread length ]
BOLT_1_8_INCH = [ 1/8*inch, 3.09*mm, 6*mm, 2.2*mm, 1.1*mm, 40*mm ];
function boltDmaj(bolt)         = bolt[0]; // Nominal thread diameter
function boltDiameter(bolt)     = bolt[1]; // Actual thread diameter
function boltHeadDiameter(bolt) = bolt[2];
function boltHeadHeight(bolt)   = bolt[3];
function boltHeadTool(bolt)     = bolt[4]; // Slot tool only
function boltLength(bolt)       = bolt[5]; // Not counting head

// Constructor / Modifier
function boltSet(b=BOLT_1_8_INCH, Dmaj=false, d=false, hd=false, hh=false, ht=false, l=false) =
	[
		Dmaj != false ? Dmaj : boltDmaj(b),
		d    != false ? d    : boltDiameter(b),
		hd   != false ? hd   : boltHeadDiameter(b),
		hh   != false ? hh   : boltHeadHeight(b),
		ht   != false ? ht   : boltHeadTool(b),
		l    != false ? l    : boltLengthl(b)
	];

// translate([0,0,5]) bolt(10);
module bolt(model=BOLT_1_8_INCH, ref="head") {
	T = 
		ref == "end" ? [0,0,boltLength(model)] :
		ref == "head top" ? [0,0,-boltHeadHeight(model)] :
		[0,0,0];
	
	$fn=32;
	translate(T) {
		// Bolt body, towards -Z
		mirror([0,0,1]) cylinder(r=boltDiameter(model)/2, h=boltLength(model));

		// Bolt Head
		difference() {
			// Half sphere
			intersection() {
				cylinder(r=boltHeadHeight(model), h=boltHeadHeight(model));
				scale([
                    boltHeadDiameter(model)/2,
                    boltHeadDiameter(model)/2,
                    boltHeadHeight(model)
                ]/100) sphere(r=100);
			}
			
			// Tool slot
			translate([0,0,1.5*boltHeadHeight(model)])
                cube([
                    boltHeadTool(model),
                    boltHeadDiameter(model),
                    2*boltHeadHeight(model)
                ], center = true);
		}
	}
}
