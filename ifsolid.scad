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
	// True output
	intersection() {
		children(1);
		mask_from() children(0);
	}

	// False output
	difference() {
		children(2);
		mask_from() children(0);
	}

	// MASK with minkowski hits nn OpenSCAD bug. For all A:
	//   minkowski(A, void) -> void      Mathematically correct
	//   minkowski(A, void) -> A         OpenSCAD's implementation.
	module mask_from() {
		clear_fake_void() minkowski() {
			universe();
			fake_void() children();
		}
	}

	// Fake void by adding geometry outside the universe.
	module fake_void() {
		translate(10*[BIG,BIG,BIG]) cube();
		children();
	}

	// Remove any geometry outside the universe.
	module clear_fake_void() {
		intersection() {
			universe();
			children();
		}
	}

	// Universe
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
