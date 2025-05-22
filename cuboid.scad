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
