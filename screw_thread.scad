/* screw_thread.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

// Create an inside UTS thread
// Use negative clearances (cxy,cz) and difference() for outside thread.
module screw_thread(h, Dmaj, P, cxy=0, cz=0, center=false, taper=false) {
	// Names H, P and Dmaj are from Unified Thread Standard
	// See: https://en.wikipedia.org/wiki/Unified_Thread_Standard
	H = P;
	profile = [
		[                 0, +  P/2],
		[Dmaj/2 -   H/4-cxy, +  P/2],
		[Dmaj/2 -   H/4-cxy, +3*P/8-cz],
		[Dmaj/2 + 3*H/8-cxy, + P/16-cz],
		[Dmaj/2 + 3*H/8-cxy, - P/16+cz],
		[Dmaj/2 -   H/4-cxy, -3*P/8+cz],
		[Dmaj/2 -   H/4-cxy, -  P/2],
		[                 0, -  P/2]
	];
	
	// Taper distance along radius.
	taper =
		taper==true  ? H/2 : // If set to true  then taper = pitch/4
		taper==false ?   0 : // If set to false then taper = 0
		taper<0      ?   0 : // If negative     then taper = 0
		taper;               // Otherwise use as number
	// Enveloping cylinder
	taper_r0 = Dmaj/2 + 3*H/8-cxy;
	// Taper start radius
	taper_r1 = taper_r0 - taper;
	// Taper angle same as threads
	taper_r2 = taper_r0 - taper + h * (3/8 - 1/16) / (3/8 - 1/4);
	
	translate(center ? [0,0,-h/2] : [0,0,0]) intersection() {
		// Tapered cylinders
		cylinder(r1=taper_r1, r2=taper_r2, h=h);
		cylinder(r1=taper_r2, r2=taper_r1, h=h);
		
		step = 5; // 5 degrees per segment
		for (i=[-360:step:(ceil(h/P)+1)*360]) {
			translate([0,0,i/360*P]) rotate([0,0,i]) hull() {
				rotate([90,0,0])
					linear_extrude(height=0.001) 
						polygon(points=profile, paths=[1:len(profile)]);
				translate([0,0,step/360*P]) 
					rotate([90,0,step])
						linear_extrude(height=0.001) 
							polygon(points=profile, paths=[1:len(profile)]);
			}
		}
	}
}
