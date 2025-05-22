/* semispace.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2024.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later.
 */

// Creates a solid on the chosen semispace.
// normal defines the orientation of the plane cut
// offset defines the distance from origin to semiplane along the normal.
// offset>0 moves semispace away from the origin
// offset<0 moves semispace closer to the origin

module semispace(normal=[0,0,1], off=1, BIG=1000) {
    normal = normal / norm(normal);
    
    rotate([0, -asin(normal[2]), atan2(normal[1], normal[0])])
    translate([BIG + off, 0, 0])
    cube(BIG*[2,2,2], center=true);
}

// Same thing, but 2D
module semiplane(normal=[1,0], off=1, BIG=1000) {
    normal = normal / norm(normal);
    
    rotate(atan2(normal[1], normal[0]))
    translate([BIG + off, 0])
    square(BIG*[2,2], center=true);
}
