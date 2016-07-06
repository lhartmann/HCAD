/* mortise_tenon_demo.scad: Creates mortise and tenon joints on arbitrarypoints of a model.
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

include <../../mortise_tenon.scad>

mortise_tenon_demo();
module mortise_tenon_demo() {
    BIG=1000;
    t = $t;

//    intersection() {
    difference() {
        mortise_tenon(5, 2, 0.5, m4tr([12.5,0,12.5])*m4ry(t*360)) 
            rotate([t, 2*t, 3*t]*360) {
                sphere(r=25);
                cylinder(r=25, h=50);
                rotate([0,90,0]) 
                    cylinder(r=25, h=50);
            }
        
        // Slice the object so you can see the mortise-tennon joint.
        cube([100,100,100]);
//        rotate([-90,0,0])
//            cylinder(r=1000, h=1000);
    }
}
