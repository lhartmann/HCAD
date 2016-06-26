/* deminkowski.scad: A reverse minkowski transformation module.
 * See: https://app.cear.ufpb.br/~lucas.hartmann/2016/02/04/minkowski-subtraction-in-openscad/
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

module deminkowski(BIG=-1) {
    difference() { // Stage 4
        children(0);
        render() minkowski() { // Stage 3
            difference() { // Stage 2
				if (BIG>0) cube(BIG*[2,2,2], center=true);
				else minkowski() { // Stage 1
                    children(0);
                    cube(center=true);
                }
                children(0);
            }
            children(1);
        }
    }
}

