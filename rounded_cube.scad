module rounded_cube(size, r=1, center=false) {
    // Use max radius and scale to keep $fs working.
    m = max(r);
    s = len(r) == undef ? [1,1,1] : r/m;

    // Minkowski with a sphere grows the cuber in every direction.
    // This makes it easier to draw centered, them move is needed.
    translate(center ? [0,0,0] : size/2) {
        render() minkowski() {
            cube(size - m*2*s, center = true);
            scale(s) sphere(r=m);
        }
    }
}
