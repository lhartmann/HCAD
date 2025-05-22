/* spring.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2024.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later.
 */

module clip_x(low, high, BIG=1000) {
    intersection() {
        translate([low, -BIG, -BIG])
            cube([high-low, 2*BIG, 2*BIG]);
        children();
    }
}
module clip_y(low, high, BIG=1000) {
    intersection() {
        translate([-BIG, low, -BIG])
            cube([2*BIG, high-low, 2*BIG]);
        children();
    }
}
module clip_z(low, high, BIG=1000) {
    intersection() {
        translate([-BIG, -BIG, low])
            cube([2*BIG, 2*BIG, high-low]);
        children();
    }
}
