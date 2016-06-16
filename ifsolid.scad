/* ifsolid.scad: Collision detection conditional for OpenSCAD.
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
 
// Usage:
// ifsolid() {
//     solid_under_test;
//     true_output;  // Test is not empty
//     false_output; // Test is empty
// }
// BIG is the diameter of a sphere large enough to enclose everything.
module ifsolid(BIG=1000) {
	intersection() {
		universe();
		
		intersection() {
			union() {
				children(1);
			}
			minkowski() {
				union() {
					children(0);
					far_far_away();
				}
				universe();
			}
		}
	}
	
	intersection() {
		universe();
		
		difference() {
			children(2);
			minkowski() {
				union() {
					children(0);
					far_far_away();
				}
				universe();
			}
		}
	}
	
	module far_far_away() {
		translate(10*[BIG,BIG,BIG]) cube();
	}
	module universe() {
		cube(BIG*[2,2,2], center=true);
	}
}

// How to propagate ifsolid onto variables:
// ifsolid() {
//     test_solid(); // If test_solid is...
//     varsolid(1); // ... not empty, then render varsolid with parameter 1
//     varsolid(5); // ... empty, then render varsolid with parameter = 5
// }
// Both versions of varsolid are actually rendered, but only one will be in the result.
