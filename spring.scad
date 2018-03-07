/* spring.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later.
 */
 
include <MCAD/materials.scad>

// Builds a spring, takes space just like a cylinder.
module spring(
	n      = 6,    // turns / loops
	d      = 7.0,  // outer diameter
	wd     = 0.95, // wire diameter
	l      = 14.8, // coil length
	nseg   = 16,   // Number of segments per turnn
	center = false
) {
	color("silver") translate(center ? [0,0,-l/2] : [0,0,0]) rotate([0,-90,0]) {
		X0 = wd;
		X1 = l-wd;
		dX = (X1-X0) / (n-2);

		// First loop is tight
		loop(wd);
		
		// Middle loops are loose
		for (i=[1:n-2]) {
			translate([X0+dX*(i-1), 0, 0]) loop(dX);
		}
		
		// Last loop is tight
		translate([l-wd, 0, 0]) loop(wd);
	}

	module loop(l) {
		for (i=[1:nseg]) {
			ai=i-1;
			hull() {
				rotate([ai/nseg*360, 0, 0])
					translate([ai/nseg*l, (d-wd)/2, 0])
						cylinder(r=wd/2, h=wd/100);
				rotate([i/nseg*360, 0, 0])
					translate([ i/nseg*l, (d-wd)/2, 0])
						cylinder(r=wd/2, h=wd/100);
			}
		}
	}
}
