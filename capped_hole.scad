/* capped_hole.scad: Helper to create holes with thin-wall supports.
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 * 
 * Usage is similar to difference.
 * 
 * capped_hole() {
 *    solid_body();
 *    holes();
 * }
 * 
 * w is the width of the skin / thin wall that covers all the holes.
 * 
 * BIG is the diameter of a sphere large enough to enclose the whole solid.
 * BIG=-1 (default) uses minkowski to grow the original solid. Foolprof, but slow.
 */

module capped_hole(w=0.3, BIG=-1) {
	// Step 5: Finally carve the holes from the solid.
	difference() {
		// The main solid body
		children(0);
		
		// Step 4: Subtract skin (and mould) from holes().
		// This will reduce the size of the holes(), so that they do not pierce
		// through the skin.
		difference() {
			for (i=[1:$children-1]) children(i);
			
			// Step 3: Grow the skin on the mould.
			// This reduces the mould hollow by skin size.
			// The skin actually grows on all sides, but focus on the inside.
			minkowski() {
				sphere(r=w, $fn=8);
				
				// Step 2: Carve the main solid from the mould
				difference() {
					// Step1: Create the base mould solid
					if (BIG < 0) {
						// Autodetect shell size: grow from main solid.
						// This is slower, but failproof.
						minkowski() {
							children(0);
							cube(center=true);
						}
					} else {
						// Manually informed shell size, faster;
						cube(BIG*[2,2,2], center=true);
					}
					
					// Main solid => Mould hollow
					children(0);
				}
			}
		}
	}
}
