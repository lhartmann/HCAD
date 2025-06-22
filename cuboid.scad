include <m4.scad>

/* like cube(...), but with bells and whistles.
 *
 * r sets roundovers, may a scalar radius or [rx,ry,rz] vector.
 * b sets bevels, may a scalar radius or [bx,by,bz] vector.
 *
 * align extends functionality of center, with per-axis control.
 *   [0,0,0] is centered, same cube(center=true)
 *   [1,1,1] is placed on the positive space, same as cube(center=false)
 *   [0,0,+1] is centered on X and Y, but on the positive Z axis.
 *   [0,0,-1] is centered on X and Y, but on the negative Z axis.
 *   and so on.
 */

module cuboid(size=[1,1,1], r=0, b=0, center=false, align=[1,1,1]) {
    align = center ? [0,0,0] : align;

    // Use max radius and scale to keep $fs working.
    mr = max(r);
    sr = is_scalar(r) ? [1,1,1] : r/mr;

    mb = max(b);
    sb = is_scalar(b) ? [1,1,1] : b/mb;
    
    // Minkowski with a sphere grows the cuber in every direction.
    // This makes it easier to draw centered, them move is needed.

    translate(m4diag(align) * size / 2) render() minkowski() {
        cube(size - mr*2*sr - mb*2*sb, center = true);
        if (mr>0) scale(sr) sphere(r=mr);
        if (mb>0) diamond();
    }

    module diamond() scale(sb) {
        pyramid();
        mirror([0,0,1]) pyramid();
    }
    module pyramid() {
        cylinder(r1=mb, h=mb, r2=0, $fn=4);
    }

    function is_scalar(x) = r == max(x);
}
