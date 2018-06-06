/* makecase.scad: Functionality similar to makercase.com, except made in openscad.
 *
 * Original by Lucas V. Hartmann <first_name dot last_name at G's mail>, 2018.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 *
 * Special note for laser cutting: If flipBottom is enabled then the walls are 
 * created so that you can assemble the top on the hole left by cutting it.
 * This enables you to create pocket-like features     _____       _____
 * with minimum waste.                                      \_____/
 *
 * openTop when set to true removes the finger pattern from the top cover.
 * In order to respect boxSize the the top face should sit on top of the walls,
 * which means the walls will be shorter by 'thick.'
 *
 * kerf compensation is used to make teeth tighter. Only the side walls are affected
 * no top or bottom (or it would break flipBottom pocket feature).
 */

if (false) makecase(flat=true, flipBottom=true);

module makecase(
	thick      = 1.8,          // Wall (sheet) thickness
	boxSize    = [75, 75, 20], // Box outside dimensions
	teeth      = [ 3,  3,  1], // Number of teeth along each axis.
	teethSize  = [10, 10,  8], // Width of teeth along each axis.
	spaceSize  = [10, 10,  0], // Spacing between teeth along each axis.
	flipBottom = false,        // Flip teeth/spacing on the bottom face.
	openTop    = false,        // Create no finger-joint pattern on top
	kerf   = 0,     // Laser/CNC cut width.
	center = false, // Center single-face drawings
	top    = false, // Generate 2D profile for the top.
	bottom = false, // Generate 2D profile for the bottom.
	left   = false, // Generate 2D profile for the left-side.
	right  = false, // Generate 2D profile for the right-side.
	front  = false, // Generate 2D profile for the front.
	back   = false, // Generate 2D profile for the back.
	flat   = false, // Generate 2D flat profile with all faces like an open dice.
	assembled = false // Generate a 3D mounted box, just for checking.
) {
	boxSize = openTop ? boxSize - [0,0,thick] : boxSize;
	pad = [
		(boxSize[0] - teeth[0] * teethSize[0] - (teeth[0]-1) * spaceSize[0]) / 2,
		(boxSize[1] - teeth[1] * teethSize[1] - (teeth[1]-1) * spaceSize[1]) / 2,
		(boxSize[2] - teeth[2] * teethSize[2] - (teeth[2]-1) * spaceSize[2]) / 2
	];
	
	if (pad[0] < 0) echo("Error: makecase can not fit teeth along X axis.");
	if (pad[1] < 0) echo("Error: makecase can not fit teeth along Y axis.");
	if (pad[2] < 0) echo("Error: makecase can not fit teeth along Z axis.");
	
	// Possible renders:
	if (top)    translate(center ? [-boxSize[0], -boxSize[1]]/2 : [0,0,0]) _top();
	if (bottom) translate(center ? [-boxSize[0], -boxSize[1]]/2 : [0,0,0]) _bottom();
	if (left)   translate(center ? [-boxSize[2], -boxSize[1]]/2 : [0,0,0]) _left();
	if (right)  translate(center ? [-boxSize[2], -boxSize[1]]/2 : [0,0,0]) _right();
	if (front)  translate(center ? [-boxSize[0], -boxSize[2]]/2 : [0,0,0]) _front();
	if (back)   translate(center ? [-boxSize[0], -boxSize[2]]/2 : [0,0,0]) _back();
	if (flat) { // Flattened dice-like positioning of all faces
		_top();
		translate([-boxSize[2]-10, 0]) _left();
		translate([+boxSize[0]+10, 0]) _right();
		translate([0, +boxSize[1]+10]) _back();
		translate([0, -boxSize[2]-10]) _front();
		translate([+boxSize[0] + boxSize[2] + 20, 0]) _bottom();
	}
	if (assembled) { // 3D assembled (should be just a box)
		translate([0,0,boxSize[2]-thick]) _le() _top();
		_le() _bottom();
		translate([thick, 0, 0])
			rotate([0,-90,0]) _le() _left();
		translate([boxSize[0]-thick, 0, boxSize[2]])
			rotate([0,+90,0]) _le() _right();
		translate([0, +boxSize[1]-thick, +boxSize[2]])
			rotate([-90,0,0]) _le() _back();
		translate([0, +thick, 0])
			rotate([+90,0,0]) _le() _front();
	}
	
	// Auxiliary submodules
	
	// Create a 3D extruded face
	module _le() linear_extrude(height=thick) children();
	
	// Create specific faces
	module _top()
		face(0,1, [0,0,0,0], [openTop,openTop,openTop,openTop]);
	module _bottom()
		face(0,1, flipBottom ? [1,1,1,1] : [0,0,0,0]);
	module _left()
		_kerf(0,kerf)
		face(2,1, flipBottom ? [0,0,0,1] : [0,0,1,1], [false, false, false, openTop]);
	module _right()
		_kerf(0,kerf)
		face(2,1, flipBottom ? [0,0,1,0] : [0,0,1,1], [false, false, openTop, false]);
	module _front()
		_kerf(kerf,0)
		face(0,2, flipBottom ? [0,1,1,1] : [1,1,1,1], [false, openTop, false, false]);
	module _back()
		_kerf(kerf,0)
		face(0,2, flipBottom ? [1,0,1,1] : [1,1,1,1], [openTop, false, false, false]);
	
	// Create a generic face
	module face(i,j,flips=[false,false,false,false],banguela=[false,false,false,false]) {
		difference() {
			square([boxSize[i], boxSize[j]]);
			
			if (!banguela[0])
				teeth_pattern(pad[i], spaceSize[i], teethSize[i], thick, teeth[i], !flips[0]);
			
			if (!banguela[1]) translate([0, boxSize[j]])
				teeth_pattern(pad[i], spaceSize[i], teethSize[i], thick, teeth[i], !flips[1]);
				
			if (!banguela[2]) rotate([0,0,90])
				teeth_pattern(pad[j], spaceSize[j], teethSize[j], thick, teeth[j], !flips[2]);
				
			if (!banguela[3]) translate([boxSize[i],0]) rotate([0,0,90])
				teeth_pattern(pad[j], spaceSize[j], teethSize[j], thick, teeth[j], !flips[3]);
		}
	}
	
	// Compensate kerf
	module _kerf(kx, ky) minkowski() {
		kx = kx==0 ? 1e-12 : kx;
		ky = ky==0 ? 1e-12 : ky;
		if (kerf) square([kx,ky], center=true);
		union() children();
	}
	
	// Create a vertically centered teeth pattern along X+ axis:
	//   pad teeth space teeth space ... teeth pad
	// if flip then teeth are solid
	// else pad and spaces are solid
	module teeth_pattern(pad, space, teeth, thick, count, flip=false) {
		// Create the pattern
		_p(0);
		
		if (count >= 1) for (i=[0:count-1])
			_t(pad + i*(space+teeth));
		
		if (count >= 2) for (i=[0:count-2])
			_s(pad + teeth + i*(space+teeth));
		
		_p(pad + count*teeth + (count-1)*space);
		
		// Auxiliary submodules
		module _p(at) if (flip)
			translate([at, -thick]) square([pad, 2*thick]);
		module _t(at) if (!flip) 
			translate([at, -thick]) square([teeth, 2*thick]);
		module _s(at) if (flip)
			translate([at, -thick]) square([space, 2*thick]);
	}
}
