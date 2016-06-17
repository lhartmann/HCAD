/* boundingbox.scad: Creates a cube-like bounding box for any object.
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
 
module boundingbox(BIG=1000) {
    intersection() { 
        minkowski() { aux([  0,   0, 0]); children(); }
        minkowski() { aux([180,   0, 0]); children(); }
        minkowski() { aux([+90,   0, 0]); children(); }
        minkowski() { aux([-90,   0, 0]); children(); }
        minkowski() { aux([  0, -90, 0]); children(); }
        minkowski() { aux([  0, +90, 0]); children(); }
    }

    module aux(r) rotate(r) cylinder(r=BIG, h=BIG, $fn=4);
}
