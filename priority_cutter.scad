/* priority_cutter.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

// 4 children:
// Children(0) is the priority inverter mask.
// Children(1...) are the blocks to be cut.
// Children(i) has priority over children(j) if
//   i<j and not children(0), or i>=j and children(0)
module priority_cutter(clear=0, gen=-1) {
//	gen = len(gen)==undef ? gen : 
	
    function maskcheck(x,m) = x<0 || floor(x/pow(2,m)) % 2 == 1;

    for (c=[1:$children-1]) {
        if (maskcheck(gen,c-1)) difference() {
            children(c);
            minkowski() {
                union() {
                    if (c-1 >= 1) difference() {
                        for (i=[1:c-1]) children(i);
                        children(0);
                    }
                    if (c+1 <= $children-1) intersection() {
                        for (i=[c+1:$children-1]) children(i);
                        children(0);
                    }
                }
                cube(clear*[2,2,2], center=true);
            }
        }
    }
}

module priority_cutter_test() priority_cutter(3) {
    // Cutmask
    cube([25,25,25], center=true);
    
    // All plates:
    cube([50,50,3], center=true);
    cube([50,3,50], center=true);
    cube([3,50,50], center=true);
}
