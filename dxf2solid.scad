/* dxf2solid.scad: A quick and dirty way to build solids from sketches.
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2020.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 * 
 * To use this:
 *   Draw on (X+, Y+) the front view.
 *   Draw on (X-, Y+) the side view.
 *   Draw on (X+, Y-) the top view.
 *   Call dxf2solid(...)
 *   Use multiple layers to add/subtract/intersect features.
 * 
 * dxf2solid("a.dxf");              uses all layers as views.
 * dxf2solid("a.dxf", "outline");   uses only views in layer "outline".
 * 
 * BIG must be greater than the largest coordinate used in your file.
 * I use metric and do 3D printing, so 1000mm felt like a good default.
 */

module dxf2solid(dxf, layer=false, BIG=1000, debug=false) {
	intersection() {
		_dxf2solid();
		rotate([0,+90,0]) _dxf2solid();
		rotate([-90,0,0]) _dxf2solid();
	}

	if (debug) %render() {
		_dxf2solid();
		rotate([0,+90,0]) _dxf2solid();
		rotate([-90,0,0]) _dxf2solid();
	}
	
	module _dxf2solid()
		linear_extrude(height=BIG)
		if (layer) import(dxf, layer);
		else import(dxf);
}
