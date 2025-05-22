include <HCAD/m4.scad>

/* like cube(...), but with bells and whistles.
 *
 * r sets roundovers, may a scalar radius or [rx,ry,rz] vector.
 *
 * align extends functionality of center, with per-axis control.
 *   [0,0,0] is centered, same cube(center=true)
 *   [1,1,1] is placed on the positive space, same as cube(center=false)
 *   [0,0,+1] is centered on X and Y, but on the positive Z axis.
 *   [0,0,-1] is centered on X and Y, but on the negative Z axis.
 *   and so on.
 */

module cuboid(size, r=0, center=false, align=[1,1,1]) {
    align = center ? [0,0,0] : align;

    // Use max radius and scale to keep $fs working.
    m = max(r);
    s = len(r) == undef ? [1,1,1] : r/m;

    // Minkowski with a sphere grows the cuber in every direction.
    // This makes it easier to draw centered, them move is needed.

    translate(m4diag(align) * size / 2) render() minkowski() {
        cube(size - m*2*s, center = true);
	if (m>0) scale(s) sphere(r=m);
    }
}
